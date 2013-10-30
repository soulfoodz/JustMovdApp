//
//  SearchUsersViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ConversationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ConversationViewController ()
{
    int numberOfLines;
    
}

@end

@implementation ConversationViewController
@synthesize chatArray;
@synthesize conversationTableView;
@synthesize sendButton;
@synthesize chatTextBox;
@synthesize chatTextBoxViewContainer;
@synthesize hiddenButton;


- (void)viewDidLoad
{
    chatArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupChatAccessoriesView];

}

- (void)setupChatAccessoriesView
{
    [conversationTableView setClipsToBounds:NO];
    
    hiddenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 308)];
    [hiddenButton addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];
    [hiddenButton setHidden:YES];
    
    chatTextBox.layer.cornerRadius  = 5;
    chatTextBox.layer.borderWidth   = 0.5;
    chatTextBox.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    
    sendButton.layer.cornerRadius   = 5;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    NSLayoutConstraint *tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:conversationTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chatTextBoxViewContainer attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
//    [conversationTableView addConstraint:tableViewHeightConstraint];
//}

- (void)dismissKeyboard
{
    [hiddenButton setHidden:YES];
    
    CGRect frame = chatTextBoxViewContainer.frame;
    frame.origin.y += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBoxViewContainer setFrame:frame];
        NSLog(@"%f", frame.origin.y);
    }];
    
    CGRect tableViewFrame = conversationTableView.frame;
    tableViewFrame.size.height += 216;
    [UIView animateWithDuration:0.2 animations:^{
        [conversationTableView setFrame:tableViewFrame];
    }];
    
    CGRect sendButtonFrame = sendButton.frame;
    sendButtonFrame.origin.y += 216;
    [UIView animateWithDuration:0.3 animations:^{
        [sendButton setFrame:sendButtonFrame];
    }];
    
    [chatTextBox resignFirstResponder];

}

- (void)changeChatTextBoxSize
{
    

    CGRect chatViewContainerFrame = chatTextBoxViewContainer.frame;
    CGRect chatTextBoxFrame = chatTextBox.frame;
    //CGRect sendButtonFrame = sendButton.frame;
    float maxY = 352;
        if (chatTextBox.contentSize.height >= 33.0)
        {
            chatViewContainerFrame.size.height = chatTextBox.contentSize.height + 11;
            chatViewContainerFrame.origin.y = maxY - chatViewContainerFrame.size.height;
            chatTextBoxFrame.size.height = chatTextBox.contentSize.height;
            chatTextBoxFrame.origin.y = 5;

                [chatTextBoxViewContainer setFrame:chatViewContainerFrame];
                [chatTextBox setFrame:chatTextBoxFrame];
            
            
            //Keeps the send button in the same place from bottom up
            //sendButtonFrame.origin.y = (chatViewContainerFrame.size.height + chatViewContainerFrame.origin.x) - 36;
            //[sendButton setFrame:sendButtonFrame];
            
        }
    NSLog(@"height:%f y:%f", chatTextBox.contentSize.height, chatTextBox.frame.origin.y);
    
    if ([chatTextBox isFirstResponder]) {
        
    }
    else
    {
        float maxY = 568;
        if (chatTextBox.contentSize.height > 33.0)
        {
            chatViewContainerFrame.size.height = chatTextBox.contentSize.height + 8;
            chatViewContainerFrame.origin.y = maxY - chatViewContainerFrame.size.height;
            chatTextBoxFrame.size.height = chatTextBox.contentSize.height;
            chatTextBoxFrame.origin.y = 5;

                [chatTextBoxViewContainer setFrame:chatViewContainerFrame];
                [chatTextBox setFrame:chatTextBoxFrame];
            
            //Keeps the send button in the same place from bottom up
            //sendButtonFrame.origin.y = (chatViewContainerFrame.size.height + chatViewContainerFrame.origin.x) - 36;
            //[sendButton setFrame:sendButtonFrame];
            NSLog(@"height:%f y:%f", chatTextBox.frame.size.height, chatTextBox.frame.origin.y);
        }
    }
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeChatTextBoxSize];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect frame = chatTextBoxViewContainer.frame;
    frame.origin.y -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        [chatTextBoxViewContainer setFrame:frame];
    } completion:^(BOOL finished) {
        [hiddenButton setHidden:NO];
    }];
    
    CGRect tableViewFrame = conversationTableView.frame;
    tableViewFrame.size.height -= 216;
    [UIView animateWithDuration:0.5 animations:^{
        [conversationTableView setFrame:tableViewFrame];
    }];
    
    CGRect sendButtonFrame = sendButton.frame;
    sendButtonFrame.origin.y -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        [sendButton setFrame:sendButtonFrame];
    }];
    
    return YES;
}




# pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;
    
    
}

@end
