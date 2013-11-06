//
//  SearchUsersViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextBox;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *chatTextBoxViewContainer;


//Properties
@property (strong, nonatomic) NSMutableArray *chatArray;
@property (strong, nonatomic) UIButton *hiddenButton;
@property (strong, nonatomic) PFObject *selectedUser;


//Methods
- (IBAction)actionSendMessage:(id)sender;
- (IBAction)actionRefresh:(id)sender;



@end
