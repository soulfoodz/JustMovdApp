//
//  CheckInLocation.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/14/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CheckInLocation : NSObject <MKAnnotation>

// MKAnnotation protocol
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logoURLString;
@property (nonatomic) CLLocationCoordinate2D location;


@end
