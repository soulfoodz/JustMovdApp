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


#define kLoadingCellTag 7
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:14.0]

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
    BOOL isAll;
}

@end

@implementation UserProfileViewController
@synthesize userInfosArray;
@synthesize userProfileTableView;
@synthesize facebookUsername;
@synthesize editButton;
@synthesize sideBarButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self intializeNeededStuff];
    
    if (facebookUsername) {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
    [self retrieveUserInfoFromParse];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)intializeNeededStuff
{
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = 2.0;
    
    //Initialize stuff
    NotificationIndicatorViewController *notifyIndicator = [[NotificationIndicatorViewController alloc] initWithView:self.navigationController.navigationBar];
    
    spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
    
    commentCount = [[NSMutableArray alloc] init];
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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
            
            //[self retriveUserPostsAndCommentsCount];
            [self queryForTable];
            
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
        
        PFQuery *interestQuery = [PFQuery queryWithClassName:@"Interests"];
        [interestQuery whereKey:@"User" equalTo:[PFUser currentUser]];
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
        NSInteger age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[[PFUser currentUser] objectForKey:@"birthday"]];
        //////////////
        userInfoDictionary[@"age"] = [NSString stringWithFormat:@"%li", (long)age];
        
        //[self retriveUserPostsAndCommentsCount];
        [self queryForTable];
        
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

- (void)queryForTable
{
    if (!facebookUsername)
    {
        if ([userInfoDictionary[@"posts"] count] == 0){
            PFQuery *queryForAllPosts;
            queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
            [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
            [queryForAllPosts whereKey:@"user" equalTo:[PFUser currentUser]];
            [queryForAllPosts includeKey:@"checkIn"];
            queryForAllPosts.limit = 10;
            queryForAllPosts.cachePolicy = kPFCachePolicyNetworkOnly;
            [queryForAllPosts orderByDescending:@"createdAt"];
            
            [queryForAllPosts findObjectsInBackgroundWithBlock:
             ^(NSArray *queryResults, NSError *error) {
                 if (!error)
                 {
                     // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                     if (queryResults.count < 6)
                         isAll = YES;
                     else
                         isAll = NO;
                     
                     //                 // If postsArray doesn't exist, create it.
                     //                 if (![userInfoDictionary[@"posts"]]) {
                     //                 self.postsArray = [NSMutableArray new];
                     //                 }
                     
                     // Sort the array into descending order
                     [queryResults.mutableCopy sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                         return dateOrder;
                     }];
                     
                     // Add queryResults to userInfoDictionary[@"posts"]
                     [userInfoDictionary setObject:queryResults forKey:@"posts"];
                     [userProfileTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
                 else NSLog(@"Error fetching posts : %@", error);
             }];
            
        }
        
        if ([userInfoDictionary[@"posts"] count] > 0){
            PFQuery *queryForAllPosts;
            queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
            [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
            [queryForAllPosts whereKey:@"user" equalTo:[PFUser currentUser]];
            [queryForAllPosts whereKey:@"createdAt" lessThan:[[userInfoDictionary[@"posts"] lastObject] createdAt]];
            
            PFQuery *greaterThanQuery;
            greaterThanQuery = [PFQuery queryWithClassName:@"Activity"];
            [greaterThanQuery whereKey:@"type" equalTo:@"JMPost"];
            [greaterThanQuery whereKey:@"createdAt"
                           greaterThan:[[userInfoDictionary[@"posts"] firstObject] createdAt]];
            
            PFQuery *bigQuery;
            bigQuery = [PFQuery orQueryWithSubqueries:@[queryForAllPosts, greaterThanQuery]];
            [bigQuery includeKey:@"user"];
            [bigQuery includeKey:@"checkIn"];
            bigQuery.limit = 10;
            bigQuery.cachePolicy = kPFCachePolicyNetworkOnly;
            [bigQuery orderByDescending:@"createdAt"];
            [bigQuery findObjectsInBackgroundWithBlock:^(NSArray *queryResults, NSError *error)
             {
                 if (!error)
                 {
                     // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                     if (queryResults.count < 10)
                         isAll = YES;
                     else
                         isAll = NO;
                     
                     // Sort the array into descending order
                     [queryResults.mutableCopy sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                         return dateOrder;
                     }];
                     
                     // Add queryResults to postsArray
                     [userInfoDictionary[@"posts"] addObjectsFromArray:queryResults];
                     [userProfileTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
                 else
                     NSLog(@"Error fetching posts : %@", error);
             }];
        }
    }
    else /////// User is somebody
    {
        if ([userInfoDictionary[@"posts"] count] == 0){
            PFQuery *queryForAllPosts;
            queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
            [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
            [queryForAllPosts whereKey:@"user" equalTo:selectedUserObject];
            [queryForAllPosts includeKey:@"checkIn"];
            queryForAllPosts.limit = 10;
            queryForAllPosts.cachePolicy = kPFCachePolicyNetworkOnly;
            [queryForAllPosts orderByDescending:@"createdAt"];
            
            [queryForAllPosts findObjectsInBackgroundWithBlock:
             ^(NSArray *queryResults, NSError *error) {
                 if (!error)
                 {
                     // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                     if (queryResults.count < 6)
                         isAll = YES;
                     else
                         isAll = NO;
                     
                     // Sort the array into descending order
                     [queryResults.mutableCopy sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                         return dateOrder;
                     }];
                     
                     // Add queryResults to userInfoDictionary[@"posts"]
                     [userInfoDictionary setObject:queryResults forKey:@"posts"];
                     [userProfileTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
                 else NSLog(@"Error fetching posts : %@", error);
             }];
            
        }
        
        if ([userInfoDictionary[@"posts"] count] > 0){
            PFQuery *queryForAllPosts;
            queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
            [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
            [queryForAllPosts whereKey:@"user" equalTo:selectedUserObject];
            [queryForAllPosts whereKey:@"createdAt" lessThan:[[userInfoDictionary[@"posts"] lastObject] createdAt]];
            
            PFQuery *greaterThanQuery;
            greaterThanQuery = [PFQuery queryWithClassName:@"Activity"];
            [greaterThanQuery whereKey:@"type" equalTo:@"JMPost"];
            [greaterThanQuery whereKey:@"createdAt"
                           greaterThan:[[userInfoDictionary[@"posts"] firstObject] createdAt]];
            
            PFQuery *bigQuery;
            bigQuery = [PFQuery orQueryWithSubqueries:@[queryForAllPosts, greaterThanQuery]];
            [bigQuery includeKey:@"user"];
            [bigQuery includeKey:@"checkIn"];
            bigQuery.limit = 10;
            bigQuery.cachePolicy = kPFCachePolicyNetworkOnly;
            [bigQuery orderByDescending:@"createdAt"];
            [bigQuery findObjectsInBackgroundWithBlock:^(NSArray *queryResults, NSError *error)
             {
                 if (!error)
                 {
                     // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                     if (queryResults.count < 10)
                         isAll = YES;
                     else
                         isAll = NO;
                     
                     // Sort the array into descending order
                     [queryResults.mutableCopy sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                         return dateOrder;
                     }];
                     
                     // Add queryResults to postsArray
                     [userInfoDictionary[@"posts"] addObjectsFromArray:queryResults];
                     [userProfileTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
                 else
                     NSLog(@"Error fetching posts : %@", error);
             }];
        }

    }
}

- (UITableViewCell *)loadingCell
{
    UIActivityIndicatorView *activityIndicator;
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    activityIndicator = [UIActivityIndicatorView new];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.center = cell.center;
    
    [cell addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    cell.userInteractionEnabled = NO;
    
    [self queryForTable];
    
    return cell;
}

- (UITableViewCell *)isAllCell
{
    UITableViewCell *cell;
    UILabel *label;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    label = [UILabel new];
    
    // Setup the contentLabel
    label.frame         = CGRectMake(0.0f, 0.0f, 70.0f, 14.0f);
    label.center        = cell.center;
    label.font          = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    label.textColor     = [UIColor blackColor];
    label.numberOfLines = 1;
    label.text          = @"That's all!";
    
    [cell addSubview:label];
    
    return cell;
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
                [newMessage1 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
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
                 [newMessage2 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
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
    headerLabelViewSection2.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    headerLabelViewSection2.textAlignment = NSTextAlignmentCenter;
    headerLabelViewSection2.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    headerLabelViewSection2.textColor = [UIColor lightGrayColor];
    if ([userInfoDictionary[@"posts"] count] == 0)
    {
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
        NSString *textString;
        CGRect textRect;
        int checkInHeight;
        
        // CheckinHeight is equal to the check in label and image views on the cell
        checkInHeight = 190;
        
        if (indexPath.row == [userInfoDictionary[@"posts"] count])
            return 40.0f;
        else {
            textString = [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
            textRect = [textString boundingRectWithSize:CGSizeMake(200.0, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:CONTENT_FONT}
                                                context:nil];
            
            if ([userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"checkIn"] != nil) {
                return (textRect.size.height + checkInHeight + 110);
            }
            else return (textRect.size.height + 120);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    PFObject *checkIn;
    NSString *placeName;
    UITableViewCell *returnCell;
    
    static NSString *pictureCellID = @"pictureCell";
    static NSString *infoCellID = @"infoCell";
    static NSString *postCellID = @"postCell";
    static NSString *interestCellID = @"interestCell";
    
    checkIn = [PFObject objectWithClassName:@"CheckIn"];
    
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
    
    PostCell *postCell = [tableView dequeueReusableCellWithIdentifier:postCellID];
    if (!postCell) {
        postCell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postCellID];
        [postCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ProfileInterestCell *interestCell = [tableView dequeueReusableCellWithIdentifier:interestCellID];
    if (!interestCell) {
        interestCell = [[ProfileInterestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:interestCellID];
        [interestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
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
                returnCell = pictureCell;
                break;
                
            case 1:
                infoCell.titleLabel.text = @"About:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"about"];
                returnCell = infoCell;
                break;
                
            case 2:
                interestCell.titleLabel.text = @"Interests:";
                interestCell.firstImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"firstInterest"]]];
                interestCell.secondImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"secondInterest"]]];
                interestCell.thirdImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"thirdInterest"]]];
                interestCell.fourthImageView.image = [UIImage imageNamed:[self getImageNameFromString:userInfoDictionary[@"fourthInterest"]]];
                returnCell = interestCell;
                break;
                
            case 3:
                infoCell.titleLabel.text = @"Age:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"age"];
                returnCell = infoCell;
                break;
        }
    }
    else
    {
        // Configure cell at end of TableView based on whether or not all posts in DB are being shown
        if (indexPath.row == [userInfoDictionary[@"posts"] count] && isAll == NO)
            return [self loadingCell];
        else if (indexPath.row == [userInfoDictionary[@"posts"] count] && isAll == YES)
            return [self isAllCell];
        
        checkIn = [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"checkIn"];
        
        if (checkIn) {
            postCell.hasCheckIn        = YES;
            placeName              = [NSString stringWithFormat:@"at %@", [checkIn objectForKey:@"placeName"]];
            postCell.checkInLabel.text = placeName;
            [postCell.checkInImage setFile:(PFFile *)checkIn[@"mapImage"] forImageView:postCell.checkInImage];
            NSLog(@"Setting the file: %@ in background", checkIn[@"mapImage"]);
        }
        
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[userInfoDictionary[@"posts"][indexPath.row] createdAt]];
        postCell.profilePicture.image = profilePicture;
        postCell.nameLabel.text = name;
        postCell.timeLabel.text = timeString;
        postCell.detailLabel.text = [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
        postCell.commentCountLabel.text = [NSString stringWithFormat:@"%@ Comments", [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"postCommentCounter"]];
        returnCell = postCell;
    }
    
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        UIStoryboard *feedSB = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
        CommentViewController *commentVC = [feedSB instantiateViewControllerWithIdentifier:@"commentVC"];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self];
    }
}


@end
