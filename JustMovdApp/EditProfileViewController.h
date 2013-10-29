//
//  EditProfileViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/27/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *editProfileTableView;


//Properties
@property (strong, nonatomic) NSMutableDictionary *passInUserInfoDictionary;





@end
