//
//  CheckInLocation.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/14/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CheckInLocation : NSObject <MKAnnotation, FBGraphPlace>

// MKAnnotation protocol
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

// FBGraphPlace protocol
@property (retain, nonatomic) NSString *category;
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) id<FBGraphLocation> location;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *logoURLString;


@end
