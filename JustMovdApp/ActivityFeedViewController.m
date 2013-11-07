//
//  ActivityFeedViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import "PostCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "CommentViewController.h"
#import "StatusUpdateViewController.h"
#import "NavViewController.h"
#import "PFImageView+ImageHandler.h"
#import "SWRevealViewController.h"
#import "IntroParentViewController.h"
#import "UserProfileViewController.h"

#define kLoadingCellTag 7
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:15.0]

@interface ActivityFeedViewController ()

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (nonatomic) BOOL isAll;

@end

@implementation ActivityFeedViewController

@synthesize sideBarButton;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]){
        
        UIStoryboard *signupSB = [UIStoryboard storyboardWithName:@"Questionnaire" bundle:nil];
        
        IntroParentViewController *signupVC = [signupSB instantiateViewControllerWithIdentifier:@"IntroParentViewController"];
        
        [self presentViewController:signupVC animated:NO completion:^{
            nil;
        }];
    } else {
        
        self.tableView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        //self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        
        sideBarButton.target = self.revealViewController;
        sideBarButton.action = @selector(revealToggle:);
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        self.isAll = NO;
        
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
        
        [self setupTableViewHeader];
        self.refreshControl = refresh;
        
    }
}


- (void)queryForTable
{
    if (self.postsArray.count == 0){
        PFQuery *queryForAllPosts;
        queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
        [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
        [queryForAllPosts includeKey:@"user"];
        [queryForAllPosts includeKey:@"checkIn"];
        queryForAllPosts.limit = 10;
        queryForAllPosts.cachePolicy = kPFCachePolicyNetworkOnly;
        [queryForAllPosts orderByDescending:@"createdAt"];
        
        [queryForAllPosts findObjectsInBackgroundWithBlock:
         ^(NSArray *queryResults, NSError *error){
             if (!error)
             {
                 // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                 if (queryResults.count < 6)
                     self.isAll = YES;
                 else
                     self.isAll = NO;
                 
                 
                 // If postsArray doesn't exist, create it.
                 if (!self.postsArray) self.postsArray = [NSMutableArray new];
                 
                 // Add queryResults to postsArray
                 [self.postsArray addObjectsFromArray:queryResults];
                 
                 // Sort the array into descending order
                 [self.postsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                     int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                     return dateOrder;
                 }];
                 [self.tableView reloadData];
             }
             else NSLog(@"Error fetching posts : %@", error);
         }];

    }
    
    if (self.postsArray.count > 0){
        PFQuery *queryForAllPosts;
        queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
        [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
        [queryForAllPosts whereKey:@"createdAt"
                          lessThan:[[self.postsArray lastObject] createdAt]];
        
        PFQuery *greaterThanQuery;
        greaterThanQuery = [PFQuery queryWithClassName:@"Activity"];
        [greaterThanQuery whereKey:@"type" equalTo:@"JMPost"];
        [greaterThanQuery whereKey:@"createdAt"
                       greaterThan:[[self.postsArray firstObject] createdAt]];

        PFQuery *bigQuery;
        bigQuery = [PFQuery orQueryWithSubqueries:@[queryForAllPosts, greaterThanQuery]];
        [bigQuery includeKey:@"user"];
        [bigQuery includeKey:@"checkIn"];
        bigQuery.limit = 10;
        bigQuery.cachePolicy = kPFCachePolicyNetworkOnly;
        [bigQuery orderByDescending:@"createdAt"];
        
        [bigQuery findObjectsInBackgroundWithBlock:
         ^(NSArray *queryResults, NSError *error){
             if (!error)
             {
                 // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
                 if (queryResults.count < 10)
                     self.isAll = YES;
                 else
                     self.isAll = NO;
                 
                 // Add queryResults to postsArray
                 [self.postsArray addObjectsFromArray:queryResults];
                 
                 // Sort the array into descending order
                 [self.postsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                     int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                     return dateOrder;
                 }];
                 [self.tableView reloadData];
             }
             else NSLog(@"Error fetching posts : %@", error);
         }];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell;
    PFUser   *postCreator;
    PFObject *checkIn;
    PFFile   *avatarFile;
    NSString *contentString;
    NSString *placeName;
    NSDate   *createdDate;
    NSNumber *commentCount;

    checkIn = [PFObject objectWithClassName:@"CheckIn"];
    
    // Configure cell at end of TableView based on whether or not all posts in DB are being shown
    if (indexPath.row == self.postsArray.count && self.isAll == NO)
        return [self loadingCell];
    else if (indexPath.row == self.postsArray.count && self.isAll == YES)
        return [self isAllCell];
    
    // Configure standard cell
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell resetContents];

    if (!cell) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.delegate = self;
    }
    
    postCreator   = [self.postsArray[indexPath.row] objectForKey:@"user"];
    contentString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
    commentCount  = [self.postsArray[indexPath.row] objectForKey:@"postCommentCounter"];
    createdDate   = [self.postsArray[indexPath.row] createdAt];
    avatarFile    = [postCreator objectForKey:@"profilePictureFile"];
    checkIn       = [self.postsArray[indexPath.row] objectForKey:@"checkIn"];
    
    if (checkIn) {
        cell.hasCheckIn        = YES;
        placeName              = [NSString stringWithFormat:@"at %@", [checkIn objectForKey:@"placeName"]];
        cell.checkInLabel.text = placeName;
        [cell.checkInImage setFile:(PFFile *)checkIn[@"mapImage"] forImageView:cell.checkInImage];
    }
    
    [cell.profilePicture setFile:avatarFile forAvatarImageView:cell.profilePicture];
    cell.nameLabel.text         = postCreator[@"firstName"];
    cell.detailLabel.text       = contentString;
    cell.timeLabel.text         = [self setTimeSincePostDate:createdDate];
    cell.commentCountLabel.text = [self setCommentCount:commentCount];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToCommentViewController" sender:indexPath];
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *textString;
    CGRect textRect;
    int checkInHeight;
    
    // CheckinHeight is equal to the check in label and image views on the cell
    checkInHeight = 190;
    
    if (indexPath.row == self.postsArray.count)
        return 40.0f;
    else {
        textString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
        textRect = [textString boundingRectWithSize:CGSizeMake(200.0, 0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:CONTENT_FONT}
                                            context:nil];
        
        if ([self.postsArray[indexPath.row] objectForKey:@"checkIn"] != nil) {
            return (textRect.size.height + checkInHeight + 110);
        }
        else return (textRect.size.height + 110);
    }
}


- (void)refreshTable
{
    [self queryForTable];
    [self.refreshControl endRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsArray.count + 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSString *)setTimeSincePostDate:(NSDate *)date
{
    TTTTimeIntervalFormatter *timeFormatter;
    NSString *timeString;
    
    if (!date) date = [NSDate date];
    timeFormatter   = [TTTTimeIntervalFormatter new];
    timeString      = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date];
                       
    return timeString;
}


- (NSString *)setCommentCount:(NSNumber *)commentCount
{
    int x = [commentCount intValue];
    
    if (x == 0)
        return @"Add Comment";
    else if (x == 1)
        return [NSString stringWithFormat:@"%@ Comment", commentCount];
    else
        return [NSString stringWithFormat:@"%@ Comments", commentCount];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToCommentViewController"])
    {
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            CommentViewController *dvc;
            NSIndexPath *indexPath;
        
            indexPath = (NSIndexPath *)sender;
            dvc       = segue.destinationViewController;
            dvc.post  = self.postsArray[indexPath.row];
        }
        else return;
    }
    
    if ([segue.identifier isEqualToString:@"SegueToAddNewStatusUpdate"])
    {
        StatusUpdateViewController *statusVC;
        
        statusVC = segue.destinationViewController;
        statusVC.navigationItem.title = @"New Post";
        statusVC.user = [PFUser currentUser];
        statusVC.delegate = self;
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            UIButton *button = sender;
            if ([button.titleLabel.text isEqualToString:@"Check in"])
            {
                statusVC.presentingCheckIn = YES;
            }
            else statusVC.presentingCheckIn = NO;
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
                             

#pragma mark - AddNewPostToFeedDelegate Methods

- (void)addNewlyCreatedPostToActivityFeed:(PFObject *)post
{
    [self.postsArray insertObject:post atIndex:0];
    [self.tableView reloadData];
}


- (void)removePost:(PFObject *)post fromActivityFeedWithError:(NSError *)error
{
    [self.postsArray removeObject:post];
    [self.tableView reloadData];
    
    NSLog(@"Removed post from feed due to error: %@", error);
}


#pragma mark - PostCell Delegate Methods

-(void)avatarImageWasTappedInCell:(PostCell *)cell
{
    NSIndexPath  *indexPath;
    PFUser       *postCreator;
    UIStoryboard *storyboard;
    UserProfileViewController *profileVC;
    NSString     *username;
    
    storyboard  = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
    profileVC   = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
    indexPath   = [self.tableView indexPathForCell:cell];
    postCreator = [self.postsArray[indexPath.row] objectForKey:@"user"];
    username    = [postCreator objectForKey:@"username"];
    
    profileVC.facebookUsername = username;
    [self.navigationController pushViewController:profileVC animated:YES];
}


- (void)checkInMapImageWasTappedInCell:(PostCell *)cell
{
    //
}



- (void)goToStatusUpdate:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"SegueToAddNewStatusUpdate" sender:sender];
}


- (void)goToCheckIn:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"SegueToAddNewStatusUpdate" sender:sender];
}


- (void)setupTableViewHeader
{
    //UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 68, 320, 44)];
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 320, 44)];
    
    UIButton *checkInBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    UIButton *statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 44)];
    
    statusBtn.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0];
    checkInBtn.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:158.0/255.0 blue:151.0/255.0 alpha:1.0];
    
    [checkInBtn setTitle:@"Check in" forState:UIControlStateNormal];
    [checkInBtn setTitle:@"Check in" forState:UIControlStateSelected];
    [checkInBtn addTarget:self action:@selector(goToCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [statusBtn setTitle:@"Status" forState:UIControlStateNormal];
    [statusBtn setTitle:@"Check in" forState:UIControlStateSelected];
    [statusBtn addTarget:self action:@selector(goToStatusUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:checkInBtn];
    [toolBar addSubview:statusBtn];
    toolBar.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:26.0/255.0 green:158.0/255.0 blue:151.0/255.0 alpha:1.0];
    
    self.tableView.tableHeaderView = toolBar;
}


- (IBAction)unwindFromCheckInVC:(UIStoryboardSegue *)unwindSegue
{
    
}



@end
