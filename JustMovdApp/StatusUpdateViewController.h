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
#import "CheckInLocation.h"

@class FBPlace;

typedef void (^callbackBlock)();

@interface StatusUpdateViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, FBPlacePickerDelegate>

@property BOOL presentingCheckIn;
@property (strong, nonatomic) callbackBlock reloadTVBlock;
@property (strong, nonatomic) id <AddNewPostToActivityFeedDelegate> delegate;
//@property (strong, nonatomic) id <FBGraphPlace> selectedPlace;
@property (strong, nonatomic) CheckInLocation *selectedPlace;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) PFFile *mapFile;
@property (strong, nonatomic) PFImageView *avatarImageView;

// Outlets
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UIImageView *mapImage;



- (IBAction)cancelPressed:(id)sender;
- (IBAction)postPressed:(id)sender;
- (IBAction)unwindSegueFromCheckInLocation:(UIStoryboardSegue *)unwindSegue;


@end
