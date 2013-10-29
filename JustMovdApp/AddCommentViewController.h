//
//  AddCommentViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddCommentViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;


- (IBAction)cancelPressed:(id)sender;
- (IBAction)postPressed:(id)sender;


@end
