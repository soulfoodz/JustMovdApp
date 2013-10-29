//
//  PostDetailViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFeedCellDelegate.h"

@interface PostDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActivityFeedCellDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property CGSize headerSize;
@property (strong, nonatomic) NSString *posterID;
@property (strong, nonatomic) PFObject *post;
@property (strong, nonatomic) UIImage  *avatarImage;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *postString;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSMutableArray *commentorsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *textViewContainer;

// HeaderView
@property (strong, nonatomic) UIView *headerContainerView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) PFImageView *avatarImageView;
@property (strong, nonatomic) UIButton *avatarButton;



- (IBAction)addCommentPressed:(id)sender;

@end
