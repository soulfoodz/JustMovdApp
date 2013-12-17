//
//  OpenConversationViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "OpenConversationViewController.h"
#import "OpenConversationCell.h"
#import "MessagingViewController.h"
#import "TTTTimeIntervalFormatter.h"
#import "SpinnerViewController.h"
#import "ParseServices.h"

@interface OpenConversationViewController ()
{
    BOOL isDataReady;
    TTTTimeIntervalFormatter *timeFormatter;
    UILabel *noConversationLabel;
    NSMutableArray *tempArray;
    int returnedObjectsCount;
    SpinnerViewController *spinner;
    UIImage *currentUserProfilePicture;
}

@end

@implementation OpenConversationViewController
@synthesize openConversationTableView;
@synthesize openConversationArray;
@synthesize  sideBarButton;


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConversation) name:@"NewMessageNotification" object:nil];
    
    [self addSideBarMenu];
    
    [ParseServices queryForProfilePictureOfUser:[PFUser currentUser] completionBlock:^(NSArray *results, BOOL success) {
        if (success) {
            currentUserProfilePicture = results[0];
        }
    }];
    
    [super viewDidLoad];
    [self initializeStuffing];
}

- (void)addSideBarMenu
{
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
}

- (void)refreshConversation
{
    isDataReady = NO;
    [tempArray removeAllObjects];
    [openConversationArray removeAllObjects];
    [self loadOpenConversationsForCurrentUserFromParse];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshConversation];
    [self removeApplicationBadge];
    self.revealViewController.delegate = self;
}

- (void)removeApplicationBadge
{
    if ([PFUser currentUser]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        if (currentInstallation.badge != 0) {
            currentInstallation.badge = 0;
            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [currentInstallation saveEventually];
                }
            }];
        }
    }
    
//    Remove notification indicator badge
//    for (UIView *notiView in self.navigationController.navigationBar.subviews) {
//        if (notiView.tag == 1) {
//            [notiView removeFromSuperview];
//        }
//    }
}

- (void)initializeStuffing
{
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    
    spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
    noConversationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    noConversationLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20.0];
    noConversationLabel.textColor = [UIColor lightGrayColor];
    noConversationLabel.textAlignment = NSTextAlignmentCenter;
    noConversationLabel.text = @"No Conversation";
    [openConversationTableView addSubview:noConversationLabel];
    noConversationLabel.center = openConversationTableView.center;
    [noConversationLabel setHidden:YES];
    
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    openConversationArray = [[NSMutableArray alloc] init];
    tempArray = [[NSMutableArray alloc] init];
}

- (void)loadOpenConversationsForCurrentUserFromParse
{
    returnedObjectsCount = 0;
    [ParseServices queryForOpenConversationsByCurrentUserWithCompletionBlock:^(NSArray *results, BOOL success)
     {
         if (success) {
             
             if (results.count > 0)
             {
                 for (PFObject *conversationObject in results)
                 {
                     PFUser *toUser = [conversationObject objectForKey:@"toUser"];
                     if (toUser) {
                         returnedObjectsCount++;
                         PFUser *toUserObject = [conversationObject objectForKey:@"toUser"];
                         NSMutableDictionary *userInfoDictionary = [[NSMutableDictionary alloc] init];
                         if ([conversationObject objectForKey:@"isShowBadge"]) {
                             [userInfoDictionary setObject:[conversationObject objectForKey:@"isShowBadge"] forKey:@"isShowBadge"];
                         }
                         else {
                             [userInfoDictionary setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
                         }
                         [userInfoDictionary setObject:toUserObject forKey:@"user"];
                         [ParseServices queryForProfilePictureOfUser:toUserObject completionBlock:^(NSArray *results, BOOL success)
                          {
                              if (success) {
                                  UIImage *userProfileImage = results[0];
                                  [userInfoDictionary setObject:userProfileImage forKey:@"profilePic"];
                                  [self addLastMessagesWithUser:toUserObject toDictionary:userInfoDictionary];
                                  [tempArray addObject:userInfoDictionary];
                              }
                          }];
                     }
                 }
             }
             else
             {
                 [spinner.view setHidden:YES];
             }
         }
    }];
}

- (void)addLastMessagesWithUser:(PFUser *)user toDictionary:(NSMutableDictionary *)dictionary
{
    [ParseServices queryForLastMessageWithUser:user completionBlock:^(NSArray *results, BOOL success)
     {
         if (success && results.count > 0)
         {
             [dictionary setObject:[[results lastObject] objectForKey:@"contentText"] forKey:@"lastMessage"];
             [dictionary setObject:[[results lastObject] createdAt] forKey:@"messageTime"];
             
             if (tempArray.count >= 2)
             {
                 tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                     NSDate *obj1Time = [obj1 objectForKey:@"messageTime"];
                     NSDate *obj2Time = [obj2 objectForKey:@"messageTime"];
                     return [obj2Time compare:obj1Time];
                 }].mutableCopy;
                 
                 if (tempArray.count == returnedObjectsCount)
                 {
                     isDataReady = YES;
                     [openConversationArray removeAllObjects];
                     [openConversationArray addObjectsFromArray:tempArray];
                     [openConversationTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
             }
             else
             {
                 if (tempArray.count == returnedObjectsCount)
                 {
                     isDataReady = YES;
                     [openConversationArray removeAllObjects];
                     [openConversationArray addObjectsFromArray:tempArray];
                     [openConversationTableView reloadData];
                     [spinner.view setHidden:YES];
                 }
             }
         }
     }];
}

- (void)removeConversationFromParseForUserAtIndexPath:(NSIndexPath *)indexPath
{
    [ParseServices deleteConversationAndMessagesWithUser:[openConversationArray[indexPath.row] objectForKey:@"user"]];
}

#pragma mark - Table view data source

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing == YES)
    {
        // Your code for entering edit mode goes here
        [openConversationTableView setEditing:editing animated:animated];
    } else {
        // Your code for exiting edit mode goes here
        [openConversationTableView setEditing:editing animated:animated];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (openConversationArray.count < 1 || !isDataReady)
    {
        [noConversationLabel setHidden:NO];
        return 0;
    }
    else
    {
        [noConversationLabel setHidden:YES];
        return openConversationArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OpenConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OpenConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (isDataReady)
    {
        NSString *name = [[openConversationArray[indexPath.row] objectForKey:@"user"] objectForKey:@"firstName"];
        
        NSString *lastMessage = [openConversationArray[indexPath.row] objectForKey:@"lastMessage"];
        id messageTime = [openConversationArray[indexPath.row] objectForKey:@"messageTime"];
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:messageTime];
        int isShowBadge = [[openConversationArray[indexPath.row] objectForKey:@"isShowBadge"] intValue];
        cell.nameLabel.text = name;
        cell.timeLabel.text = timeString;
        cell.profilePicture.image = [openConversationArray[indexPath.row] objectForKey:@"profilePic"];
        cell.detailLabel.text = lastMessage;
        cell.isNew = isShowBadge;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isDataReady) {
        [self performSegueWithIdentifier:@"segueConversationToMessage" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [openConversationTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"segueConversationToMessage"]) {
        MessagingViewController *messagingVC = segue.destinationViewController;
        messagingVC.selectedUser = [openConversationArray[indexPath.row] objectForKey:@"user"];
        messagingVC.currentUserImage = currentUserProfilePicture;
        messagingVC.selectedUserImage = [openConversationArray[indexPath.row] objectForKey:@"profilePic"];
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeConversationFromParseForUserAtIndexPath:indexPath];
        [tableView beginUpdates];
        [openConversationArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}


#pragma mark - SWRevealVCDelegate Methods

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeft)
    {
        self.openConversationTableView.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    if (position == FrontViewPositionRight)
        self.openConversationTableView.userInteractionEnabled = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewMessageNotification" object:nil];
}




@end
