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


#define kLoadingCellTag 7
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:14.0]

@interface ActivityFeedViewController ()

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (nonatomic) BOOL isAll;

@end

@implementation ActivityFeedViewController


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
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
    
    self.isAll = NO;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self setupTableViewHeader];
    self.refreshControl = refresh;
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
    NSString *contentString;
    NSDate   *createdDate;
    PFFile   *avatarFile;
    NSNumber *commentCount;
    NSString *placeName;
    
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
        NSLog(@"Setting the file: %@ in background", checkIn[@"mapImage"]);
        
//        if (![cell.checkInImage.file isDataAvailable]) {
//            [cell.checkInImage loadInBackground];
//        }else {
//            [cell.checkInImage.file isDataAvailable];
//        }
    }
    
    [cell.profilePicture setFile:avatarFile forImageView:cell.profilePicture];
    cell.nameLabel.text         = postCreator[@"firstName"];
    cell.detailLabel.text       = contentString;
    cell.timeLabel.text         = [self setTimeSincePostDate:createdDate];
    cell.commentCountLabel.text = [self setCommentCount:commentCount];
    NSLog(@"cell.checkInImage : %@", cell.checkInImage.image);
    
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
        CommentViewController *dvc;
        NSIndexPath *indexPath;
        PostCell *cell;
    
        dvc       = segue.destinationViewController;
        indexPath = sender;
        cell      = (PostCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        dvc.post = self.postsArray[indexPath.row];
        dvc.avatarImage = cell.profilePicture.image;
        dvc.userName    = cell.nameLabel.text;
        dvc.dateString  = cell.timeLabel.text;
        dvc.postString  = cell.detailLabel.text;
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


//- (void)avatarImageWasTappedForUser:(PFUser *)user
//{
//    NSLog(@"Tapped");
//    
//    FakeProfileViewController *destVC;
//    destVC = [FakeProfileViewController new];
//    
//    [self presentViewController:destVC animated:YES completion:nil];
//}


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
                             

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
//                                         forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (cell.tag == kLoadingCellTag && self.isAll == NO)
//        [self queryForTable];
//}


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
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 68, 320, 44)];
    UIButton *checkInBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    UIButton *statusBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 44)];
    
    [checkInBtn setTitle:@"Check in" forState:UIControlStateNormal];
    [checkInBtn setTitle:@"Check in" forState:UIControlStateSelected];
    [checkInBtn addTarget:self action:@selector(goToCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    
    [statusBtn setTitle:@"Status" forState:UIControlStateNormal];
    [statusBtn setTitle:@"Check in" forState:UIControlStateSelected];
    [statusBtn addTarget:self action:@selector(goToStatusUpdate:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:checkInBtn];
    [toolBar addSubview:statusBtn];
    toolBar.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.tableHeaderView = toolBar;
}


- (IBAction)unwindFromCheckInVC:(UIStoryboardSegue *)unwindSegue
{
    
}



@end
