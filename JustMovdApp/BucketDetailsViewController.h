//
//  BucketDetailsViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/11/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FoursquareVenue.h"

typedef void (^updateCompletedBucketsBlock)(PFObject *bucket, NSString *command);

@interface BucketDetailsViewController : UIViewController

@property (nonatomic) BOOL isChecked;
@property (strong, nonatomic) FoursquareVenue *venue;
@property (strong, nonatomic) PFObject        *bucket;
@property (strong, nonatomic) UIImage         *initialImage;
@property (strong, nonatomic) updateCompletedBucketsBlock updateBlock;

- (IBAction)checkButtonTapped:(id)sender;
- (CGFloat)sizeForString:(NSString *)string withFont:(UIFont *)font;

@end
