//
//  ActivityFeedViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PostCellDelegate.h"
#import "AddNewPostToActivityFeedDelegate.h"


@class UpdateCellHeader;

@interface ActivityFeedViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, PostCellDelegate, AddNewPostToActivityFeedDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

- (IBAction)unwindFromCheckInVC:(UIStoryboardSegue *)unwindSegue;



@end
