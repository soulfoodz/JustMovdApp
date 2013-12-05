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
@property (strong, nonatomic) NSMutableArray *completedBuckets;
@property (strong, nonatomic) PFGeoPoint     *userLocation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation BucketListCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self queryForBucketList];
    [self queryForCompletedBuckets];
    
    self.userLocation                   = [[PFUser currentUser] objectForKey:@"geoPoint"];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
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
    [self performSegueWithIdentifier:@"SegueToBucketDetailViewController" sender:indexPath];
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


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToBucketDetailViewController"])
    {
        BucketCell                 *cell;
        PFObject                   *selectedBucket;
        NSIndexPath                *ip;
        BucketDetailViewController *dvc;
    
        ip               = (NSIndexPath *)sender;
        cell             = (BucketCell *)[self.collectionView cellForItemAtIndexPath:ip];
        selectedBucket   = self.bucketList[ip.row];
        dvc              = segue.destinationViewController;
        dvc.bucket       = selectedBucket;
        dvc.updateBlock  = ^(PFObject *bucket, NSString *command)   // updates this collectionview based on whether the detail view
                                                                    // is checked or unchecked when popped
                           {
                                if ([command isEqualToString:@"add"])
                                    [self.completedBuckets addObject:bucket];
                               
                                if([command isEqualToString:@"remove"])
                                    [self.completedBuckets removeObject:bucket];
                               
                                [self.collectionView reloadItemsAtIndexPaths:@[(NSIndexPath *)sender]];
                           };
        
        dvc.initialImage = cell.mainImage.image;
        dvc.isChecked    = cell.isChecked;
    }
}


- (BOOL)checkForCompletionOfBucket:(PFObject *)bucket
{
    for (PFObject *buck in self.completedBuckets)
    {
        if ([buck[@"title"] isEqualToString:bucket[@"title"]]) return YES;
    }
    
    return NO;
}


- (double)usersDistanceToBucketLocation:(PFGeoPoint *)location
{
    return (double)[self.userLocation distanceInMilesTo:location];
}

- (IBAction)toggleMenuVC:(id)sender {
}
@end
