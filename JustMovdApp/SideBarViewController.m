//
//  SideBarViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 11/4/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "IntroParentViewController.h"
#import "ActivityFeedViewController.h"
#import "FeedConnectorVC.h"
#import "OpenConversationViewController.h"
#import "UserProfileViewController.h"

@interface SideBarViewController ()
{
    NSArray *titlesForRows;
    SWRevealViewControllerSegue *feedSegue;
    ActivityFeedViewController *activityVC;
}

@end

@implementation SideBarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    titlesForRows = @[@"justmovd", @"feed", @"around", @"messages", @"profile", @"empty", @"empty", @"empty", @"empty", @"empty", @"sign"];
    
   // [self setupSegues];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titlesForRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [titlesForRows objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            if (indexPath.row == 1){
                
                UIStoryboard *feedSB = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
                //activityVC = [feedSB instantiateViewControllerWithIdentifier:@"recentActivityVC"];
                activityVC = [feedSB instantiateInitialViewController];
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[activityVC] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            } else if (indexPath.row == 2){
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[dvc] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            } else if (indexPath.row == 3){
                UIStoryboard *messagesSB = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
                OpenConversationViewController *conversationVC = [messagesSB instantiateViewControllerWithIdentifier:@"conversation"];
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[conversationVC] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            } else if (indexPath.row == 4){
                UIStoryboard *messagesSB = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
                UserProfileViewController *profileVC = [messagesSB instantiateViewControllerWithIdentifier:@"profile"];
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[profileVC] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                
            } else if (indexPath.row == 10){
                
                [self logout];
                
            }
    
                
        
            
            

            
        };
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 10){
        
        [self logout];
        
    }
    
    
}


-(void)logout{
    [PFUser logOut];
    
    IntroParentViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroParentViewController"];
    
    [self presentViewController:signupVC animated:YES completion:^{
        nil;
    }];
}



-(void)setupSegues{
    
    UIStoryboard *feedSB = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    //activityVC = [feedSB instantiateViewControllerWithIdentifier:@"recentActivityVC"];
    activityVC = [feedSB instantiateInitialViewController];
    
    feedSegue = [[SWRevealViewControllerSegue alloc] initWithIdentifier:@"segueToRecentActivity" source:self destination:activityVC];
    
    
    
}







@end
