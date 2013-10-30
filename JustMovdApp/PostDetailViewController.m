//
//  PostDetailViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PostDetailViewController.h"
#import "ActivityFeedCell.h"
#import "FakeProfileViewController.h"


#define maxContentWidth 290.0f
#define nameOriginX (avatarSpacing + self.avatarImageView.frame.size.width + 10.0f)
#define dateOriginX (avatarSpacing + self.avatarImageView.frame.size.width + 10.0f)
#define headerInsetY 6.0f
#define contentLabelInset 6.0f
#define avatarSpacing 6.0f

#define ConnectionErrorAlertTag 1
#define NoTextErrorAlertTag 2


@interface PostDetailViewController ()

@end



@implementation PostDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    [self setupTableHeader];
    [self queryForComments];
}


- (void)queryForComments
{
    PFQuery *queryForPostComments;
    
    queryForPostComments = [PFQuery queryWithClassName:@"Activity"];
    [queryForPostComments whereKey:@"type" equalTo:@"JMComment"];
    [queryForPostComments whereKey:@"post" equalTo:self.post];
    [queryForPostComments includeKey:@"user"];
    [queryForPostComments orderByDescending:@"createdAt"];
    
    queryForPostComments.limit = 10;
    queryForPostComments.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [queryForPostComments findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         if (!error)
         {
             self.commentsArray = [[NSMutableArray arrayWithArray:comments] mutableCopy];
             [self.tableView reloadData];
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
    
    return self.commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityFeedCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[ActivityFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PFUser   *commentCreator  = [self.commentsArray[indexPath.row] objectForKey:@"user"];
    NSString *contentString   = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
    NSDate   *createdDate     = [self.commentsArray[indexPath.row] createdAt];
    
    cell.delegate = self;
    
    [cell setUser:commentCreator];
    [cell setDate:createdDate];
    [cell setContentLabelTextWith:contentString];

    [cell removeFooter];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString;
    CGFloat cellHeight;
    
    if (!self.commentsArray) return 100.0f;
    else
    {
        contentString = [self.commentsArray[indexPath.row] objectForKey:@"textContent"];
        cellHeight = [ActivityFeedCell heightForCellWithContentString:contentString];
        return cellHeight;
    }
}


- (void)avatarImageWasTappedForUser:(PFUser *)user
{
    NSLog(@"Tapped");
    UIStoryboardSegue *segue;
    
    FakeProfileViewController *destVC;
    destVC = [FakeProfileViewController new];
    
    segue = [UIStoryboardSegue segueWithIdentifier:@"SegueToProfileVC"
                                            source:self
                                       destination: destVC
                                    performHandler:^{
                                        destVC.user = user;
                                    }];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.cancelButton.enabled = YES;
    
    // Get frame of last cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsArray.count - 1) inSection:0];
    CGRect lastCellRect = [[self.tableView cellForRowAtIndexPath:indexPath] frame];
    
    
    // Animate the textViewContainer up
    [UIView animateWithDuration:0.3f animations:^{
        self.textViewContainer.frame = CGRectMake(0,(self.view.frame.size.height - (216 + 48)),320, 48);
        
        // Scroll the tableview above the keyboard
        self.tableView.frame = CGRectMake(0,0,320,304);
        
        // Check where the last cell is and animate the tableview up if hidden
        if((CGRectContainsPoint(lastCellRect, self.textViewContainer.frame.origin)) ||
           (lastCellRect.origin.y > self.textViewContainer.frame.origin.y + self.textViewContainer.frame.size.height))
        {
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }
    }];
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.cancelButton.enabled = NO;
    [self.textView resignFirstResponder];
    
    // Reset the textViews frame and content
    self.textView.text = @"";
    
    [UIView animateWithDuration:0.3f animations:^{

        // Scroll the tableview above the keyboard
        self.tableView.frame = CGRectMake(0,0,320,520);
       
        [self.tableView scrollToRowAtIndexPath:0
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        
        self.textViewContainer.frame = CGRectMake(self.textViewContainer.frame.origin.x,
                                                  self.view.frame.size.height - self.textViewContainer.frame.size.height,
                                                  self.textViewContainer.frame.size.width,
                                                  self.textViewContainer.frame.size.height);
    }];
    return YES;
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
    
    NSTimer *timeOutTimer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(handleConnectionTimeOut) userInfo:nil repeats:NO];
    
    [newComment saveEventually:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [timeOutTimer invalidate];
            [self.commentsArray removeObject:newComment];
        }
            }];
    
    [self.commentsArray insertObject:newComment atIndex:0];
    [self.textView resignFirstResponder];
    [self.tableView reloadData];
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
    
    alertView.tag = ConnectionErrorAlertTag;
    [alertView show];
}


- (void)displayNoTextAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where's the post?"
                                                    message:@"You didn't mean to post nothing did you?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    alert.tag = NoTextErrorAlertTag;
    [alert show];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
}

                          
- (void)setupTableHeader
{
    // Setup the containerView
    self.headerContainerView = [UIView new];
    self.headerContainerView.backgroundColor = [UIColor whiteColor];
    
    // Setup the nameLabel
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.numberOfLines = 1;
    [self.headerContainerView addSubview:self.nameLabel];
    
    // Setup the dateLabel
    self.dateLabel = [UILabel new];
    self.dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.numberOfLines = 1;
    [self.headerContainerView addSubview:self.dateLabel];
    
    // Setup the contentLabel
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    [self.headerContainerView addSubview:self.contentLabel];
    
    // Setup the profileImage
    self.avatarImageView = [PFImageView new];
    self.avatarImageView.backgroundColor = [UIColor clearColor];
    self.avatarImageView.layer.cornerRadius = 22.0f;
    self.avatarImageView.clipsToBounds = YES;
    [self.headerContainerView addSubview:self.avatarImageView];
    
    // Setup the profileImageButton
    self.avatarButton = [UIButton new];
    self.avatarButton.backgroundColor = [UIColor clearColor];
    self.avatarButton.userInteractionEnabled = NO;
    [self.avatarButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerContainerView addSubview:self.avatarButton];
    
    // Set text and images for labels/images
    self.contentLabel.text = self.post[@"textContent"];
    self.dateLabel.text = self.dateString;
    self.nameLabel.text = self.userName;
    self.avatarImageView.image = self.avatarImage;
    
    
    //* Set profileImageView
    self.avatarImageView.frame = CGRectMake(6, headerInsetY, 44, 44);
    self.avatarButton.frame = CGRectMake(6, headerInsetY, 44, 44);
    
    //* Set nameLabel
    CGSize nameSize = [self sizeForString:self.nameLabel.text withFont:self.nameLabel.font];
    self.nameLabel.frame = CGRectMake(nameOriginX, headerInsetY, nameSize.width, nameSize.height);
    
    //* Set dateLabel
    CGSize dateSize = [self sizeForString:self.dateLabel.text withFont:self.dateLabel.font];
    self.dateLabel.frame = CGRectMake(nameOriginX, headerInsetY + nameSize.height + 4, dateSize.width, dateSize.height);
    
    //* Set contentLabel
    CGSize contentSize = [self sizeForString:self.contentLabel.text withFont:self.contentLabel.font];
    self.contentLabel.frame = CGRectMake(10, contentLabelInset + (self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height), contentSize.width, contentSize.height);
    
    
    CGFloat height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10;
    
    self.headerContainerView.frame = CGRectMake(0, 0, 320, height);
    self.tableView.tableHeaderView = self.headerContainerView;
}
                          
                          
- (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGSize size = [string sizeWithFont:font
                     constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


@end
