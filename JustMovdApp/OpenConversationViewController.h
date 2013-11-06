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


//Properties
@property (strong, nonatomic) NSMutableArray *openConversationArray;


//Actions
- (IBAction)actionLogOut:(id)sender;

@end
