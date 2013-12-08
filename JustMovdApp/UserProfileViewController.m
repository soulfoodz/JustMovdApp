//
//  UsersViewController.m
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


typedef enum
{
    currentUserFromMenu,
    currentUserFromOther,
    otherUser
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
    NSMutableArray *commentCount;
    UILabel *headerLabelViewSection2;
    int index;
    SpinnerViewController *spinner;
    BOOL isAll;
    PFFile *imageFile;
}

@property (nonatomic) UserState userState;
@property (strong, nonatomic) NSArray *interestsArray;

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
    
    userProfileTableView.backgroundColor = [UIColor whiteColor];
    
    [self checkUser];
    [self intializeNeededStuff];
    [self fetchUserInterests];
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
        [self handleViewState:currentUserFromOther];
        return;
    }
    else
    {
        [self handleViewState:otherUser];
    }
}


- (void)handleViewState:(UserState)state
{
    if (state == currentUserFromMenu)
    {
        [self showEditButton:YES];
    }
    
    if (state == currentUserFromOther)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self showEditButton:YES];
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


- (void)intializeNeededStuff
{
    //spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    
    profilePictureBlur = [self.userProfilePicture stackBlur:10];
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


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 320;
    
    if (indexPath.row == 1)
    {
        aboutCellHeight = [self.user[@"about"] boundingRectWithSize:CGSizeMake(212.0, FLT_MAX)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
        return (aboutCellHeight.size.height < 30) ? 45.0 : (aboutCellHeight.size.height + 50);
    }
    else
        return 45.0;
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


    switch (indexPath.row)
    {
        case 0:
            pictureCell.profilePictureBlur.image = profilePictureBlur;
            pictureCell.profilePictureOriginal.image = userProfilePicture;
            pictureCell.usernameLabel.text = [NSString stringWithFormat:@"%@, %@", name, age];
            pictureCell.fromTownLabel.text = [NSString stringWithFormat:@"via %@", location];
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
            
        case 3:
            infoCell.titleLabel.text = @"Age:";
            infoCell.descriptionLabel.text = age;
            returnCell = infoCell;
            break;
    }
    
    return returnCell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editProfileVC = segue.destinationViewController;
        //editProfileVC.passInUserInfoDictionary = userInfoDictionary;
    }
    
    if ([segue.identifier isEqualToString:@"segueProfileToMessaging"]) {
        MessagingViewController *conversationVC = segue.destinationViewController;
        conversationVC.selectedUser = user;
        
        PFQuery *checkExistingConversationMeToOther = [PFQuery queryWithClassName:@"Conversation"];
        [checkExistingConversationMeToOther whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [checkExistingConversationMeToOther whereKey:@"toUser" equalTo:user];
        [checkExistingConversationMeToOther countObjectsInBackgroundWithBlock:^(int number, NSError *error)
         {
             if (number == 0)
             {
                 PFObject *newMessage1 = [PFObject objectWithClassName:@"Conversation"];
                 [newMessage1 setObject:[PFUser currentUser] forKey:@"fromUser"];
                 [newMessage1 setObject:user forKey:@"toUser"];
                 [newMessage1 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
                 [newMessage1 saveInBackground];
             }
         }];
        
        PFQuery *checkExistingConversationOtherToMe = [PFQuery queryWithClassName:@"Conversation"];
        [checkExistingConversationOtherToMe whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [checkExistingConversationOtherToMe whereKey:@"fromUser" equalTo:user];
        [checkExistingConversationOtherToMe countObjectsInBackgroundWithBlock:^(int number, NSError *error)
         {
             if (number == 0)
             {
                 PFObject *newMessage2 = [PFObject objectWithClassName:@"Conversation"];
                 [newMessage2 setObject:[PFUser currentUser] forKey:@"toUser"];
                 [newMessage2 setObject:user forKey:@"fromUser"];
                 [newMessage2 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
                 [newMessage2 saveInBackground];
             }
         }];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self];
    }
}


@end
