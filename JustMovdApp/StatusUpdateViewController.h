//
//  AddCommentViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddNewPostToActivityFeedDelegate.h"

@class FBPlace;


@interface StatusUpdateViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, FBPlacePickerDelegate>

@property BOOL presentingCheckIn;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) id <AddNewPostToActivityFeedDelegate> delegate;
@property (strong, nonatomic) id <FBGraphPlace> selectedPlace;
@property (strong, nonatomic) PFFile *mapFile;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UIImageView *mapImage;
@property (strong, nonatomic) NSString *nameString;
@property (strong, nonatomic) PFImageView *avatarImageView;


- (IBAction)cancelPressed:(id)sender;
- (IBAction)postPressed:(id)sender;
- (IBAction)unwindSegueFromCheckInLocation:(UIStoryboardSegue *)unwindSegue;


@end
