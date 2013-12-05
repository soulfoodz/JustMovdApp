//
//  BucketDetailViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailViewController.h"
#import "FoursquareServices.h"
#import "PFImageView+ImageHandler.h"
#import "FoursquareVenue.h"

@interface BucketDetailViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSString                *venueID;
@property (strong, nonatomic) FoursquareServices      *fsService;
@property (nonatomic) BOOL                            wasChecked;

@end

static NSString *addCheckString    = @"add";
static NSString *removeCheckString = @"remove";


@implementation BucketDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set our original state holder for whether or not the user has done the bucket
    self.wasChecked = self.isChecked;
    
    self.venueID   = self.bucket[@"FSVenueID"];
    self.fsService = [[FoursquareServices alloc] init];

    self.navigationItem.title = @"#ATX";
    
    [self getVenueImages];
}


- (void)getVenueImages
{
    [self.fsService getImagesForVenue:self.venueID
                             withSize:@"width320"
                      completionBlock:^(BOOL success, NSArray *results) {
                   
                   if (success == YES)
                   {
                       self.photosArray = [NSMutableArray new];
                       for (id data in results)
                       {
                           UIImage *image;
                           
                           image = [UIImage imageWithData:data];
                           [self.photosArray addObject:image];
                           [self.collectionView reloadData];
                       }
                      
                       if ([self checkIfbucketNeedsToBeUpdated] == YES)
                           [self getVenueInfo];
                   }
                   else NSLog(@"Uh-Oh! Error getting photos!");
               }];
}


- (BOOL)checkIfbucketNeedsToBeUpdated
{
    NSDate *today;
    double timeSinceUpdate;
    long   oneWeek;
    
    today           = [NSDate date];
    timeSinceUpdate = [today timeIntervalSinceDate:self.bucket[@"updatedAt"]];
    oneWeek         = 7*24*60*60;
    
    if (timeSinceUpdate < oneWeek)
        return YES;
    else
        return NO;
}


- (void)getVenueInfo
{
    [self.fsService getInfoForVenueWithID:self.venueID
                          completionBlock:^(BOOL success, NSArray *results) {
        
                              FoursquareVenue *venue;
                              PFGeoPoint      *geoPoint;
                              PFFile          *imageFile;
                              
                              venue     = [results lastObject];
                              geoPoint  = [PFGeoPoint geoPointWithLatitude:venue.lat longitude:venue.lng];
                              imageFile = [self imageFileForVenue];
                              
                              if (geoPoint)
                                  [self.bucket setObject:geoPoint         forKey:@"location"];
                              if (venue.address)
                                  [self.bucket setObject:venue.address    forKey:@"streetAddress"];
                              if (venue.city)
                                  [self.bucket setObject:venue.city       forKey:@"city"];
                              if (venue.postalCode)
                                  [self.bucket setObject:venue.postalCode forKey:@"postalCode"];
                              if (venue.phone)
                                  [self.bucket setObject:venue.phone      forKey:@"phone"];
                              if (venue.url)
                                  [self.bucket setObject:venue.url        forKey:@"website"];
                              if (venue.category)
                                  [self.bucket setObject:venue.category   forKey:@"category"];
//                              if (imageFile)
//                                  [self.bucket setObject:imageFile forKey:@"image"];
                              
                              [self.bucket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  if (succeeded) {
                                      NSLog(@"SAVED THE Bucket!");
                                  } else NSLog(@"FAIL");
                              }];
                          }];
}


- (PFFile *)imageFileForVenue
{
    UIImage         *image;
    NSData          *data;
    NSString        *fileName;
    NSMutableString *fileString;
    PFFile          *imageFile;
    
    image      = self.photosArray[0];
    data       = UIImagePNGRepresentation(image);
    fileName   = [NSString stringWithFormat:@"%@.png", self.bucket[@"title"]];
    fileString = (NSMutableString *)[fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fileString = (NSMutableString *)[fileString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    imageFile  = [PFFile fileWithName:fileString data:data];
    
    return imageFile;
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
    cell.delegate = self;
    [cell resetContents];
    
    // Get the creator of the bucket
    creator     = self.bucket[@"creator"];
    creatorName = creator[@"firstName"];
    
    // Set the checkButton's state
    if (self.isChecked == YES)
        [cell setCheckButtonImageFor:@"checked"];
    else
        [cell setCheckButtonImageFor:@"unchecked"];
    
    // Configure the cell's subviews
    cell.titleLabel.text    = self.bucket[@"title"];
    cell.subtitleLabel.text = self.bucket[@"category"];
    cell.quoteLabel.text    = self.bucket[@"creatorQuote"];
    cell.mainImage.image    = self.initialImage;  //self.photosArray[0];
    cell.creatorLabel.text  = [NSString stringWithFormat:@"%@ says:", creatorName];
    [cell.creatorAvatar setFile:creator[@"profilePictureFile"] forAvatarImageView:cell.creatorAvatar];
    
    return cell;
}


- (void)checkButtonWasTappedInCell:(BucketDetailCell *)cell
{
    if (self.isChecked == YES)
    {
        self.isChecked = NO;
        [cell setCheckButtonImageFor:@"unchecked"];
    }
    else
    {
        self.isChecked = YES;
        [cell setCheckButtonImageFor:@"checked"];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Check to see if the state of the checkButton has changed while on the page
    // If it has, save the final state (isChecked) to the users array of checked buckets
    
    if (self.isChecked == self.wasChecked) return;
    
    if (self.isChecked == NO && self.wasChecked == YES)
    {
        [[PFUser currentUser] removeObject:self.bucket forKey:@"buckets"];
        self.updateBlock(self.bucket, removeCheckString);
    }
    else if (self.isChecked == YES && self.wasChecked == NO)
    {
        [[PFUser currentUser] addUniqueObject:self.bucket forKey:@"buckets"];
        self.updateBlock(self.bucket, addCheckString);
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES)
            NSLog(@"Saved changes");
        else
            NSLog(@"Failed to save changes");
    }];
}



@end
