//
//  FBCheckInViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/1/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "FBCheckInViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StatusUpdateViewController.h"

@interface FBCheckInViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FBCheckInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Nearby";
    [self clearSelection];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 50;
    self.session = [FBSession activeSession];
    self.radiusInMeters = 500;
    self.resultsLimit = 20;
    self.searchText = nil;
    self.fieldsForRequest = [NSSet setWithObject:@"distance"];
    self.itemPicturesEnabled = YES;
    self.delegate = self;
    self.doneButton = nil;
    self.cancelButton = nil;
    
    [self.locationManager startUpdatingLocation];
}


- (void)setupMapForLocation:(CLLocation *)location
{
    CLLocationCoordinate2D coord;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    coord = location.coordinate;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = coord;
    
    [self.mapView setRegion:region animated:YES];
    [self drawImageFromMap:(MKCoordinateRegion)region];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    self.locationCoordinate = location.coordinate;
    
    [self setupMapForLocation:location];
    [self loadData];
}


- (void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker
{
    FBPlace *place;
    [self.locationManager stopUpdatingLocation];
    place = (FBPlace *)placePicker.selection;
    [self performSegueWithIdentifier:@"SegueFromCheckInLocationSelection"
                              sender:place];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueFromCheckInLocationSelection"]){
        StatusUpdateViewController *updateVC = segue.destinationViewController;
        updateVC.selectedPlace = sender;
        updateVC.nameString = sender[@"name"];
        updateVC.presentingCheckIn = NO;
        updateVC.mapImage.image = self.mapViewImage;
    }
    
    if ([segue.identifier isEqualToString:@"unwindFromCheckInVC"]) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)drawImageFromMap:(MKCoordinateRegion)region
{
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = region;
    options.scale = [UIScreen mainScreen].scale;
    
    CGFloat width  = self.mapView.frame.size.width * .9;
    CGFloat height = self.mapView.frame.size.height * .9;
    options.size = CGSizeMake(width, height);
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        UIImage *image = snapshot.image;
        self.mapViewImage = image;
        
        
        NSLog(@"Got the image");
//        NSData *data = UIImagePNGRepresentation(image);
//        PFFile *mapImageFile = [PFFile fileWithData:data];
//        self.mapImageFile = mapImageFile;
    }];
}





@end

