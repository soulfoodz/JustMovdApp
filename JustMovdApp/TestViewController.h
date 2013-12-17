//
//  TestViewController.h
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/30/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface TestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
