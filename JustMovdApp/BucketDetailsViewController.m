//
//  BucketDetailsViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/11/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailsViewController.h"
#import "FoursquareServices.h"
#import "ParseServices.h"
#import "FoursquareVenue.h"
#import "PFImageView+ImageHandler.h"

#define titleFont    [UIFont fontWithName:@"Roboto-Medium"  size:18.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Medium"  size:15.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

typedef enum {checked, unchecked} ButtonState;


@interface BucketDetailsViewController () <UIScrollViewDelegate, MKMapViewDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UIView        *infoView;
@property (weak, nonatomic) IBOutlet UIView        *mapViewContainer;
@property (weak, nonatomic) IBOutlet UILabel       *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel       *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel       *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel       *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel       *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel       *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton      *checkButton;
@property (weak, nonatomic) IBOutlet MKMapView     *mapView;
@property (weak, nonatomic) IBOutlet PFImageView   *creatorAvatar;
@property (weak, nonatomic) IBOutlet UIScrollView  *imagesScroller;
@property (weak, nonatomic) IBOutlet UIScrollView  *mainScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSArray            *imagesArray;
@property (strong, nonatomic) NSMutableArray     *imageViews;
@property (strong, nonatomic) NSString           *venueID;
@property (strong, nonatomic) FoursquareServices *fsService;
@property (nonatomic) BOOL                        wasChecked;

@end

static NSString *addCheckString    = @"add";
static NSString *removeCheckString = @"remove";


@implementation BucketDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"BucketDetailsViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"#ATX";
    self.fsService            = [[FoursquareServices alloc] init];
    
    [self.activityIndicator startAnimating];
    [self getVenueImages];
    [self setSubviewValues];
    [self styleSubviews];
    [self setupMapWithLocation:self.venue.coord];
}


- (void)setSubviewValues
{
    PFUser *creator = self.bucket[@"creator"];
    
    self.titleLabel.text    = self.venue.name;
    self.subtitleLabel.text = self.venue.category;
    self.streetLabel.text   = self.venue.address;
    self.cityLabel.text     = [NSString stringWithFormat:@"%@, %@", self.venue.city, self.venue.state];
    self.creatorLabel.text  = [NSString stringWithFormat:@"%@ says:", creator[@"firstName"]];
    self.quoteLabel.text    = self.bucket[@"creatorQuote"];
    self.wasChecked         = self.isChecked;

    if (self.isChecked == YES) [self setCheckButtonImageState:checked];
    else [self setCheckButtonImageState:unchecked];
    
    [self.creatorAvatar setFile:creator[@"profilePictureFile"] forAvatarImageView:self.creatorAvatar];
}


- (void)styleSubviews
{
    UITapGestureRecognizer *tapGesture;
    
    //self.mainView.clipsToBounds  = YES;
    
    self.titleLabel.font         = titleFont;
    self.titleLabel.textColor    = titleColor;
    
    self.subtitleLabel.font      = detailsFont;
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    
    self.creatorLabel.font       = subtitleFont;
    self.creatorLabel.textColor  = [UIColor darkGrayColor];
    
    self.quoteLabel.font          = detailsFont;
    self.quoteLabel.textColor     = [UIColor darkGrayColor];
    self.quoteLabel.numberOfLines = 0;
    self.quoteLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.creatorAvatar.contentMode        = UIViewContentModeScaleAspectFill;
    self.creatorAvatar.layer.cornerRadius = _creatorAvatar.frame.size.width/2;
    self.creatorAvatar.layer.borderWidth  = 2.0f;
    self.creatorAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.creatorAvatar.clipsToBounds      = YES;
    
    self.streetLabel.font       = subtitleFont;
    self.streetLabel.textColor  = [UIColor darkGrayColor];
    
    self.cityLabel.font      = subtitleFont;
    self.cityLabel.textColor = [UIColor darkGrayColor];
    
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMap)];

    self.mapViewContainer.layer.cornerRadius = 3.0f;
    self.mapViewContainer.clipsToBounds      = YES;
    self.mapViewContainer.backgroundColor    = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    self.mapViewContainer.userInteractionEnabled = YES;
    [self.mapViewContainer addGestureRecognizer:tapGesture];
    
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.center           = CGPointMake(160, 160);
    
    self.pageControl.center = CGPointMake(160, 300);
    
    [self adjustDependentFrames];
}

- (void)goToMap
{
    UIViewController *vc;
    MKMapView *bigMapView;
    
    vc   = [[UIViewController alloc] init];
    bigMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bigMapView setCenterCoordinate:self.venue.coord animated:YES];
    
    vc.view = bigMapView;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)adjustDependentFrames
{
    UIBezierPath *path;
    UIColor      *strokeColor;
    int margin;
    CGFloat quoteHeight, mapOriginY, totalHeight, contentHeight, navBarHeight;

    // Adjust the height of the quote frame
    quoteHeight = [self sizeForString:self.quoteLabel.text withFont:self.quoteLabel.font];
    self.quoteLabel.frame = CGRectMake(self.quoteLabel.frame.origin.x,
                                       self.quoteLabel.frame.origin.y,
                                       self.quoteLabel.frame.size.width, quoteHeight);
    
    // Offset the maps y origin based on where the quote frame stops
    if (self.quoteLabel.frame.size.height > 20)
        mapOriginY = self.quoteLabel.frame.origin.y + self.quoteLabel.frame.size.height;
    else
        mapOriginY = self.creatorAvatar.frame.origin.y + self.creatorAvatar.frame.size.height;
    
    margin = 30;

    self.mapViewContainer.frame = CGRectMake(self.mapViewContainer.frame.origin.x,
                                             mapOriginY + margin,
                                             self.mapViewContainer.frame.size.width,
                                             self.mapViewContainer.frame.size.height);
    
    
    // Set the height of the infoView so we can set the mainScroller's contentSize correctly
    totalHeight = self.mapViewContainer.frame.origin.y + self.mapViewContainer.frame.size.height + 20;
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                     self.infoView.frame.origin.y,
                                     320, totalHeight);
    
    navBarHeight  = 64;
    contentHeight = self.imagesScroller.frame.size.height + self.infoView.frame.size.height + navBarHeight;
    self.mainScroller.contentSize = CGSizeMake(320, contentHeight);
    
    path = [UIBezierPath bezierPathWithRoundedRect:self.mapViewContainer.frame cornerRadius:3.0f];
    path.lineWidth = 2.0f;
    strokeColor = [UIColor lightGrayColor];
    [strokeColor setStroke];
    [path stroke];
}


- (void)getVenueImages
{
    [self.fsService getImagesForVenue:self.venue.id
                             withSize:@"width640"
                      completionBlock:^(BOOL success, NSArray *results)
                                       {
                                           if (success == YES)
                                           {
                                               self.imagesArray  = results;
                                               [self setupImageScroller];
                                               NSLog(@"imagesArray = %@", self.imagesArray);
                                               
//                                               if ([self checkIfbucketNeedsToBeUpdated] == YES)
//                                                   [self getVenueInfo];
                                           }
                                           else NSLog(@"Uh-Oh! Error getting photos!");
                                       }];
}


- (void)createImageViewsWithImages
{
    for (UIImage *image in self.imagesArray)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        [self.imageViews addObject:imageV];
    }
}

#pragma mark - MapView Methods

- (void)setupMapWithLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    MKCoordinateSpan   span;
    
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = location;
    
    [self.mapView setRegion:region animated:YES];
}


- (BOOL)checkIfbucketNeedsToBeUpdated
{
    NSDate *today;
    double timeSinceUpdate;
    long   oneWeek;
    
    today           = [NSDate date];
    timeSinceUpdate = [today timeIntervalSinceDate:self.bucket[@"updatedAt"]];
    oneWeek         = 7*24*60*60;
    
    // If it's been more than a since the venues info was updated, update it.
    if (timeSinceUpdate > oneWeek)
        return YES;
    else
        return NO;
}


- (void)getVenueInfo
{
    [self.fsService getInfoForVenueWithID:self.venueID
                          completionBlock:^(BOOL success, NSArray *results) {
                              
                              FoursquareVenue *venue;
                              PFGeoPoint      *geoPoint;
                              PFFile          *imageFile;
                              
                              venue     = [results lastObject];
                              geoPoint  = [PFGeoPoint geoPointWithLatitude:venue.lat longitude:venue.lng];
                              imageFile = [self imageFileForVenue];
                              
                              if (geoPoint)
                                  [self.bucket setObject:geoPoint         forKey:@"location"];
                              if (venue.address)
                                  [self.bucket setObject:venue.address    forKey:@"streetAddress"];
                              if (venue.city)
                                  [self.bucket setObject:venue.city       forKey:@"city"];
                              if (venue.postalCode)
                                  [self.bucket setObject:venue.postalCode forKey:@"postalCode"];
                              if (venue.phone)
                                  [self.bucket setObject:venue.phone      forKey:@"phone"];
                              if (venue.url)
                                  [self.bucket setObject:venue.url        forKey:@"website"];
                              if (venue.category)
                                  [self.bucket setObject:venue.category   forKey:@"category"];
                              if (imageFile)
                                  [self.bucket setObject:imageFile        forKey:@"image"];
                              
                              [self.bucket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                  if (succeeded) {
                                      NSLog(@"SAVED THE Bucket!");
                                  } else NSLog(@"FAIL");
                              }];
                          }];
}


- (PFFile *)imageFileForVenue
{
    UIImage         *image;
    NSData          *data;
    NSString        *fileName;
    NSMutableString *fileString;
    PFFile          *imageFile;
    
    image      = self.imagesArray[0];
    data       = UIImagePNGRepresentation(image);
    fileName   = [NSString stringWithFormat:@"%@.png", self.bucket[@"title"]];
    fileString = (NSMutableString *)[fileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    fileString = (NSMutableString *)[fileString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    imageFile  = [PFFile fileWithName:fileString data:data];
    
    return imageFile;
}


#pragma mark - ScrollView delegate & methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.imagesScroller)[self loadVisibleImages];
}


- (void)setupImageScroller
{
    int images;
    
    images = self.imagesArray.count;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = images;
    
    self.imagesScroller.contentSize = CGSizeMake(320*images, 320);

    self.imageViews = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.imagesArray.count; ++i)
    {
        [self.imageViews addObject:[NSNull null]];
    }
    
    [self loadVisibleImages];
}


- (void)loadImage:(NSInteger)page
{
    CGRect frame;
    UIImageView *newImageView;
    
    if (page < 0 || page >= self.imagesArray.count)
    {
        return;
    }
    
    UIView *pageView = [self.imageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null])
    {
        frame = CGRectMake(0, 0, 320, 320);//self.imagesScroller.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        newImageView = [[UIImageView alloc] initWithImage:[self.imagesArray objectAtIndex:page]];
        newImageView.contentMode = UIViewContentModeScaleAspectFit;
        newImageView.frame = frame;
        [self.imagesScroller addSubview:newImageView];
        
        [self.imageViews replaceObjectAtIndex:page withObject:newImageView];
    }
    
    [self.activityIndicator stopAnimating];
}

- (void)loadVisibleImages
{
    CGFloat imageWidth;
    NSInteger image, firstImage, lastImage;
    
    //First, determine which page is currently visible
    imageWidth = self.imagesScroller.frame.size.width;
    image = (NSInteger)floor((self.imagesScroller.contentOffset.x * 2.0f + imageWidth) / (imageWidth * 2.0f));
    
    // Update the page control and activityIndicator
    self.pageControl.currentPage = image;
    
    // Work out which pages you want to load
    firstImage = image - 1;
    lastImage = image + 1;
    
    // Purge anything before the first page
    for (NSInteger i = 0; i < firstImage; i++)
    {
        [self purgeImage:i];
    }
    
    // Load pages in our range
    for (NSInteger i = firstImage; i <= lastImage; i++)
    {
        [self loadImage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i = lastImage+1; i < self.imagesArray.count; i++)
    {
        [self purgeImage:i];
    }
}


- (void)purgeImage:(NSInteger)page
{
    UIView *pageView;
    
    if (page < 0 || page >= self.imagesArray.count)
    {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    pageView = [self.imageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.imageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


- (CGFloat)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(210, 0)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil];
    
    int height = textRect.size.height + 1;
    
    return (float)height;
}

#pragma mark CheckButton Methods

- (void)setCheckButtonImageState:(ButtonState)state
{
    if (state == checked)
        [self.checkButton setImage:[UIImage imageNamed:@"bucketdetailviewcontroller_checkbutton_selected.png"]
                          forState:UIControlStateNormal];
    
    if (state == unchecked)
        [self.checkButton setImage:[UIImage imageNamed:@"bucketdetailviewcontroller_checkbutton_normal.png"]
                          forState:UIControlStateNormal];
}


- (IBAction)checkButtonTapped:(UIButton *)sender
{
    if (self.isChecked)
    {
        self.isChecked = NO;
        [self setCheckButtonImageState:unchecked];
    }
    else
    {
        self.isChecked = YES;
        [self setCheckButtonImageState:checked];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Check to see if the state of the checkButton has changed while on the page
    // If it has, save the final state (isChecked) to the users array of checked buckets
    
    if (self.isChecked == self.wasChecked) return;
    
    if (self.isChecked == NO && self.wasChecked == YES)
    {
        [[PFUser currentUser] removeObject:self.bucket forKey:@"buckets"];
        self.updateBlock(self.bucket, removeCheckString);
    }
    else if (self.isChecked == YES && self.wasChecked == NO)
    {
        [[PFUser currentUser] addUniqueObject:self.bucket forKey:@"buckets"];
        self.updateBlock(self.bucket, addCheckString);
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES)
            NSLog(@"Saved changes");
        else
            NSLog(@"Failed to save changes");
    }];
}


@end
