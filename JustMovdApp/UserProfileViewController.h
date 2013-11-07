//
//  UsersViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *userProfileTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

//Properties
@property (strong, nonatomic) NSMutableArray *userInfosArray;
@property (strong, nonatomic) NSString *facebookUsername;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;


//Actions, methods

@end
