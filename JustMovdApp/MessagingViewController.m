//
//  SearchUsersViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "MessagingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageBubbleLeftCell.h"
#import "MessageBubbleRightCell.h"

@interface MessagingViewController ()
{
    UITextView *dummyTextView;
    UIImage *currentUserImage;
    UIImage *selectedUserImage;
    id lastFetchTime;
}

@end

@implementation MessagingViewController
@synthesize chatArray;
@synthesize messagesTableView;
@synthesize sendButton;
@synthesize chatTextBox;
@synthesize chatTextBoxViewContainer;
@synthesize hiddenButton;
@synthesize selectedUser;

 
 
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionRefresh:) name:@"NewMessageNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentingMessagingOn" object:nil];
    
    self.view.layer.shouldRasterize = YES;
    self.view.layer.rasterizationScale = 2.0;
    
    [self setupChatAccessoriesView];
    [self retrieveMessagesFromParse];
    [self removeBadgeForConversation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkSendButtonState];
}

- (void)setupChatAccessoriesView
{
    self.title = [selectedUser objectForKey:@"firstName"];
    
    PFFile *currentUserImageFile = [[PFUser currentUser] objectForKey:@"profilePictureFile"];
    [currentUserImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        currentUserImage = [UIImage imageWithData:data];
    }];
    
    PFFile *selectedUserImageFile = [selectedUser objectForKey:@"profilePictureFile"];
    [selectedUserImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        selectedUserImage = [UIImage imageWithData:data];
    }];
    
    chatArray = [[NSMutableArray alloc] init];
    
    hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 308)];
    [hiddenButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];
    [hiddenButton setHidden:YES];
    
    //chatTextBoxViewContainer.layer.borderWidth = 0.5;
    chatTextBoxViewContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    chatTextBox.layer.cornerRadius  = 5;
    chatTextBox.layer.borderWidth   = 0.5;
    chatTextBox.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    
    sendButton.layer.cornerRadius   = 5;
    
    dummyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
}

- (void)dismissKeyboard
{
    [hiddenButton setHidden:YES];
    [chatTextBox resignFirstResponder];
    
    CGRect frame = chatTextBoxViewContainer.frame;
    frame.origin.y += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBoxViewContainer setFrame:frame];
        NSLog(@"%f", chatTextBoxViewContainer.frame.origin.y);
    }];
    
    CGRect tableViewFrame = messagesTableView.frame;
    tableViewFrame.size.height += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [messagesTableView setFrame:tableViewFrame];
    }];
    
    CGRect sendButtonFrame = sendButton.frame;
    sendButtonFrame.origin.y += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [sendButton setFrame:sendButtonFrame];
    }];
    
    CGRect chatBoxFrame = chatTextBox.frame;
    chatBoxFrame.origin.y += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBox setFrame:chatBoxFrame];
        NSLog(@"%f", chatBoxFrame.origin.y);
    }];
    
    [self scrollToBottomTableViewWithAnimation:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect chatBoxViewFrame = chatTextBoxViewContainer.frame;
    chatBoxViewFrame.origin.y -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBoxViewContainer setFrame:chatBoxViewFrame];
    } completion:^(BOOL finished) {
        [hiddenButton setHidden:NO];
    }];
    
    CGRect tableViewFrame = messagesTableView.frame;
    tableViewFrame.size.height -= 216;
    [UIView animateWithDuration:0.5 animations:^{
        [messagesTableView setFrame:tableViewFrame];
    }];
    
    CGRect sendButtonFrame = sendButton.frame;
    sendButtonFrame.origin.y -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        [sendButton setFrame:sendButtonFrame];
    }];
    
    CGRect chatBoxFrame = chatTextBox.frame;
    chatBoxFrame.origin.y -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBox setFrame:chatBoxFrame];
    }];
    
    [self scrollToBottomTableViewWithAnimation:YES];
    
    return YES;
}

- (void)decreaseChatTextBoxSize
{
    if ([chatTextBox isFirstResponder])
    {
        float maxY = [UIScreen mainScreen].bounds.size.height - 216.0;
        
        CGRect chatViewContainerFrame = chatTextBoxViewContainer.frame;
        chatViewContainerFrame.size.height = 44;
        chatViewContainerFrame.origin.y = maxY - chatViewContainerFrame.size.height;
        [chatTextBoxViewContainer setFrame:chatViewContainerFrame];
        
        CGRect chatTextBoxFrame = chatTextBox.frame;
        chatTextBoxFrame.size.height = 33;
        chatTextBoxFrame.origin.y = maxY - chatTextBoxFrame.size.height - 6;
        [chatTextBox setFrame:chatTextBoxFrame];
        
        CGRect hiddenButtonFrame = hiddenButton.frame;
        hiddenButtonFrame.size.height = chatTextBoxViewContainer.frame.origin.y;
        [hiddenButton setFrame:hiddenButtonFrame];
        
        CGRect tableViewFrame = messagesTableView.frame;
        tableViewFrame.size.height = maxY - chatViewContainerFrame.size.height;
        [messagesTableView setFrame:tableViewFrame];
        [self scrollToBottomTableViewWithAnimation:YES];
    }
    else
    {
        float maxY = [UIScreen mainScreen].bounds.size.height;
        
        CGRect chatViewContainerFrame = chatTextBoxViewContainer.frame;
        chatViewContainerFrame.size.height = 44;
        chatViewContainerFrame.origin.y = maxY - chatViewContainerFrame.size.height;
        [chatTextBoxViewContainer setFrame:chatViewContainerFrame];
        
        CGRect chatTextBoxFrame = chatTextBox.frame;
        chatTextBoxFrame.size.height = 33;
        chatTextBoxFrame.origin.y = maxY - chatTextBoxFrame.size.height - 6;
        [chatTextBox setFrame:chatTextBoxFrame];
        
        CGRect hiddenButtonFrame = hiddenButton.frame;
        hiddenButtonFrame.size.height = chatTextBoxViewContainer.frame.origin.y;
        [hiddenButton setFrame:hiddenButtonFrame];
        
        CGRect tableViewFrame = messagesTableView.frame;
        tableViewFrame.size.height = maxY - chatViewContainerFrame.size.height;
        [messagesTableView setFrame:tableViewFrame];
        [self scrollToBottomTableViewWithAnimation:YES];
    }
}

- (void)increaseChatTextBoxSize
{
    if ([chatTextBox isFirstResponder])
    {
        CGRect chatViewContainerFrame = chatTextBoxViewContainer.frame;
        float maxY = [UIScreen mainScreen].bounds.size.height - 216.0;
        
        chatViewContainerFrame.size.height = chatTextBox.contentSize.height + 11;
        chatViewContainerFrame.origin.y = maxY - chatViewContainerFrame.size.height;
        [chatTextBoxViewContainer setFrame:chatViewContainerFrame];
        
        CGRect chatTextBoxFrame = chatTextBox.frame;
        chatTextBoxFrame.size.height = chatTextBoxViewContainer.frame.size.height - 11;
        chatTextBoxFrame.origin.y = maxY - chatTextBoxFrame.size.height - 6;
        [chatTextBox setFrame:chatTextBoxFrame];
        
        CGRect hiddenButtonFrame = hiddenButton.frame;
        hiddenButtonFrame.size.height = chatTextBoxViewContainer.frame.origin.y;
        [hiddenButton setFrame:hiddenButtonFrame];
        
        CGRect tableViewFrame = messagesTableView.frame;
        tableViewFrame.size.height = maxY - chatViewContainerFrame.size.height;
        [messagesTableView setFrame:tableViewFrame];
        [self scrollToBottomTableViewWithAnimation:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length <= 0) //Should always be 0, for only BACKSPACE will call this
    {
        NSLog(@"backspace");
        [self increaseChatTextBoxSize];
        //return YES; //  <-- must always return YES to delete, else doesnt delete anything
    }
    
    [self checkSendButtonState];
    
    return YES;
}

- (void)checkSendButtonState
{
    if (chatTextBox.text.length < 1) {
        [sendButton setAlpha:0.2];
        [sendButton setEnabled:NO];
    }
    else {
        [sendButton setAlpha:1.0];
        [sendButton setEnabled:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkSendButtonState];
    
    if (textView.frame.size.height < 100) {
        [self increaseChatTextBoxSize];
    }
    
    [textView scrollRangeToVisible:NSMakeRange([textView.text length] -1, 1)];
}

- (void)sendMessageToParse
{
    PFObject *messageObject = [PFObject objectWithClassName:@"Message"];
    [messageObject setObject:[PFUser currentUser] forKey:@"fromUser"];
    [messageObject setObject:selectedUser forKey:@"toUser"];
    [messageObject setObject:chatTextBox.text forKey:@"contentText"];
    [messageObject saveInBackground];
    
    chatTextBox.text = @"";
    [self decreaseChatTextBoxSize];
}

//- (void)retrieveMessagesFromParse
//{
//    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
//    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
//    [messageOfCurrentUser whereKey:@"toUser" equalTo:selectedUser];
//    
//    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
//    [messageOfUserObject whereKey:@"fromUser" equalTo:selectedUser];
//    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
//    
//    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
//    [messageQuery orderByAscending:@"createdAt"];
//    if (lastFetchTime) {
//        [messageQuery whereKey:@"createdAt" greaterThan:lastFetchTime];
//    }
//    //[conversationQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//    {
//        
//        [chatArray addObjectsFromArray:objects];
//        lastFetchTime = [[chatArray lastObject] createdAt];
//        [messagesTableView reloadData];
//        if (lastFetchTime) {
//            [self scrollToBottomTableViewWithAnimation:YES];
//        }
//        else {
//            [self scrollToBottomTableViewWithAnimation:NO];
//        }
//    }];
//}

- (void)retrieveMessagesFromParse
{
    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [messageOfCurrentUser whereKey:@"toUser" equalTo:selectedUser];
    
    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
    [messageOfUserObject whereKey:@"fromUser" equalTo:selectedUser];
    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
    
    if (!lastFetchTime)
    {
        PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
        [messageQuery orderByAscending:@"createdAt"];
        [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (objects.count > 0)
             {
                 [chatArray addObjectsFromArray:objects];
                 lastFetchTime = [[chatArray lastObject] createdAt];
                 [messagesTableView reloadData];
                 [self scrollToBottomTableViewWithAnimation:NO];
             }
             //NSLog(@"Object Sample %@", chatArray[0]);
         }];
    }
    else
    {
        [messageOfUserObject orderByAscending:@"createdAt"];
        [messageOfUserObject whereKey:@"createdAt" greaterThan:lastFetchTime];
        [messageOfUserObject findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             [chatArray addObjectsFromArray:objects];
             lastFetchTime = [[chatArray lastObject] createdAt];
             [messagesTableView reloadData];
             AudioServicesPlaySystemSound(1103);
             [self scrollToBottomTableViewWithAnimation:YES];
         }];
    }
}

- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 24;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string boundingRectWithSize:CGSizeMake(widthOfTextView, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]} context:nil].size.height + verticalPadding;

    return height;
}


# pragma mark Table View

- (void)scrollToBottomTableViewWithAnimation:(BOOL)animated
{
    if ([messagesTableView numberOfRowsInSection:0] > 0)
    {
        [messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([messagesTableView numberOfRowsInSection:0] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (chatArray.count < 1) {
        return 0;
    }
    else
        return chatArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentString = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"contentText"];
    dummyTextView.text = contentString;
    
//    CGFloat fixedWidth = dummyTextView.frame.size.width;
//    CGSize newSize = [dummyTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//    CGRect newFrame = dummyTextView.frame;
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    dummyTextView.frame = newFrame;
    
    float height = [self heightForTextView:dummyTextView containingString:contentString];
    //NSLog(@"Content height: %f Width: %f", height, dummyTextView.contentSize.width);
    return height + 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *leftID     = @"leftcell";
    static NSString *rightID    = @"rightCell";

    MessageBubbleRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:rightID];
    if (!rightCell) {
        rightCell = [[MessageBubbleRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightID];
    }
    
    MessageBubbleLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:leftID];
    if (!leftCell) {
        leftCell = [[MessageBubbleLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftID];
    }

    NSString *contentString = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"contentText"];
    PFUser *checkUser = [[chatArray objectAtIndex:indexPath.row] objectForKey:@"fromUser"];
    if ([checkUser.objectId isEqualToString:[PFUser currentUser].objectId]) {
        rightCell.chatContent.text = contentString;
        rightCell.profileMiniPic.image = currentUserImage;
        return rightCell;
    }
    else {
        leftCell.chatContent.text = contentString;
        leftCell.profileMiniPic.image = selectedUserImage;
        return leftCell;
    }
}

- (IBAction)actionSendMessage:(id)sender
{
    if ([chatTextBox.text length] > 0)
    {        
        //Add this message to TableView to save a push notification
        NSMutableDictionary *currentUserNewMessage = [[NSMutableDictionary alloc] init];
        [currentUserNewMessage setObject:selectedUser forKey:@"toUser"];
        [currentUserNewMessage setObject:[PFUser currentUser] forKey:@"fromUser"];
        [currentUserNewMessage setObject:chatTextBox.text forKey:@"contentText"];
        [chatArray addObject:currentUserNewMessage];
        [messagesTableView reloadData];
        [self scrollToBottomTableViewWithAnimation:YES];
        
        //Send message to PARSE
        [self sendMessageToParse];
        [self decreaseChatTextBoxSize];
        [self checkSendButtonState];
        
        PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
        [conversationQuery whereKey:@"fromUser" equalTo:selectedUser];
        [conversationQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [conversationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [object setObject:[NSNumber numberWithInt:1] forKey:@"isShowBadge"];
            [object saveInBackground];
        }];
        
        //Creating package to push
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ sent you a message", [[PFUser currentUser] objectForKey:@"firstName"]], @"alert",
                              @"", @"sound",
                              @"Increment", @"badge",
                              nil];
        
        //Query push to the right user
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"owner" equalTo:selectedUser];
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        [push setData:data];
        [push sendPushInBackground];
    }
}

- (void)removeBadgeForConversation
{
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationQuery whereKey:@"toUser" equalTo:selectedUser];
    [conversationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
        [object saveInBackground];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeBadgeForConversation];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [PFQuery cancelPreviousPerformRequestsWithTarget:self selector:@selector(retrieveMessagesFromParse) object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentingMessagingOff" object:nil];
}

- (IBAction)actionRefresh:(id)sender
{
    [self retrieveMessagesFromParse];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewMessageNotification" object:nil];
}

@end
