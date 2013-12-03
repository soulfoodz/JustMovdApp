//
//  BucketDetailViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailViewController.h"
#import "BucketDetailCell.h"
#import "FoursquareServices.h"
#import "PFImageView+ImageHandler.h"

@interface BucketDetailViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BucketDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.bucket[@"title"];
    
    [self getVenueImages];
}
     

- (void)getVenueImages
{
    FoursquareServices *service;
    NSString *venueID;
    
    service = [[FoursquareServices alloc] init];
    venueID = self.bucket[@"FSVenueID"];
    
    [service getImagesForVenue:venueID
                      withSize:@"width320"
               completionBlock:^(BOOL success, NSArray *results) {
                   
                   if (success == YES)
                   {
                       self.photosArray = [NSMutableArray new];
                       for (id data in results)
                       {
                           UIImage *image = [UIImage imageWithData:data];
                           [self.photosArray addObject:image];
                           [self.collectionView reloadData];
                       }
                       
                      [self saveImageFileForVenue];
                   }
                   else NSLog(@"Uh-Oh! Error getting photos!");
               }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BucketDetailCell *cell;
    PFUser           *creator;
    NSString         *creatorName;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    [cell resetContents];
    
    // Get the creator of the bucket
    creator     = self.bucket[@"creator"];
    creatorName = creator[@"firstName"];
    
    // Configure the cell's subviews
    cell.titleLabel.text    = self.bucket[@"title"];
    cell.subtitleLabel.text = @"Nothing yet";
    cell.creatorLabel.text  = [NSString stringWithFormat:@"%@ says:", creatorName];
    cell.quoteLabel.text    = self.bucket[@"creatorQuote"];
    cell.mainImage.image    = self.photosArray[0];
    [cell.creatorAvatar setFile:creator[@"profilePictureFile"] forAvatarImageView:cell.creatorAvatar];
    
    return cell;
}

- (void)saveImageFileForVenue
{
    UIImage *image       = self.photosArray[0];
    NSData *data         = UIImagePNGRepresentation(image);
    NSString *fileName   = [NSString stringWithFormat:@"%@.png", self.bucket[@"title"]];
    NSMutableString *fileString = (NSMutableString *)[fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fileString   = (NSMutableString *)[fileString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    PFFile *file         = [PFFile fileWithName:fileString data:data];
    
    [self.bucket setObject:file forKey:@"image"];
    [self.bucket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"SAVED THE IMAGE!");
        } else NSLog(@"FAIL");
    }];
}




@end
