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
#import "SWRevealViewController.h"

@interface OpenConversationViewController ()
{
    BOOL isDataReady;
    TTTTimeIntervalFormatter *timeFormatter;
    UILabel *noConversationLabel;
    NSMutableArray *tempArray;
    int returnedObjectsCount;
    SpinnerViewController *spinner;
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
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [super viewDidLoad];
    [self initializeStuffing];
    [self removeApplicationBadge];
    
    for (UIView *notiView in self.navigationController.navigationBar.subviews) {
        if (notiView.tag == 1) {
            [notiView removeFromSuperview];
            [self.navigationController.navigationBar setNeedsDisplay];
        }
    }
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
    spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
}

- (void)removeApplicationBadge
{
    if ([PFUser currentUser]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveInBackground];
    }
}

- (void)initializeStuffing
{
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    
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
    
//    PFQuery *conversationFromQuery = [PFQuery queryWithClassName:@"Conversation"];
//    [conversationFromQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
//    PFQuery *conversationToQuery = [PFQuery queryWithClassName:@"Conversation"];
//    [conversationToQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
//    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[conversationFromQuery, conversationToQuery]];
//    [combinedQuery includeKey:@"toUser"];
//    [combinedQuery includeKey:@"fromUser"];
//    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *combinedObjects, NSError *error) {
//        NSLog(@"combineQuery %@", combinedObjects);
//        PFUser *thisUser;
//        for(PFObject *object in combinedObjects)
//            thisUser = [object objectForKey:@"toUser"];
//        NSLog(@"%@", thisUser);
//    }];
    
    
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationQuery includeKey:@"toUser"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        returnedObjectsCount = (int)objects.count;
        
        if (objects.count > 0)
        {
            for (PFObject *conversationObject in objects)
            {
                if ([conversationObject objectForKey:@"toUser"]) {
                    PFUser *toUserObject = [conversationObject objectForKey:@"toUser"];
                    NSMutableDictionary *userInfoDictionary = [[NSMutableDictionary alloc] init];
                    if ([conversationObject objectForKey:@"isShowBadge"]) {
                        [userInfoDictionary setObject:[conversationObject objectForKey:@"isShowBadge"] forKey:@"isShowBadge"];
                    }
                    else {
                        [userInfoDictionary setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
                    }
                    [userInfoDictionary setObject:toUserObject forKey:@"user"];
                    PFFile *imageFile = [toUserObject objectForKey:@"profilePictureFile"];
                    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                     {
                         UIImage *userProfileImage = [UIImage imageWithData:data];
                         [userInfoDictionary setObject:userProfileImage forKey:@"profilePic"];
                         [self addLastMessagesWithUser:toUserObject toDictionary:userInfoDictionary];
                         [tempArray addObject:userInfoDictionary];
                     }];
                }
            }
        }
        else
        {
            [spinner.view setHidden:YES];
        }
    }];
}

- (void)addLastMessagesWithUser:(PFObject *)user toDictionary:(NSMutableDictionary *)dictionary
{
    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [messageOfCurrentUser whereKey:@"toUser" equalTo:user];
    
    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
    [messageOfUserObject whereKey:@"fromUser" equalTo:user];
    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
    
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
    [messageQuery orderByAscending:@"createdAt"];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error)
     {
         [dictionary setObject:[[messages lastObject] objectForKey:@"contentText"] forKey:@"lastMessage"];
         [dictionary setObject:[[messages lastObject] createdAt] forKey:@"messageTime"];
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
         
     }];
}

- (void)removeConversationFromParseForUserAtIndexPath:(NSIndexPath *)indexPath
{
    //Query for all messages from 
    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [messageOfCurrentUser whereKey:@"toUser" equalTo:[openConversationArray[indexPath.row] objectForKey:@"user"]];
    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
    [messageOfUserObject whereKey:@"fromUser" equalTo:[openConversationArray[indexPath.row] objectForKey:@"user"]];
    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error)
     {
         [PFObject deleteAll:messages];
     }];
    

    PFQuery *conversationFromUserQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationFromUserQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationFromUserQuery whereKey:@"toUser" equalTo:[openConversationArray[indexPath.row] objectForKey:@"user"]];
    PFQuery *conversationToUserQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationToUserQuery whereKey:@"fromUser" equalTo:[openConversationArray[indexPath.row] objectForKey:@"user"]];
    [conversationToUserQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
    PFQuery *conversationQuery = [PFQuery orQueryWithSubqueries:@[conversationFromUserQuery, conversationToUserQuery]];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PFObject deleteAll:objects];
    }];

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
    return 85.0;
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


- (IBAction)actionLogOut:(id)sender
{
    [PFUser logOut];
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
