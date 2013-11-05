//
//  TestViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/30/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import "IntroParentViewController.h"
#import "SWRevealViewController.h"
#import "MatchTableViewCell.h"


@interface TestViewController ()
{
    NSMutableArray *matches;
    NSMutableArray *profilePics;
    BOOL isReady;
}

@end

@implementation TestViewController

@synthesize myTableView, sideBarButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isReady = NO;
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    matches = [[NSMutableArray alloc] init];
    profilePics = [[NSMutableArray alloc] init];
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self findUsersWithinMiles:20.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    //self.view.backgroundColor = [UIColor grayColor];
    
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;


}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]){
        
        IntroParentViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroParentViewController"];
        
        [self presentViewController:signupVC animated:NO completion:^{
            nil;
        }];
    }
    
}

- (void)findUsersWithinMiles:(double)miles
{
    PFGeoPoint *currentUserLocation = [[PFUser currentUser] objectForKey:@"geoPoint"];
    PFQuery *usersQuery = [PFUser query];
    [usersQuery whereKey:@"geoPoint" nearGeoPoint:currentUserLocation withinMiles:miles];
    //Result to not include own profile
    [usersQuery whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         matches = objects.mutableCopy;
         
         for (PFUser *temp in matches){
             PFFile *imageFile = [temp objectForKey:@"profilePictureFile"];
             [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                 
                 UIImage *tempImage = [UIImage imageWithData:data];
                 [profilePics addObject:tempImage];
                 
                 if ([profilePics count] == [matches count]){
                     isReady = YES;
                     [myTableView reloadData];
                 }
                 
                 //[myTableView reloadData];

                 
             }];
         }
         
     }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isReady){
        return [profilePics count];
    } else {
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MatchTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:@"blah"];
    
    if (!cell){
        cell = [[MatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blah"];
    }
 
    if (isReady){
        
        int row = [indexPath row];
        
       [cell.profilePicture setImage:[profilePics objectAtIndex:row]];
        
        PFUser *tempUser = [matches objectAtIndex:row];
        cell.nameLabel.text = tempUser[@"name"];
        cell.firstInterest.image = [UIImage imageNamed:@"yoga_circle"];
        cell.secondInterest.image = [UIImage imageNamed:@"yoga_circle"];
        cell.thirdInterest.image = [UIImage imageNamed:@"yoga_circle"];
        cell.fourthInterest.image = [UIImage imageNamed:@"yoga_circle"];
        
        return cell;
        
    }
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat val = 250.0;
    
    return val;
    
}


@end
