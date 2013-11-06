//
//  UsersWithinRadiusViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/1/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "UsersWithinRadiusViewController.h"
#import "UserProfileViewController.h"

@interface UsersWithinRadiusViewController ()

@end

@implementation UsersWithinRadiusViewController
@synthesize userListArray;
@synthesize UserListTableView;

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
    userListArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self findUsersWithinMiles:200.0];
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
        //Returned result automatically sorted by distance by Parse
        userListArray = objects.mutableCopy;
        [UserListTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return userListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PFGeoPoint *userGeoPoint = [[userListArray objectAtIndex:indexPath.row] objectForKey:@"geoPoint"];
    double distance = [userGeoPoint distanceInMilesTo:[[PFUser currentUser] objectForKey:@"geoPoint"]];
    
    cell.textLabel.text = [[userListArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", distance];
    
    // Configure the cell...
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [UserListTableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"segueUserListToUserProfile"]) {
        UserProfileViewController *userProfileVC = segue.destinationViewController;
        userProfileVC.facebookUsername = [[userListArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueUserListToUserProfile" sender:self];
}



@end
