//
//  CheckInDetailViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CheckInLocation.h"

@interface CheckInDetailViewController : UIViewController  <MKMapViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PFObject *checkIn;

- (IBAction)buttonToMapAppTapped:(id)sender;

@end
