//
//  FoursquareVenue.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareVenue : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) UIImage  *fullImage;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) double lat;
@property (nonatomic) double lng;


+ (FoursquareVenue *)newVenueFromBucket:(PFObject *)bucket;

@end
