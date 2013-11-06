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


#define maxContentWidth 290.0f
#define nameOriginX (avatarSpacing + avatarImageView.frame.size.width + 10.0f)
#define dateOriginX (avatarSpacing + avatarImageView.frame.size.width + 10.0f)
#define headerInsetY 6.0f
#define contentLabelInset 6.0f
#define avatarSpacing 6.0f
#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:13.0]

@interface CommentViewController ()

@end


@implementation CommentViewController

@synthesize commentsLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupTableHeader];
    [self queryForComments];
    
    UIControl *touchControl;
    touchControl.frame = self.tableView.bounds;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.commentsArray.count == 0) return 0;
    else return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell;
    PFUser   *postCreator;
    NSString *contentString;
    NSDate   *createdDate;
    PFFile   *imageFile;

    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    [self styleCell:cell];

    postCreator   = [self.commentsArray[indexPath.row] objectForKey:@"user"];
    contentString = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
    createdDate   = [self.commentsArray[indexPath.row] createdAt];
    imageFile     = [postCreator objectForKey:@"profilePictureFile"];

    // Set the profile picture to a default image while fetching the user image in background
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.profilePicture.image = [UIImage imageWithData:data];
        }else
            NSLog(@"ERROR getting profile pic for user: %@", postCreator);
    }];

    cell.nameLabel.text   = postCreator[@"name"];
    cell.detailLabel.text = contentString;
    cell.timeLabel.text   = [self setTimeSincePostDate:createdDate];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString;
    CGRect textRect;
    
    if (!self.commentsArray) return 100.0f;
    else
    {
        contentString = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
        textRect = [contentString boundingRectWithSize:CGSizeMake(200.0, 0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:CONTENT_FONT}
                                            context:nil];
        
        return (textRect.size.height + 80);
    }
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
    cell.backgroundColor = [UIColor whiteColor];
    cell.commentCountLabel = nil;
    cell.commentCountLabel = nil;
    cell.userInteractionEnabled = NO;
}

//- (void)avatarImageWasTappedForUser:(PFUser *)user
//{
//    NSLog(@"Tapped");
//    UIStoryboardSegue *segue;
//    
//    FakeProfileViewController *destVC;
//    destVC = [FakeProfileViewController new];
//    
//    segue = [UIStoryboardSegue segueWithIdentifier:@"SegueToProfileVC"
//                                            source:self
//                                       destination: destVC
//                                    performHandler:^{
//                                        destVC.user = user;
//                                    }];
//}


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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsArray.count - 1) inSection:0];

                // Shorten the tableviews frame
                self.tableView.frame = CGRectMake(0,0,320,(self.view.frame.size.height - 264));
                
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

    PFObject *newComment = [PFObject objectWithClassName:@"Activity"];
    [newComment setObject:self.textView.text forKey:@"textContent"];
    [newComment setObject:[PFUser currentUser] forKey:@"user"];
    [newComment setObject:@"JMComment" forKey:@"type"];
    [newComment setObject:self.post forKey:@"post"];
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


#pragma mark - AlertViews


- (void)handleConnectionTimeOut
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to save comment"
                                                        message:@"We're having trouble with the internet connection and were unable to save your last comment."
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

                          
- (void)setupTableHeader
{
    // Setup the containerView
    UIView *headerContainerView = [UIView new];
    headerContainerView.backgroundColor = [UIColor whiteColor];
    
    // Setup the nameLabel
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.numberOfLines = 1;
    [headerContainerView addSubview:nameLabel];
    
    // Setup the dateLabel
    UILabel *dateLabel = [UILabel new];
    dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.numberOfLines = 1;
    [headerContainerView addSubview:dateLabel];
    
    // Setup the contentLabel
    UILabel *contentLabel = [UILabel new];
    contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.numberOfLines = 0;
    [headerContainerView addSubview:contentLabel];
    
    // Setup the profileImage
    PFImageView *avatarImageView = [PFImageView new];
    avatarImageView.backgroundColor = [UIColor clearColor];
    avatarImageView.layer.cornerRadius = 22.0f;
    avatarImageView.clipsToBounds = YES;
    [headerContainerView addSubview:avatarImageView];
    
    // Setup the profileImageButton
    UIButton *avatarButton = [UIButton new];
    avatarButton.backgroundColor = [UIColor clearColor];
    avatarButton.userInteractionEnabled = NO;
    [avatarButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerContainerView addSubview:avatarButton];

    
    // Set text and images for labels/images
    contentLabel.text = self.post[@"textContent"];
    dateLabel.text = self.dateString;
    nameLabel.text = self.userName;
    avatarImageView.image = self.avatarImage;
    
    //* Set profileImageView
    avatarImageView.frame = CGRectMake(6, headerInsetY, 44, 44);
    avatarButton.frame = CGRectMake(6, headerInsetY, 44, 44);
    
    //* Set nameLabel
    CGSize nameSize = [self sizeForString:nameLabel.text withFont:nameLabel.font];
    nameLabel.frame = CGRectMake(nameOriginX, headerInsetY, nameSize.width, nameSize.height);
    
    //* Set dateLabel
    CGSize dateSize = [self sizeForString:dateLabel.text withFont:dateLabel.font];
    dateLabel.frame = CGRectMake(nameOriginX, headerInsetY + nameSize.height + 4, dateSize.width, dateSize.height);
    
    //* Set contentLabel
    CGSize contentSize = [self sizeForString:contentLabel.text withFont:contentLabel.font];
    contentLabel.frame = CGRectMake(10, contentLabelInset + (avatarImageView.frame.origin.y + avatarImageView.frame.size.height), contentSize.width, contentSize.height);
    
    // Set commentsLabel
    commentsLabel = [UILabel new];
    CGRect contentFrame = contentLabel.frame;
    [commentsLabel setFrame:CGRectMake(0, (contentFrame.origin.y + contentFrame.size.height + 8), 320, 30.0)];
    commentsLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    commentsLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0];
    commentsLabel.textColor = [UIColor darkGrayColor];
    commentsLabel.textAlignment = NSTextAlignmentCenter;
    commentsLabel.layer.borderWidth = 0.5;
    commentsLabel.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    [headerContainerView addSubview:commentsLabel];
    
    CGFloat height = contentLabel.frame.origin.y + contentLabel.frame.size.height + commentsLabel.frame.size.height;

    // Setup the headerView
    headerContainerView.frame = CGRectMake(0, 0, 320, height);
    
    self.tableView.tableHeaderView = headerContainerView;
}
                          
                          
- (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGSize size = [string sizeWithFont:font
                     constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


- (void)updateCommentCount
{
    int commentCount = (int)self.commentsArray.count;
    NSString *count;
    
    if (commentCount == 0)
        count = @"Add Comment";
    if (commentCount == 1)
        count = [NSString stringWithFormat:@"%d Comment", commentCount];
    else
        count = [NSString stringWithFormat:@"%d Comments", commentCount];
    
    commentsLabel.text = count;
}



@end
