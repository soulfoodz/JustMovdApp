//
//  BucketDetailMapViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/14/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailMapViewController.h"

@interface BucketDetailMapViewController ()

@end

@implementation BucketDetailMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMap];
    
    [self.mapView showAnnotations:@[self.venue] animated:YES];    
}

#pragma mark - MapView Methods

- (void)setupMap
{
    MKCoordinateRegion region;
    MKCoordinateSpan   span;
    
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    region.span = span;
    region.center = self.venue.coordinate;
    
    [self.mapView setRegion:region animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView;
    NSString *reuseID = @"abc";
    
    annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:reuseID];
        annotationView.enabled        = YES;
        annotationView.canShowCallout = YES;
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    annotationView.image        = [UIImage imageNamed:@"bucketdetailmapvc_annotationview_mappin.png"];
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height / 2));
    
    return annotationView;
}


@end
