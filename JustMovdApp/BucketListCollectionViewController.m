//
//  BucketListCollectionViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketListCollectionViewController.h"
#import <Parse/Parse.h>
#import "ParseServices.h"
#import "BucketCell.h"
#import "PFImageView+ImageHandler.h"
#import "BucketDetailsViewController.h"
#import "FoursquareVenue.h"
#import "FoursquareServices.h"



@interface BucketListCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *bucketList;
@property (strong, nonatomic) NSMutableArray *completedBuckets;
@property (strong, nonatomic) PFGeoPoint     *userLocation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BucketListCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userLocation                   = [[PFUser currentUser] objectForKey:@"geoPoint"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];

    [self queryForBucketList];
    [self queryForCompletedBuckets];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.revealViewController.delegate = self;
}


- (void)queryForBucketList
{
    [ParseServices queryForBucketListNear:self.userLocation
                          completionBlock:^(NSArray *results, BOOL success)
                                           {
                              
                                           if (success == NO)
                                              [self displayAlertForNoBucketList];
                                           else
                                           {
                                              self.bucketList = [NSMutableArray arrayWithArray:results];
                                              [self.collectionView reloadData];
                                           }
                                           }];
}


- (void)queryForCompletedBuckets
{
    [ParseServices queryForBucketsCompletedByUser:[PFUser currentUser]
                                  completionBlock:^(NSArray *results, BOOL success)
                                                   {
                                                        if (success) self.completedBuckets = results.mutableCopy;
                                                   }];
}


#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.bucketList)
        return self.bucketList.count;
    else
        return 0;
}


//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    FCFlickrCollectionHeaderView *header;
//    
//    header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                withReuseIdentifier:@"flickerHeader"
//                                                       forIndexPath:indexPath];
//    
//    return header;
//}


-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BucketCell *cell;
    PFObject   *bucket;
    PFUser     *creator;
    double     milesApart;
    
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell"
                                         forIndexPath:indexPath];
    [cell resetContents];
    
    bucket         = self.bucketList[indexPath.row];
    creator        = bucket[@"creator"];
    cell.isChecked = [self checkForCompletionOfBucket:bucket];
    milesApart     = [self usersDistanceToBucketLocation:bucket[@"location"]];
    
    cell.titleLabel.text     = bucket[@"title"];
    cell.categoryLabel.text  = bucket[@"category"];
    cell.distanceLabel.text  = [NSString stringWithFormat:@"%.1f mi", milesApart];
    cell.creatorLabel.text   = @"Created by:";
    
    [cell.mainImage setFile:bucket[@"image"] forImageView:cell.mainImage];
    [cell.creatorAvatar setFile:creator[@"profilePictureFile"] forAvatarImageView:cell.creatorAvatar];
    
    return cell;
}


#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BucketCell                  *cell;
    PFObject                    *selectedBucket;
    BucketDetailsViewController *dvc;
    FoursquareVenue             *newVenue;
    __weak NSMutableArray       *array;
    __weak UICollectionView     *cv;
    
    cv               = self.collectionView;
    array            = self.completedBuckets;
    cell             = (BucketCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    dvc              = [[BucketDetailsViewController alloc] initWithNibName:nil bundle:nil];
    selectedBucket   = self.bucketList[indexPath.row];
    newVenue         = [FoursquareVenue newVenueFromBucket:selectedBucket];

    dvc.venue        = newVenue;
    dvc.bucket       = selectedBucket;
    dvc.initialImage = cell.mainImage.image;
    dvc.isChecked    = cell.isChecked;
    dvc.updateBlock  = ^(PFObject *bucket, NSString *command)   // updates this collectionview based on whether the detail view
                                                                // is checked or unchecked when popped
                        {
                            if ([command isEqualToString:@"add"])
                                [array addObject:bucket];
                            
                            if([command isEqualToString:@"remove"])
                                [array removeObject:bucket];
                            
                           [cv reloadItemsAtIndexPaths:@[indexPath]];
                        };
    
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - CollectionView FlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 162);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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


- (BOOL)checkForCompletionOfBucket:(PFObject *)bucket
{
    for (PFObject *object in self.completedBuckets)
    {
        if ([object[@"title"] isEqualToString:bucket[@"title"]]) return YES;
    }
    
    return NO;
}


- (double)usersDistanceToBucketLocation:(PFGeoPoint *)location
{
    return (double)[self.userLocation distanceInMilesTo:location];
}

#pragma mark - SWRevealVCDelegate Methods

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if (position == FrontViewPositionLeft)
    {
        self.collectionView.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    if (position == FrontViewPositionRight)
        self.collectionView.userInteractionEnabled = NO;
}



@end
