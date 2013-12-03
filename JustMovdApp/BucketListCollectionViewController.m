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
#import "BucketDetailViewController.h"


@interface BucketListCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *bucketList;
@property (strong, nonatomic) PFGeoPoint *userLocation;

@end

@implementation BucketListCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userLocation                   = [[PFUser currentUser] objectForKey:@"geoPoint"];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self queryForBucketList];
}


- (void)queryForBucketList
{
    [ParseServices queryForBucketListNear:self.userLocation
                          completionBlock:^(NSArray *results, BOOL success) {
                              NSLog(@"%d", success);
                              if (success == NO)
                                  [self displayAlertForNoBucketList];
                              else{
                                  
                                  self.bucketList = [NSMutableArray arrayWithArray:results];
                                  [self.collectionView reloadData];
                              }
                            }];
}

#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
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
    PFGeoPoint *bucketLocation;
    PFUser     *creator;
    double     milesApart;
    
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell"
                                         forIndexPath:indexPath];
    [cell resetContents];
    
    // Get the bucket for the indexPath.row
    bucket  = self.bucketList[indexPath.row];
    creator = bucket[@"creator"];
    
    // Get the distance in miles between the user's location and the bucket's location
    bucketLocation = bucket[@"location"];
    milesApart     = (double)[self.userLocation distanceInMilesTo:bucketLocation];
    
    // Set the cell's text labels
    cell.titleLabel.text     = bucket[@"title"];
    cell.distanceLabel.text  = [NSString stringWithFormat:@"%.1f mi", milesApart];
    //cell.bucketNumLabel.text = [NSString stringWithFormat:@"%@ bucket lists", bucket[@"bucketListCount"]];
    cell.timeLabel.text      = @"2 hrs";
    
    // Set the cell's image in background
    [cell.mainImage setFile:bucket[@"image"] forImageView:cell.mainImage];
    [cell.creatorAvatar setFile:creator[@"profilePictureFile"] forAvatarImageView:cell.creatorAvatar];
    
    return cell;
}


#pragma mark - CollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueToBucketDetailViewController" sender:indexPath];
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - CollectionView FlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 162);
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
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


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToBucketDetailViewController"])
    {
        PFObject                   *selectedBucket;
        NSIndexPath                *ip;
        BucketDetailViewController *dvc;
        
        ip             = (NSIndexPath *)sender;
        selectedBucket = self.bucketList[ip.row];
        dvc            = segue.destinationViewController;
        dvc.bucket     = selectedBucket;
    }
}

@end
