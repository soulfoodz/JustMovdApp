//
//  BucketListViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/12/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
