//
//  ActivityFeedViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import "ActivityFeedCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "PostDetailViewController.h"
#import "FakeProfileViewController.h"
#import "AddCommentViewController.h"


#define kLoadingCellTag 7

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
    
    self.isAll = NO;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
}


- (void)queryForTable
{
    PFQuery *queryForAllPosts;
    queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
    [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
    
    // Check for any objects older than the last (oldest) object in self.postsArray
    // Check for any objects newer than the first (most recent) object in self.postsArray
    if (self.postsArray.count > 0)
    {
        [queryForAllPosts whereKey:@"createdAt"
                          lessThan:[[self.postsArray lastObject] createdAt]];
        [queryForAllPosts whereKey:@"createdAt"
                          greaterThan:[[self.postsArray firstObject] createdAt]];
    }
    [queryForAllPosts includeKey:@"user"];
    queryForAllPosts.limit = 20;
    queryForAllPosts.cachePolicy = kPFCachePolicyNetworkOnly;
    [queryForAllPosts orderByDescending:@"createdAt"];

    [queryForAllPosts findObjectsInBackgroundWithBlock:
     ^(NSArray *queryResults, NSError *error){
        if (!error)
        {
            // Check to see if a "Load more" or "That's All" cell needs to be added to the end of the tableview
            if (queryResults.count < 20)
                self.isAll = YES;
            else
                self.isAll = NO;
            
            // If postsArray doesn't exist, create it.
            if (!self.postsArray)
                self.postsArray = [NSMutableArray new];
            
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.postsArray.count && self.isAll == NO)
        return [self loadingCell];
    else if (indexPath.row == self.postsArray.count && self.isAll == YES)
        return [self isAllCell];

    ActivityFeedCell *cell;
     
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
    cell = [[ActivityFeedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"cell"];
    }
     
    PFUser *postCreator     = [self.postsArray[indexPath.row] objectForKey:@"user"];
    NSString *contentString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
    NSDate *createdDate     = [self.postsArray[indexPath.row] createdAt];
     
    cell.delegate = self;
     
    [cell setUser:postCreator];
    [cell setDate:createdDate];
    [cell setContentLabelTextWith:contentString];
     
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToPostDVC" sender:indexPath];
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.postsArray.count)
        return 40.0f;
    else
    {
        NSString *contentString;
        CGFloat cellHeight;

        contentString = [self.postsArray[indexPath.row] objectForKey:@"textContent"];
        cellHeight    = [ActivityFeedCell heightForCellWithContentString:contentString];
        
        return cellHeight;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if ([segue.identifier isEqualToString:@"SegueToPostDVC"])
    {
        ActivityFeedCell *cell = (ActivityFeedCell *)[self.tableView cellForRowAtIndexPath:sender];
        
        PostDetailViewController *dvc = segue.destinationViewController;
        dvc.avatarImage = cell.profileImageView.image;
        dvc.userName    = cell.nameLabel.text;
        dvc.dateString  = cell.dateLabel.text;
        dvc.postString  = cell.contentLabel.text;
        dvc.post        = self.postsArray[sender.row];
    }
    
    if ([segue.identifier isEqualToString:@"SegueToAddNewStatusUpdate"])
    {
        AddCommentViewController *addVC = segue.destinationViewController;
        addVC.user = [PFUser currentUser];
        addVC.navigationItem.title = @"New Post";
    }
}


- (void)avatarImageWasTappedForUser:(PFUser *)user
{
    NSLog(@"Tapped");
    
    FakeProfileViewController *destVC;
    destVC = [FakeProfileViewController new];
    
    [self presentViewController:destVC animated:YES completion:nil];
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
                             

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
                                         forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.tag == kLoadingCellTag && self.isAll == NO)
        [self queryForTable];

    return;
}
                             
@end
    




/*
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 56.0f;
 
 
 
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 UpdateCellHeader *cellHeader;
 NSDateFormatter *formatter;
 NSDate *date;
 
 date = [NSDate date];
 formatter = [NSDateFormatter new];
 formatter.timeStyle = NSDateFormatterShortStyle;
 
 cellHeader = [UpdateCellHeader new];
 
 date = [NSDate date];
 formatter = [NSDateFormatter new];
 formatter.timeStyle = NSDateFormatterShortStyle;
 
 cellHeader.nameLabel.text = @"Eric Webb";
 cellHeader.profileImage.image = [UIImage imageNamed:@"will_profile.jpg"];
 cellHeader.timeLabel.text = [formatter stringFromDate:date];
 
 return cellHeader;
 }
 */

