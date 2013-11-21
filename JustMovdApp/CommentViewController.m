//
//  CommentViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "CommentViewController.h"
#import "PostCell.h"
#import "JMCache.h"
#import "TTTTimeIntervalFormatter.h"
#import "PFImageView+ImageHandler.h"
#import "UserProfileViewController.h"
#import "CheckInDetailViewController.h"
#import <MapKit/MapKit.h>


#define maxContentWidth 300.0f
#define nameOriginX (avatarSpacing + avatarImageView.frame.size.width + 10.0f)
#define dateOriginX (avatarSpacing + avatarImageView.frame.size.width + 10.0f)
#define headerInsetY 6.0f
#define contentLabelInset 6.0f
#define avatarSpacing 6.0f
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:15.0]

@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize commentsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    
    self.textView.layer.cornerRadius = 3.0f;
    self.textView.font = CONTENT_FONT;
    self.textView.textColor = [UIColor darkGrayColor];
    
    self.postButton.layer.cornerRadius = 5.0f;
    self.postButton.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:158.0/255.0 blue:151.0/255.0 alpha:1.0];
    
    [self queryForComments];
    
    self.postButton.enabled = NO;
}


- (void)queryForComments
{
    PFQuery *queryForPostComments;
    
    queryForPostComments = [PFQuery queryWithClassName:@"Activity"];
    [queryForPostComments whereKey:@"type" equalTo:@"JMComment"];
    [queryForPostComments whereKey:@"post" equalTo:self.post];
    [queryForPostComments includeKey:@"user"];
    [queryForPostComments orderByAscending:@"createdAt"];
    
    queryForPostComments.limit = 30;
    queryForPostComments.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [queryForPostComments findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         if (!error)
         {
             self.commentsArray = [[NSMutableArray arrayWithArray:comments] mutableCopy];
             [self.tableView reloadData];
             [self updateCommentCount];
         }
         else NSLog(@"Error fetching posts : %@", error);
     }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return (self.commentsArray.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell;
    PFUser   *postCreator;
    NSString *contentString;
    NSDate   *createdDate;
    PFFile   *imageFile;

    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell resetContents];
    
    if (!cell) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.delegate = self;
        [self styleCell:cell];
    }
    
    // Section 1 is the original Post from the feed
    if (indexPath.section == 0)
    {
        PFObject *checkIn;
        
        postCreator   = [self.post objectForKey:@"user"];
        contentString = [self.post objectForKey:@"textContent"];
        checkIn       = [self.post objectForKey:@"checkIn"];
        imageFile     = [postCreator objectForKey:@"profilePictureFile"];
        createdDate   = [self.post createdAt];
        
        if (checkIn) {
            cell.hasCheckIn        = YES;
            cell.checkInLabel.text = [NSString stringWithFormat:@"at %@", [checkIn objectForKey:@"placeName"]];
            [cell.checkInImage setFile:(PFFile *)checkIn[@"mapImage"]
                          forImageView:cell.checkInImage];
        }
        
        cell.nameLabel.text         = postCreator[@"firstName"];
        cell.detailLabel.text       = contentString;
        cell.timeLabel.text         = [self setTimeSincePostDate:createdDate];
        [cell.profilePicture setFile:imageFile forAvatarImageView:cell.profilePicture];
    }
    else{
        
        // Section 2 is for comments on the post
        postCreator   = [self.commentsArray[indexPath.row] objectForKey:@"user"];
        contentString = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
        createdDate   = [self.commentsArray[indexPath.row] createdAt];
        imageFile     = [postCreator objectForKey:@"profilePictureFile"];

        cell.nameLabel.text   = postCreator[@"firstName"];
        cell.detailLabel.text = contentString;
        cell.timeLabel.text   = [self setTimeSincePostDate:createdDate];
        [cell.profilePicture setFile:imageFile forAvatarImageView:cell.profilePicture];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString;
    CGFloat textHeight;
    int addCheckIn = 190;

    
    if (indexPath.section == 0){
        contentString = [self.post objectForKey:@"textContent"];
        textHeight    = [self sizeForString:contentString withFont:CONTENT_FONT];
        if (self.post[@"checkIn"])
            return textHeight + addCheckIn + 80;
        else
            return textHeight + 88;
    }
    else
        contentString = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
        textHeight = [self sizeForString:contentString withFont:CONTENT_FONT];
        return textHeight + 88;
}


- (NSString *)setTimeSincePostDate:(NSDate *)date
{
    TTTTimeIntervalFormatter *timeFormatter;
    NSString *timeString;
    
    if (date == nil) date = [NSDate date];
    timeFormatter   = [TTTTimeIntervalFormatter new];
    timeString      = [timeFormatter stringForTimeIntervalFromDate:[NSDate date]
                                                            toDate:date];
    return timeString;
}


- (void)styleCell:(PostCell *)cell
{
    cell.backgroundColor        = [UIColor whiteColor];
    cell.commentCountLabel      = nil;
    cell.commentView            = nil;
    cell.userInteractionEnabled = YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.cancelButton.enabled = YES;
    self.navigationItem.backBarButtonItem.enabled = NO;
    [self animateViewUp];
}


-(void)textViewDidChange:(UITextView *)textView
{
    self.postButton.enabled = YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.cancelButton.enabled = NO;
    self.navigationItem.backBarButtonItem.enabled = YES;

    // Reset the textViews frame and content
    self.textView.text = @"";
    [self animateViewDown];
    [self.textView resignFirstResponder];

    return YES;
}


- (void)animateViewUp
{
    // Animate the textViewContainer up
    [UIView animateWithDuration:0.3f animations:^{
        
        // Animate the textView up above the keyboard
        self.textViewContainer.frame = CGRectMake(0,(self.view.frame.size.height - 264),320, 48);
    
        if (self.commentsArray.count > 0){
            [UIView animateWithDuration:0.3f animations:^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsArray.count - 1) inSection:1];

                // Shorten the tableviews frame
                self.tableView.frame = CGRectMake(0,0,320,(self.view.bounds.size.height - 264));
                
                // Scroll so the last row is above the textViewContainer
                [self.tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
            }];
        }
    }];
}


- (void)animateViewDown
{
    // Animate the textViewContainer down
    [UIView animateWithDuration:0.3f animations:^{
        
        // Animate the textView beneath the keyboard
        self.textViewContainer.frame = CGRectMake(self.textViewContainer.frame.origin.x,
                                                  self.view.bounds.size.height - self.textViewContainer.frame.size.height,
                                                  self.textViewContainer.frame.size.width,
                                                  self.textViewContainer.frame.size.height);
        
        if (self.commentsArray.count > 1){
            [UIView animateWithDuration:0.3f animations:^{
                
                // Shorten the tableviews frame
                self.tableView.frame = CGRectMake(0,0,320,520);
            }];
        }
    }];
}


#pragma mark - Keyboard Notifications


- (IBAction)addCommentPressed:(UIButton *)sender
{
    if (self.textView.text.length == 0)
    {
        [self displayNoTextAlert];
        return;
    }

    // Create a newComment object
    PFObject *newComment = [PFObject objectWithClassName:@"Activity"];
    [newComment setObject:self.textView.text forKey:@"textContent"];
    [newComment setObject:[PFUser currentUser] forKey:@"user"];
    [newComment setObject:@"JMComment" forKey:@"type"];
    [newComment setObject:self.post forKey:@"post"];
    [newComment setObject:[NSNumber numberWithInt:0] forKey:@"flagCount"];
    [self.post incrementKey:@"postCommentCounter" byAmount:[NSNumber numberWithInt:1]];
    [[JMCache sharedCache] incrementCommentCountForPost:self.post];
    
    NSTimer *timeOutTimer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(handleConnectionTimeOut) userInfo:nil repeats:NO];
    
    [newComment saveEventually:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [self.post saveInBackground];
            [timeOutTimer invalidate];
            [self.commentsArray removeObject:newComment];
            [[JMCache sharedCache] decrementCommentCountForPost:self.post];
        }
    }];
    
    [self.commentsArray addObject:newComment];
    [self.textView resignFirstResponder];
    [self.tableView reloadData];
    [self updateCommentCount];
}


- (IBAction)cancelPressed:(id)sender
{
    [self textViewShouldEndEditing:self.textView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.post = nil;
}


#pragma mark - AlertViews


- (void)handleConnectionTimeOut
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to save comment"
                                                        message:@"We're having trouble with the internet connection and were unable to                  save your last comment."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];

    [alertView show];
}


- (void)displayNoTextAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where's the post?"
                                                    message:@"You didn't mean to post nothing did you?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    [alert show];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
}


- (CGFloat)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(maxContentWidth, 0)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:CONTENT_FONT}
                                           context:nil];
    
    int height = textRect.size.height + 1;
    
    return (float)height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) return 30.0f;
    else return 0;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section != 1) return nil;
    else
        return [self updateCommentCount];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
   
    UIView *head;
    
    head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    head.layer.borderWidth = 0.5;
    head.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    head.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    CGRect rect                 = head.bounds;
    commentsLabel               = [UILabel new];
    commentsLabel.frame         = CGRectMake(rect.origin.x, rect.origin.y +8, rect.size.width -10, rect.size.height /2);
    commentsLabel.font          = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    commentsLabel.textColor     = [UIColor darkGrayColor];
    commentsLabel.textAlignment = NSTextAlignmentCenter;
    commentsLabel.text = [self tableView:self.tableView titleForHeaderInSection:1];
    
    [head addSubview:commentsLabel];
    
    return head;
}


- (NSString *)updateCommentCount
{
    NSString *count;
    int commentCount = (int)self.commentsArray.count;

    if (commentCount == 1)
        return count = [NSString stringWithFormat:@"%d Comment", commentCount];
    else
        return count = [NSString stringWithFormat:@"%d Comments", commentCount];
}


#pragma mark - PostCell Delegate Methods

-(void)avatarImageWasTappedInCell:(PostCell *)cell
{
    UserProfileViewController *profileVC;
    NSIndexPath  *indexPath;
    PFUser       *postCreator;
    UIStoryboard *storyboard;
    NSString     *fbUsername;
    
    storyboard  = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
    profileVC   = [storyboard instantiateViewControllerWithIdentifier:@"profile"];
    indexPath   = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0)
        postCreator = self.post[@"user"];
    else
        postCreator = [self.commentsArray[indexPath.row] objectForKey:@"user"];
    
    fbUsername  = [postCreator objectForKey:@"FBUsername"];
    
    profileVC.facebookUsername = fbUsername;
    [self.navigationController pushViewController:profileVC animated:YES];
}


- (void)checkInMapImageWasTappedInCell:(PostCell *)cell
{
    [self performSegueWithIdentifier:@"SegueToCheckInDetailViewController" sender:cell];
}


- (void)flagPostInCell:(PostCell *)cell
{
    NSIndexPath *indexPath;
    PFObject    *post;
    PFObject    *flaggedPost;
    PFUser      *postCreator;
    
    indexPath   = [self.tableView indexPathForCell:cell];
    post        = self.commentsArray[indexPath.row];
    flaggedPost = [PFObject objectWithClassName:@"FlaggedActivities"];
    postCreator = post[@"user"];
    
    [flaggedPost setObject:[PFUser currentUser] forKey:@"flaggedBy"];
    [flaggedPost setObject:postCreator forKey:@"originalPoster"];
    [flaggedPost setObject:post forKey:@"activity"];
    
    [post incrementKey:@"flagCount"];
    
    [flaggedPost saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            [self presentAlertViewForFlaggedPost];
        else
            NSLog(@"Flag didn't work : ERROR %@", error);
    }];
}


- (void)presentAlertViewForFlaggedPost
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                    message:@"JustMovd has received your report and will look into the matter."
                                                   delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToCheckInDetailViewController"])
    {
        CheckInDetailViewController *dvc;
        NSIndexPath                 *indexPath;
        PFObject                    *checkIn;
        PFGeoPoint                  *location;
        CLLocationCoordinate2D      centerCoord;
        
        indexPath   = [self.tableView indexPathForCell:sender];
        checkIn     = [self.post objectForKey:@"checkIn"];
        location    = checkIn[@"location"];
        centerCoord = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        
        dvc = segue.destinationViewController;
        dvc.checkIn = checkIn;
    }
}



@end
