//
//  BucketDetailMapViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/14/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FoursquareVenue.h"

@interface BucketDetailMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FoursquareVenue *venue;

@end
