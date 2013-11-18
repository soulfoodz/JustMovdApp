//
//  BucketListViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/12/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketListViewController.h"
#import <Parse/Parse.h>
#import "BucketListCell.h"
#import "PFImageView+ImageHandler.h"
#import "BucketDetailViewController.h"

@interface BucketListViewController ()

@property (strong, nonatomic) NSArray *bucketList;
@property (strong, nonatomic) PFGeoPoint *userLocation;


@end

@implementation BucketListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.userLocation = [[PFUser currentUser] objectForKey:@"location"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self queryForTable];
}


#pragma mark - Parse BucketListQuery

- (void)queryForTable
{
    PFQuery *queryForBucketList;
    
    queryForBucketList = [PFQuery queryWithClassName:@"BucketList"];
    [queryForBucketList whereKey:@"location" nearGeoPoint:self.userLocation withinMiles:50.0];
    [queryForBucketList findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Check for error
        // If no error, make sure the query doesn't return an empty array.
        if (!error) {
            if (objects.count != 0){
                self.bucketList = [NSArray arrayWithArray:objects];
                [self.tableView reloadData];
            }else
                // If the user isn't within 50 miles of a bucket list item, let the user know
                [self displayAlertForNoBucketList];
        }
        else{
            NSLog(@"***ERROR: %@  :error retreiving bucketList for location lat:%f long:%f", error, self.userLocation.latitude, self.userLocation.longitude);
        }
    }];
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If our bucketList doesn't have any objects, set the row count to 0
    if (self.bucketList.count == 0)
        return 0;
    else
        return self.bucketList.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - TableView Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BucketListCell  *cell;
    PFObject        *bucket;
    PFGeoPoint      *bucketLocation;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell resetContents];
    
    if (!cell){
        cell = [[BucketListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell styleCell];
    }
    
    // Get the bucket for the indexPath.row
    bucket = self.bucketList[indexPath.row];
    
    // Get the distance in miles between the user's location and the bucket's location
    bucketLocation = bucket[@"location"];
    double milesApart = [self.userLocation distanceInMilesTo:bucketLocation];
    
    // Set the cell's text labels
    cell.titleLabel.text     = bucket[@"title"];
    cell.distanceLabel.text  = [NSString stringWithFormat:@"%f mi away", milesApart];
    cell.bucketNumLabel.text = [NSString stringWithFormat:@"%@ bucket lists", bucket[@"bucketListCount"]];
    cell.timeLabel.text      = @"2 hours";
    
    // Set the cell's image in background
    [cell.mainImage setFile:bucket[@"image"] forImageView:cell.mainImage];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToBucketDetailViewController" sender:indexPath];
}


#pragma mark - Alert View Delegate

- (void)displayAlertForNoBucketList
{
    UIAlertView *alertView;
    
    alertView = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"Sorry, we couldn't find any bucket lists near you."
                                          delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    
    [alertView show];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToBucketDetailViewController"])
    {
        PFObject *selectedBucket;
        BucketDetailViewController *dvc;
        NSIndexPath *ip;
        
        ip             = (NSIndexPath *)sender;
        selectedBucket = self.bucketList[ip.row];
        dvc            = segue.destinationViewController;
        dvc.bucket     = selectedBucket;
    }
}








@end
