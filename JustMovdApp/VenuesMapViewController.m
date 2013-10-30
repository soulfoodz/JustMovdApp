//
//  CheckInViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "VenuesMapViewController.h"


@interface VenuesMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *nearbyVenues;
@end

@implementation VenuesMapViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Nearby";
    self.tableView.tableHeaderView = self.mapView;
    //self.tableView.tableFooterView = self.footer;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

}


@end
