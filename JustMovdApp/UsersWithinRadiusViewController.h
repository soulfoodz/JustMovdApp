//
//  UsersWithinRadiusViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 11/1/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersWithinRadiusViewController : UITableViewController

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *UserListTableView;


//Properties
@property (strong, nonatomic) NSMutableArray *userListArray;


@end
