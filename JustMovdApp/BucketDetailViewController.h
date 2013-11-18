//
//  BucketDetailViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PFObject *bucket;

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
