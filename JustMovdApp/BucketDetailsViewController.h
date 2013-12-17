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

@protocol BucketCompletionUpdateDelegate <NSObject>

- (void)addCheckForBucket:(PFObject *)bucket atIndexPath:(NSIndexPath *)indexPath;
- (void)removeCheckForBucket:(PFObject *)bucket atIndexPath:(NSIndexPath *)indexPath;

@end

@interface BucketDetailsViewController : UIViewController

@property (weak, nonatomic) id <BucketCompletionUpdateDelegate> delegate;
@property (strong, nonatomic) FoursquareVenue *venue;
@property (strong, nonatomic) PFObject        *bucket;
@property (strong, nonatomic) UIImage         *initialImage;
@property (strong, nonatomic) NSIndexPath     *ip;
@property (nonatomic) BOOL isChecked;


- (IBAction)checkButtonTapped:(id)sender;
- (CGFloat)sizeForString:(NSString *)string withFont:(UIFont *)font;

@end
