//
//  UserProfileViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PictureCell.h"
#import "InfoCell.h"
#import "PostsByUserCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EditProfileViewController.h"
#import "TTTTimeIntervalFormatter.h"
#import <Accelerate/Accelerate.h>
#import "UIImage+StackBlur.h"
#import <Parse/Parse.h>
#import "MessagingViewController.h"
#import "ProfileInterestCell.h"
#import "SpinnerViewController.h"
#import "SWRevealViewController.h"
#import "PostCell.h"
#import "PFImageView+ImageHandler.h"
#import "CommentViewController.h"
#import "NotificationIndicatorViewController.h"
#import "ActivityFeedViewController.h"
#import "CheckInDetailViewController.h"
#import "ParseServices.h"


#define kLoadingCellTag 7
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:14.0]


typedef enum {
    currentUserFromMenu, ownerUser, otherUser
} UserState;


@interface UserProfileViewController ()
{
    UIBarButtonItem *spacerButton;
    UIBarButtonItem *doneButton;
    UIImage *profilePicture;
    UIImage *profilePictureBlur;
    CGRect aboutCellHeight;
    CGRect postCellHeight;
    TTTTimeIntervalFormatter *timeFormatter;
    UILabel *headerLabelViewSection2;
    int index;
    SpinnerViewController *spinner;
    BOOL isAll;
    PFFile *imageFile;
}

@property (nonatomic) UserState userState;
@property (strong, nonatomic) NSArray *interestsArray;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation UserProfileViewController

@synthesize userInfosArray;
@synthesize userProfileTableView;
@synthesize editButton;
@synthesize sideBarButton;
@synthesize user;
@synthesize userProfilePicture;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkUser];
    [self intializeNeededStuff];
    [self fetchUserInterests];
    [self loadPostsByUser];
}

- (void)intializeNeededStuff
{
    //spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    headerLabelViewSection2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    profilePictureBlur = [self.userProfilePicture stackBlur:10];
}


- (void)checkInMapImageWasTappedInCell:(PostCell *)cell
{
    NSIndexPath *indexPath = [userProfileTableView indexPathForCell:cell];
    PFObject *checkIn = [self.postsArray[indexPath.row] objectForKey:@"checkIn"];
    
    UIStoryboard *feedSB = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    CheckInDetailViewController *checkInDetailVC = [feedSB instantiateViewControllerWithIdentifier:@"checkInDetailVC"];
    
    checkInDetailVC.checkIn = checkIn;
    
    [self.navigationController pushViewController:checkInDetailVC animated:YES];
}


- (void)flagPostInCell:(PostCell *)cell
{
    NSIndexPath *indexPath;
    PFObject *post;
    PFObject *flaggedPost;
    PFUser   *postCreator;
    
    indexPath   = [userProfileTableView indexPathForCell:cell];
    post        = self.postsArray[indexPath.row];
    flaggedPost = [PFObject objectWithClassName:@"FlaggedActivities"];
    postCreator = post[@"user"];
    
    [flaggedPost setObject:[PFUser currentUser] forKey:@"flaggedBy"];
    [flaggedPost setObject:postCreator forKey:@"originalPoster"];
    [flaggedPost setObject:post forKey:@"activity"];
    
    [post incrementKey:@"flagCount"];
    
    [flaggedPost saveEventually:^(BOOL succeeded, NSError *error)
                                 {
                                     if (succeeded)
                                         [self presentAlertViewForFlaggedPost];
                                     else
                                         NSLog(@"Flag didn't work : ERROR %@", error);
                                 }];
}


- (void)presentAlertViewForFlaggedPost
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"JustMovd has received your report and will look into the matter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}


- (void)avatarImageWasTappedInCell:(PostCell *)cell
{
    //Not implementing this in UserProfileVC
}


- (void)checkUser
{
    if (!self.user)
    {
        [self handleViewState:currentUserFromMenu];
        self.user = [PFUser currentUser];
        [self getImageForFile:self.user[@"profilePictureFile"]];
        return;
    }
    
    if ([self.user[@"username"] isEqualToString:[PFUser currentUser][@"username"]])
    {
        [self handleViewState:ownerUser];
        return;
    }
    else
        [self handleViewState:otherUser];
}


- (void)handleViewState:(UserState)state
{
    if (state == currentUserFromMenu)
    {
        [self showEditButton:YES];
    }
    
    if (state == ownerUser)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self showEditButton:NO];
    }
    
    if (state == otherUser)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self showEditButton:NO];
    }
}


- (void)getImageForFile:(PFFile *)file
{
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        userProfilePicture = [UIImage imageWithData:data scale:2.0];
        profilePictureBlur = [self.userProfilePicture stackBlur:10];
    }];
}


- (void)loadPostsByUser
{
    //[spinner.view setHidden:NO];
    
    [ParseServices queryForPostsByUser:self.user completionBlock:^(NSArray *results, BOOL success) {
        if (success) {
            self.postsArray = nil;
            self.postsArray = results;
            [userProfileTableView reloadData];
        }
        else {
            NSLog(@"Error loading posts by user");
        }
        
        //[spinner.view setHidden:YES];
        //NSLog(@"Posts by user: %@", self.postsArray);
    }];
}


- (void)fetchUserInterests
{
    [ParseServices queryForInterestsForUser:self.user
                            completionBlock:^(NSArray *results, BOOL success)
                                             {
                                                 if (success)
                                                 {
                                                     self.interestsArray = nil;
                                                     self.interestsArray = results;
                                                     [userProfileTableView reloadData];
                                                 }
                                                 else NSLog(@"Handle Error fetching interests");
                                             }];
}


- (void)updateAboutString:(NSString *)about andLocationString:(NSString *)location
{
    if (user == [PFUser currentUser])
    {
        [user setObject:about forKey:@"about"];
        [user setObject:location forKey:@"location"];
        [userProfileTableView reloadData];
    }
}

- (NSString *)getStringForUsersAge
{
    NSInteger age;
    
    age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[user objectForKey:@"birthday"]];
    
    return [NSString stringWithFormat:@"%d", age];
}


- (NSInteger)calculateYearsFromDateStringWithFormatMMddyyyy:(NSString *)dateString
{
    //Convert age
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthday = [dateFormatter dateFromString:dateString];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    return [ageComponents year];
}


- (void)showEditButton:(BOOL)state
{
    if (state) {
        [editButton setTitle:@"Edit"];
        [editButton setEnabled:state];
    }
    else {
        [editButton setTitle:@""];
        [editButton setEnabled:state];
    }
}


- (NSString *)getImageNameFromString:(NSString *)string
{
    if ([string isEqualToString:@"Drink Beer"]) {
        return @"beer_size@2x";
    }
    else if ([string isEqualToString:@"Lift Weights"]) {
        return @"weightlifting_circle";
    }
    else if ([string isEqualToString:@"Play Sports"]) {
        return @"sports_circle";
    }
    else if ([string isEqualToString:@"Do Yoga"]) {
        return @"yoga_circle";
    }
    else if ([string isEqualToString:@"Drink Coffee"]) {
        return @"coffee_circle";
    }
    else if ([string isEqualToString:@"Play Games"]) {
        return @"vidgame_circle";
    }
    else if ([string isEqualToString:@"Watch TV"]) {
        return @"tv";
    }
    else {
        return @"book";
    }
}


- (NSString *)setCommentCount:(NSNumber *)count
{
    int x = [count intValue];
    
    if (x == 0)
        return @"Add Comment";
    else if (x == 1)
        return [NSString stringWithFormat:@"%@ Comment", count];
    else
        return [NSString stringWithFormat:@"%@ Comments", count];
}


- (NSString *)setTimeSincePostDate:(NSDate *)date
{
    NSString *timeString;
    
    if (!date) date = [NSDate date];
    timeFormatter   = [TTTTimeIntervalFormatter new];
    timeString      = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date];
    
    return timeString;
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else
        return self.postsArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerLabelViewSection2.textAlignment = NSTextAlignmentCenter;
    headerLabelViewSection2.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    headerLabelViewSection2.textColor = [UIColor lightGrayColor];
    if ([self.postsArray count] == 0)
    {
        headerLabelViewSection2.backgroundColor = [UIColor clearColor];
        headerLabelViewSection2.text = @"No Recent Activity";
    }
    else
    {
        headerLabelViewSection2.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.5];
        headerLabelViewSection2.text = [NSString stringWithFormat:@"%@'s Recent Activity", user[@"firstName"]];
    }
    
    return headerLabelViewSection2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    else
        return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            return 320;
        
        if (indexPath.row == 1)
        {
            aboutCellHeight = [self.user[@"about"] boundingRectWithSize:CGSizeMake(290.0, FLT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
            
            return aboutCellHeight.size.height + 50;//(aboutCellHeight.size.height < 30) ? 50.0 : (aboutCellHeight.size.height + 50);
        }
        else
            return 85.0;
    }
    else
    {
        NSString *textString;
        CGRect textRect;
        int checkInHeight;
        
        // CheckinHeight is equal to the check in label and image views on the cell
        checkInHeight = 190;
        
        textString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
        textRect = [textString boundingRectWithSize:CGSizeMake(200.0, FLT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0]}
                                            context:nil];
        
        if ([self.postsArray[indexPath.row] objectForKey:@"checkIn"] != nil) {
            return (textRect.size.height + checkInHeight + 110);
        }
        else return (textRect.size.height + 130);
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell     *returnCell;
    PictureCell         *pictureCell;
    InfoCell            *infoCell;
    ProfileInterestCell *interestCell;
    
    
    static NSString *pictureCellID  = @"pictureCell";
    static NSString *interestCellID = @"interestCell";
    static NSString *infoCellID     = @"infoCell";
    
    
    pictureCell  = [tableView dequeueReusableCellWithIdentifier:pictureCellID];
    interestCell = [tableView dequeueReusableCellWithIdentifier:interestCellID];
    infoCell     = [tableView dequeueReusableCellWithIdentifier:infoCellID];
    
    
    if (!interestCell) {
        interestCell = [[ProfileInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:interestCellID];
        [interestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (!infoCell) {
        infoCell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellID];
    }
    
    NSString *name     = self.user[@"firstName"];
    NSString *location = self.user[@"location"];
    NSString *age      = [self getStringForUsersAge];


    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                pictureCell.profilePictureBlur.image = profilePictureBlur;
                pictureCell.profilePictureOriginal.image = userProfilePicture;
                pictureCell.usernameLabel.text = [NSString stringWithFormat:@"%@, %@", name, age];
                pictureCell.fromTownLabel.text = [NSString stringWithFormat:@"via %@", location];
                if (!user || [user.username isEqualToString:[PFUser currentUser].username]) {
                    [pictureCell.messageButton setHidden:YES];
                }
                returnCell = pictureCell;
                break;
                
            case 1:
                infoCell.titleLabel.text = @"About:";
                infoCell.descriptionLabel.text = self.user[@"about"];
                returnCell = infoCell;
                break;
                
            case 2:
                interestCell.titleLabel.text = @"Interests:";
                interestCell.firstImageView.image = [UIImage imageNamed:[self getImageNameFromString:self.interestsArray[0]]];
                interestCell.secondImageView.image = [UIImage imageNamed:[self getImageNameFromString:self.interestsArray[1]]];
                interestCell.thirdImageView.image = [UIImage imageNamed:[self getImageNameFromString:self.interestsArray[2]]];
                interestCell.fourthImageView.image = [UIImage imageNamed:[self getImageNameFromString:self.interestsArray[3]]];
                returnCell = interestCell;
                break;
        }
    }
    else
    {
        PostCell *cell;
        PFObject *checkIn;
        NSString *contentString;
        NSString *placeName;
        NSDate   *createdDate;
        NSNumber *commentCount;
        
        static NSString *postCellID     = @"postCell";
        cell     = [tableView dequeueReusableCellWithIdentifier:postCellID];
        if (!cell) {
            cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postCellID];
            cell.delegate = self;
        }
        
        checkIn = [PFObject objectWithClassName:@"CheckIn"];
        
        contentString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
        commentCount  = [self.postsArray[indexPath.row] objectForKey:@"postCommentCounter"];
        createdDate   = [self.postsArray[indexPath.row] createdAt];
        checkIn       = [self.postsArray[indexPath.row] objectForKey:@"checkIn"];
        
        if (checkIn) {
            cell.hasCheckIn        = YES;
            placeName              = [NSString stringWithFormat:@"at %@", [checkIn objectForKey:@"placeName"]];
            cell.checkInLabel.text = placeName;
            [cell.checkInImage setFile:(PFFile *)checkIn[@"mapImage"] forImageView:cell.checkInImage];
        }
        
        cell.profilePicture.image   = userProfilePicture;
        cell.nameLabel.text         = name;
        cell.detailLabel.text       = contentString;
        cell.timeLabel.text         = [self setTimeSincePostDate:createdDate];
        cell.commentCountLabel.text = [self setCommentCount:commentCount];
        
        returnCell = cell;
    }
    
    return returnCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        UIStoryboard *feedSB = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
        CommentViewController *commentVC = [feedSB instantiateViewControllerWithIdentifier:@"commentVC"];
        commentVC.post = self.postsArray[indexPath.row];
        commentVC.post[@"user"] = self.user;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editVC = segue.destinationViewController;
        editVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"segueProfileToMessaging"]) {
        MessagingViewController *messageVC = segue.destinationViewController;
        messageVC.selectedUser = user;
        messageVC.selectedUserImage = userProfilePicture;
        //[ParseServices queryForFirstTimeChatBetweenCurrentUserWithUser:user];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self];
    }
}


@end
