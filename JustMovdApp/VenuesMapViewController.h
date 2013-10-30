//
//  CheckInViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VenuesMapViewController : UITableViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>


@end
