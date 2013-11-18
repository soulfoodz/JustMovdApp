//
//  CheckInDetailViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "CheckInDetailViewController.h"
#import "CheckInLocation.h"

#define placeNameFont [UIFont fontWithName:@"Roboto-Medium" size:13.0]

@interface CheckInDetailViewController ()

@property (strong, nonatomic) CheckInLocation *checkInLocation;

@end

@implementation CheckInDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.zoomEnabled           = YES;
    self.mapView.showsPointsOfInterest = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    PFGeoPoint *location;
    CLLocationCoordinate2D centerCoord;
    
    self.checkInLocation = [CheckInLocation new];
    
    location             = self.checkIn[@"location"];
    centerCoord          = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    self.checkInLocation.coordinate = centerCoord;
    
    span.latitudeDelta  = 0.01;
    span.longitudeDelta = 0.01;
    region.span         = span;
    region.center       = self.checkInLocation.coordinate;
    
    [self.mapView addAnnotation:self.checkInLocation];
    [self.mapView setRegion:region animated:NO];
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
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    UIImageView *annoImageView = [self createAnnotationViewImage];
    annoImageView.center = annotationView.center;
    [annotationView addSubview:annoImageView];
    annotationView.centerOffset = CGPointMake(0, -(annoImageView.frame.size.height / 2));
    
    return annotationView;
}


- (UIImage *)getLogoForAnnotationView
{
    NSURL *logoURL;
    NSData *imageData;
    UIImage *logo;
    
    logoURL   = [NSURL URLWithString:self.checkIn[@"logoURL"]];
    imageData = [NSData dataWithContentsOfURL:logoURL];
    logo      = [UIImage imageWithData:imageData scale:0.0f];
    
    return logo;
}


- (UIImageView *)createAnnotationViewImage
{
    UIImage     *annotation;
    UIImageView *annoImageView;
    UILabel     *placeName;
    UIImageView *logo;
    
    // faux annotation setup
    annotation = [UIImage imageNamed:@"activityfeed_checkin_annotation_resizable.png"];
    
    annoImageView        = [UIImageView new];
    annoImageView.frame  = CGRectMake(0, 0, 218, 64);
    annoImageView.image  = annotation;
    annoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // Setup the Logo image and add it to the faux annotation bkgd
    logo               = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 44, 44)];
    logo.image         = [self getLogoForAnnotationView];
    logo.contentMode   = UIViewContentModeScaleAspectFill;
    logo.clipsToBounds = YES;
    [annoImageView addSubview:logo];
    
    // Setup the place name label
    placeName               = [UILabel new];
    placeName.numberOfLines = 0;
    placeName.lineBreakMode = NSLineBreakByWordWrapping;
    placeName.clipsToBounds = NO;
    placeName.text          = self.checkIn[@"placeName"];
    
    CGSize nameSize = [self sizeForString:placeName.text];
    placeName.frame = CGRectMake(56, 4, nameSize.width, nameSize.height);
    placeName.font  = placeNameFont;
    [annoImageView addSubview:placeName];
    
    return annoImageView;
}


- (CGSize)sizeForString:(NSString *)string
{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(180.0f, 150.0f)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:placeNameFont}
                                           context:nil];
    return textRect.size;
}


- (IBAction)buttonToMapAppTapped:(id)sender
{
    UIActionSheet *actionSheet;
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Go to Maps", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self openMapsApp];
}


- (void)openMapsApp
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass)
    {
        MKPlacemark  *placemark;
        MKMapItem    *mapItem;
        NSDictionary *launchItems;
        
        placemark = [[MKPlacemark alloc] initWithCoordinate:self.checkInLocation.coordinate addressDictionary:nil];
        mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        launchItems = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        
        [MKMapItem openMapsWithItems:@[mapItem] launchOptions:launchItems];
    }
}






@end
