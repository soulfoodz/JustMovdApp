//
//  StatusUpdateViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "StatusUpdateViewController.h"
#import "ActivityFeedViewController.h"
#import "PFImageView+ImageHandler.h"
#import "NavViewController.h"
#import "JMCache.h"

#define CONTENT_FONT [UIFont fontWithName:@"Roboto-Regular" size:15.0]

@interface StatusUpdateViewController ()

@end

@implementation StatusUpdateViewController

@synthesize avatarImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    self.textView.font = CONTENT_FONT;
    self.textView.textColor = [UIColor darkGrayColor];
    
    // Check to see if view should go straight to "CheckInVC"
    if (self.presentingCheckIn == YES)
        self.view.alpha = 0;
    else if (!avatarImageView)
        [self setAvatarThumbnail];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.presentingCheckIn == YES)
       [self performSegueWithIdentifier:@"SegueToCheckIn" sender:self];
    else
        [self.textView becomeFirstResponder];
}


- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.postButton.enabled = YES;
}


- (IBAction)postPressed:(id)sender
{
    if (self.textView.text.length == 0){
        [self displayNoTextAlert];
        return;
    }

    //Create a new post object
    PFObject *newPost = [PFObject objectWithClassName:@"Activity"];

    [newPost setObject:self.textView.text forKey:@"textContent"];
    [newPost setObject:[PFUser currentUser] forKey:@"user"];
    [newPost setObject:@"JMPost" forKey:@"type"];
    [newPost setObject:[NSNumber numberWithInt:0] forKey:@"postCommentCounter"];
    [newPost setObject:[NSNumber numberWithInt:0] forKey:@"flagCount"];
    
    
    // If there is a CheckIn, create it and set it into the newPost object
    if (self.selectedPlace)
    {
        PFObject *newCheckIn  = [PFObject objectWithClassName:@"CheckIn"];
        
        // Format the location
        double latitude       = self.selectedPlace.location.latitude;
        double longitude      = self.selectedPlace.location.longitude;
        PFGeoPoint *geoPoint  = [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
        
        // Format the mapImage
        UIImage *checkInImage = [self getMapImageWithAnnotation];
        NSData *imageData     = UIImagePNGRepresentation(checkInImage);
        NSString *fileName    = [NSString stringWithFormat:@"image.png"];
        PFFile *imageFile     = [PFFile fileWithName:fileName data:imageData];
        
        // Set the CheckIn
        [newCheckIn setObject:self.selectedPlace.name forKey:@"placeName"];
        [newCheckIn setObject:self.selectedPlace.id forKey:@"placeId"];
        [newCheckIn setObject:self.selectedPlace.logoURLString forKey:@"logoURL"];
        [newCheckIn setObject:geoPoint forKey:@"location"];
        [newCheckIn setObject:imageFile forKey:@"mapImage"];
        
        // Set the post pointer to the new check in
        [newPost setObject:newCheckIn forKey:@"checkIn"];
    }
    
    // Add post to JMCache
    [[JMCache sharedCache] addNewPost:newPost];
    
    // Send newPost to activityFeed
    [self.delegate addNewlyCreatedPostToActivityFeed:newPost];
    [self dismissViewControllerAnimated:YES completion:nil];

    // Save the post
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            [self.delegate removePost:newPost fromActivityFeedWithError:error];
            [[JMCache sharedCache]removePost:newPost];
            NSLog(@"New post was NOT saved! : %@", newPost);
        } else {
            
            // Call the block that will reload the tableView to display the new checkIn
            self.reloadTVBlock();
            NSLog(@"New post was saved! : %@", newPost);
        }
    }];
}


#pragma mark - AlertView 

- (void)displayNoTextAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where's the post?"
                                                    message:@"You didn't mean to post nothing did you?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    
    [alert show];
}


- (IBAction)unwindSegueFromCheckInLocation:(UIStoryboardSegue *)unwindSegue
{
    // Reset Presenting check in BOOL and make the view visible
    self.presentingCheckIn = NO;
    self.view.alpha = 1.0;
    self.postButton.enabled = NO;

    [self displayMapAnnotation];
    [self setAvatarThumbnail];
}


- (void)displayMapAnnotation
{
    UIImage     *annotation;
    CGPoint     mapCenter;
    UIImageView *annoImageView;
    UILabel     *placeName;
    UIImageView *logo;
    NSString    *urlString;
    NSURL       *imageURL;
    NSData      *imageData;
    NSString    *nameString;
    
    // faux annotation setup
    annotation = [UIImage imageNamed:@"activityfeed_checkin_annotation_resizable.png"];
    mapCenter = CGPointMake(self.mapImage.bounds.size.width / 2, self.mapImage.bounds.size.height / 2);
    
    annoImageView        = [UIImageView new];
    annoImageView.frame  = CGRectMake(20, 10, 260, 76);
    annoImageView.center = CGPointMake(mapCenter.x ,mapCenter.y);
    annoImageView.image  = annotation;
    
    // Setup the Logo image and add it to the faux annotation bkgd
    logo               = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 54, 54)];
    urlString          = self.selectedPlace.logoURLString;
    imageURL           = [NSURL URLWithString:urlString];
    imageData          = [NSData dataWithContentsOfURL:imageURL];
    logo.image         = [UIImage imageWithData:imageData];
    logo.contentMode   = UIViewContentModeScaleAspectFill;
    logo.clipsToBounds = YES;
    [annoImageView addSubview:logo];
    
    // Setup the place name label
    placeName               = [UILabel new];
    placeName.numberOfLines = 0;
    placeName.lineBreakMode = NSLineBreakByWordWrapping;
    placeName.clipsToBounds = NO;

    nameString = self.selectedPlace.name;
    CGSize nameSize = [self sizeForString:nameString];
    placeName.frame = CGRectMake(64, 6, nameSize.width, nameSize.height);
    placeName.text  = nameString;
    placeName.font  = [UIFont fontWithName:@"Roboto-Medium" size:15.0];
    [annoImageView addSubview:placeName];

    [self.mapImage addSubview:annoImageView];
    [self.mapImage bringSubviewToFront:annoImageView];
}


- (UIImage *)getMapImageWithAnnotation
{
    CGSize imageSize = CGSizeMake(self.mapImage.image.size.width, self.mapImage.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
    [self.mapImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mapWithAnnotation = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return mapWithAnnotation;
}


- (CGSize)sizeForString:(NSString *)string
{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(180.0f, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0]}
                                           context:nil];
    return textRect.size;
}


- (void)setAvatarThumbnail
{
    PFFile *imageFile;

    avatarImageView       = [PFImageView new];
    avatarImageView.frame = CGRectMake(10, 70, 44, 44);
    avatarImageView.layer.cornerRadius = 22.0f;
    avatarImageView.clipsToBounds      = YES;
    
    imageFile = self.user[@"profilePictureFile"];
    [avatarImageView setFile:imageFile forImageView:avatarImageView];
    [self.view addSubview:avatarImageView];
}




@end
