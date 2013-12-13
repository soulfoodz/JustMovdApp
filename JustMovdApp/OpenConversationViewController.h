//
//  OpenConversationViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenConversationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UITableView *openConversationTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

//Properties
@property (strong, nonatomic) NSMutableArray *openConversationArray;

@end
