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

@interface UserProfileViewController ()
{
    UIBarButtonItem *spacerButton;
    UIBarButtonItem *doneButton;
    UIImage *profilePicture;
    UIImage *profilePictureBlur;
    NSMutableDictionary *userInfoDictionary;
    CGRect aboutCellHeight;
    CGRect postCellHeight;
    TTTTimeIntervalFormatter *timeFormatter;
    PFObject *selectedUserObject;
    NSMutableArray *commentCount;
    UILabel *headerLabelViewSection2;
    int index;
    SpinnerViewController *spinner;
}

@end

@implementation UserProfileViewController
@synthesize userInfosArray;
@synthesize userProfileTableView;
@synthesize facebookUsername;
@synthesize editButton;

- (void)viewDidLoad
{
    //facebookUsername = @"ericmwebb";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self intializeNeededStuff];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self retrieveUserInfoFromParse];
}

- (void)intializeNeededStuff
{
    //Initialize stuff
    spinner = [[SpinnerViewController alloc] initWithDefaultSize];
    [self.view addSubview:spinner.view];
    spinner.view.center = self.view.center;
    [self.view bringSubviewToFront:spinner.view];
    
    commentCount = [[NSMutableArray alloc] init];
    
    userInfoDictionary = [[NSMutableDictionary alloc] init];
    userInfoDictionary[@"name"]             = @"";
    userInfoDictionary[@"gender"]           = @"";
    userInfoDictionary[@"email"]            = @"";
    userInfoDictionary[@"about"]            = @"";
    userInfoDictionary[@"location"]         = @"";
    userInfoDictionary[@"age"]              = @"";
    userInfoDictionary[@"firstInterest"]    = @"";
    userInfoDictionary[@"secondInterest"]    = @"";
    userInfoDictionary[@"thirdInterest"]    = @"";
    userInfoDictionary[@"fourthInterest"]    = @"";
    
    userInfosArray = [[NSMutableArray alloc] init];
    
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    
    headerLabelViewSection2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
}

///////////////////////

- (void)retrieveUserInfoFromParse
{
    [spinner.view setHidden:NO];
    
    if (facebookUsername && ![facebookUsername isEqualToString:[[PFUser currentUser] objectForKey:@"username"]])
    {
        [self showEditButton:NO];
        
        PFQuery *selectedUser = [PFUser query];
        [selectedUser whereKey:@"FBUsername" equalTo:facebookUsername];
        [selectedUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            selectedUserObject = object;
            selectedUser.cachePolicy = kPFCachePolicyCacheThenNetwork;
            PFFile *imageFile = [object objectForKey:@"profilePictureFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                profilePicture = [UIImage imageWithData:data];
                profilePictureBlur = [profilePicture stackBlur:10];
                [userProfileTableView reloadData];
            }];
            
            userInfoDictionary[@"name"]     = [object objectForKey:@"firstName"];
            userInfoDictionary[@"gender"]   = [object objectForKey:@"gender"];
            userInfoDictionary[@"email"]    = [object objectForKey:@"email"];
            userInfoDictionary[@"about"]    = [object objectForKey:@"about"];
            userInfoDictionary[@"location"] = [object objectForKey:@"location"];
            
            PFQuery *interestQuery = [PFQuery queryWithClassName:@"Interests"];
            [interestQuery whereKey:@"User" equalTo:object];
            [interestQuery getFirstObjectInBackgroundWithBlock:^(PFObject *interestObject, NSError *error)
            {
                if (interestObject)
                {
                    userInfoDictionary[@"firstInterest"]     = [interestObject objectForKey:@"first"];
                    userInfoDictionary[@"secondInterest"]     = [interestObject objectForKey:@"second"];
                    userInfoDictionary[@"thirdInterest"]     = [interestObject objectForKey:@"third"];
                    userInfoDictionary[@"fourthInterest"]     = [interestObject objectForKey:@"fourth"];
                    [userProfileTableView reloadData];
                }
            }];
            
            //Convert age
            NSInteger age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[object objectForKey:@"birthday"]];
            //////////////
            
            userInfoDictionary[@"age"] = [NSString stringWithFormat:@"%li", (long)age];
            
            [self retriveUserPostsAndCommentsCount];
            
            [userProfileTableView reloadData];
        }];
    }
    else
    {
        [self showEditButton:YES];
        
        PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePictureFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            profilePicture = [UIImage imageWithData:data];
            profilePictureBlur = [profilePicture stackBlur:10];
            [userProfileTableView reloadData];
        }];
        
        userInfoDictionary[@"name"]     = [[PFUser currentUser] objectForKey:@"firstName"];
        userInfoDictionary[@"gender"]   = [[PFUser currentUser] objectForKey:@"gender"];
        userInfoDictionary[@"email"]    = [[PFUser currentUser] objectForKey:@"email"];
        userInfoDictionary[@"about"]    = [[PFUser currentUser] objectForKey:@"about"];
        userInfoDictionary[@"location"] = [[PFUser currentUser] objectForKey:@"location"];
        
        //Convert age
        NSInteger age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[[PFUser currentUser] objectForKey:@"birthday"]];
        //////////////
        userInfoDictionary[@"age"] = [NSString stringWithFormat:@"%li", (long)age];
        
        [self retriveUserPostsAndCommentsCount];
        [userProfileTableView reloadData];
    }
}

- (void)retriveUserPostsAndCommentsCount
{
    if (!facebookUsername)
    {
        PFQuery *postsQuery = [PFQuery queryWithClassName:@"Activity"];
        [postsQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [postsQuery whereKey:@"type" equalTo:@"JMPost"];
        [postsQuery orderByDescending:@"createdAt"];
        [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error)
        {
            [userInfoDictionary setObject:posts forKey:@"posts"];
            [userProfileTableView reloadData];
            [spinner.view setHidden:YES];
            
        }];
    }
    else
    {
        PFQuery *postsQuery = [PFQuery queryWithClassName:@"Activity"];
        [postsQuery whereKey:@"user" equalTo:selectedUserObject];
        [postsQuery whereKey:@"type" equalTo:@"JMPost"];
        [postsQuery orderByDescending:@"createdAt"];
        [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error)
        {
            [userInfoDictionary setObject:posts forKey:@"posts"];
            [userProfileTableView reloadData];
            [spinner.view setHidden:YES];
        }];
    }
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

- (IBAction)actionLogOut:(id)sender
{
    [PFUser logOut];
    
}
///////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editProfileVC = segue.destinationViewController;
        editProfileVC.passInUserInfoDictionary = userInfoDictionary;
    }
    
    if ([segue.identifier isEqualToString:@"segueProfileToMessaging"]) {
        MessagingViewController *conversationVC = segue.destinationViewController;
        conversationVC.selectedUser = selectedUserObject;
        
        PFQuery *checkExistingConversationMeToOther = [PFQuery queryWithClassName:@"Conversation"];
        [checkExistingConversationMeToOther whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [checkExistingConversationMeToOther whereKey:@"toUser" equalTo:selectedUserObject];
        [checkExistingConversationMeToOther countObjectsInBackgroundWithBlock:^(int number, NSError *error)
        {
            if (number == 0)
            {
                PFObject *newMessage1 = [PFObject objectWithClassName:@"Conversation"];
                [newMessage1 setObject:[PFUser currentUser] forKey:@"fromUser"];
                [newMessage1 setObject:selectedUserObject forKey:@"toUser"];
                [newMessage1 saveInBackground];
            }
        }];
        
        PFQuery *checkExistingConversationOtherToMe = [PFQuery queryWithClassName:@"Conversation"];
        [checkExistingConversationOtherToMe whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [checkExistingConversationOtherToMe whereKey:@"fromUser" equalTo:selectedUserObject];
        [checkExistingConversationOtherToMe countObjectsInBackgroundWithBlock:^(int number, NSError *error)
         {
             if (number == 0)
             {
                 PFObject *newMessage2 = [PFObject objectWithClassName:@"Conversation"];
                 [newMessage2 setObject:[PFUser currentUser] forKey:@"toUser"];
                 [newMessage2 setObject:selectedUserObject forKey:@"fromUser"];
                 [newMessage2 saveInBackground];
             }
         }];
        
    }
}

- (NSString *)getImageNameFromString:(NSString *)string
{
    if ([string isEqualToString:@"Beer"]) {
        return @"beer";
    }
    else if ([string isEqualToString:@"Weights"]) {
        return @"weights";
    }
    else if ([string isEqualToString:@"Sports"]) {
        return @"sports";
    }
    else if ([string isEqualToString:@"Yoga"]) {
        return @"yoga";
    }
    else if ([string isEqualToString:@"Coffee"]) {
        return @"coffee";
    }
    else if ([string isEqualToString:@"Games"]) {
        return @"games";
    }
    else if ([string isEqualToString:@"TV"]) {
        return @"tv";
    }
    else {
        return @"book";
    }
}


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerLabelViewSection2.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    headerLabelViewSection2.textAlignment = NSTextAlignmentCenter;
    headerLabelViewSection2.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    headerLabelViewSection2.textColor = [UIColor lightGrayColor];
    if ([userInfoDictionary[@"posts"] count] == 0) {
        headerLabelViewSection2.text = @"No Recent Activity";
    }
    else
    {
        headerLabelViewSection2.text = @"Recent Activities";
    }
    
    return headerLabelViewSection2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else
    {
        return [userInfoDictionary[@"posts"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            return 320;
        }
        else if (indexPath.row == 1)
        {
            aboutCellHeight = [userInfoDictionary[@"about"] boundingRectWithSize:CGSizeMake(212.0, FLT_MAX)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]} context:nil];
            return (aboutCellHeight.size.height < 30) ? 45.0 : (aboutCellHeight.size.height + 50);
        }
        else
        {
            return 45.0;
        }
    }
    else
    {
        NSString *textString =[userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
        
        postCellHeight = [textString boundingRectWithSize:CGSizeMake(150.0, 0)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                                                         context:nil];
        
        return (postCellHeight.size.height < 30) ? 150.0 : (postCellHeight.size.height + 110);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pictureCellID = @"pictureCell";
    static NSString *infoCellID = @"infoCell";
    static NSString *postCellID = @"postCell";
    static NSString *interestCellID = @"interestCell";
    
    PictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:pictureCellID];
    pictureCell.messageButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18.0];
    pictureCell.usernameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:20.0];
    pictureCell.fromTownLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0];
    [pictureCell.profilePictureBlur setContentMode:UIViewContentModeScaleAspectFill];
    pictureCell.profilePictureBlur.layer.masksToBounds = YES;
    [pictureCell.profilePictureOriginal setContentMode:UIViewContentModeScaleAspectFill];
    pictureCell.profilePictureOriginal.layer.masksToBounds = YES;
    [pictureCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID];
    if (!infoCell) {
        infoCell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellID];
        infoCell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
        infoCell.descriptionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14.0];
        [infoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    infoCell.descriptionLabel.numberOfLines = 0;
    infoCell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    PostsByUserCell *postCell = [tableView dequeueReusableCellWithIdentifier:postCellID];
    if (!postCell) {
        postCell = [[PostsByUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postCellID];
        [postCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ProfileInterestCell *interestCell = [tableView dequeueReusableCellWithIdentifier:interestCellID];
    if (!interestCell) {
        interestCell = [[ProfileInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:interestCellID];
        [interestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UITableViewCell *cell;
    NSArray *nameArray = [userInfoDictionary[@"name"] componentsSeparatedByString:@" "];
    NSString *name = nameArray[0];
    NSString *age = userInfoDictionary[@"age"];
    NSString *gender;
    if ([userInfoDictionary[@"gender"] isEqualToString:@"male"]) {
        gender = @"m";
    }
    else {
        gender = @"f";
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row)
        {
            case 0:
                pictureCell.profilePictureBlur.image = profilePictureBlur ;
                pictureCell.profilePictureOriginal.image = profilePicture;
                pictureCell.usernameLabel.text = [NSString stringWithFormat:@"%@, %@/%@", name, age, gender];
                pictureCell.fromTownLabel.text = [NSString stringWithFormat:@"via %@", userInfoDictionary[@"location"]];
                if (!facebookUsername || [[[PFUser currentUser] username] isEqualToString:facebookUsername]) {
                    [pictureCell.messageButton setHidden:YES];
                }
                
                cell = pictureCell;
                break;
            case 1:
                infoCell.titleLabel.text = @"About:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"about"];
                cell = infoCell;
                break;
            case 2:
                interestCell.titleLabel.text = @"Interests:";
                interestCell.firstImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"firstInterest"]]];
                interestCell.secondImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"secondInterest"]]];
                interestCell.thirdImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"thirdInterest"]]];
                interestCell.fourthImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"fourthInterest"]]];
                cell = interestCell;
                break;
            case 3:
                infoCell.titleLabel.text = @"Age:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"age"];
                cell = infoCell;
                break;
        }
    }
    else
    {
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[userInfoDictionary[@"posts"][indexPath.row] createdAt]];
        
        postCell.profilePicture.image = profilePicture;
        postCell.nameLabel.text = name;
        postCell.timeLabel.text = timeString;
        postCell.detailLabel.text = [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
        postCell.commentCountLabel.text = [NSString stringWithFormat:@"%@ Comments", [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"postCommentCounter"]];
        cell = postCell;
    }
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self];
    }
}


@end
