//
//  UsersViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostCellDelegate.h"
#import "EditProfileDelegate.h"
#import "SWRevealViewController.h"

@interface UserProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PostCellDelegate, EditProfileDelegate, SWRevealViewControllerDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *userProfileTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

//Properties
@property (strong, nonatomic) NSMutableArray *userInfosArray;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) UIImage *userProfilePicture;


//Actions, methods

@end
