//
//  CommentViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFeedCellDelegate.h"

@interface CommentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActivityFeedCellDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property CGSize headerSize;
@property (strong, nonatomic) NSString *posterID;
@property (strong, nonatomic) PFObject *post;
@property (strong, nonatomic) UIImage  *avatarImage;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *postString;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *textViewContainer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


// HeaderView
@property (strong, nonatomic) UILabel *commentsLabel;




- (IBAction)addCommentPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
