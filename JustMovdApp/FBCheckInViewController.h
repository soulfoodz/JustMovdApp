//
//  FBCheckInViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/1/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>


@interface FBCheckInViewController : FBPlacePickerViewController <FBPlacePickerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) PFFile *mapImageFile;
@property (strong, nonatomic) UIImage *mapViewImage;

@end
