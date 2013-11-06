//
//  FBLoginViewController.m
//  MVNote
//
//  Created by Kyle Mai on 10/26/13.
//
//

#import "KyleLoginViewController.h"
#import "AppDelegate.h"

@interface KyleLoginViewController ()
{
    FBRequest *request;
    NSData *profilePictureData;
}

@end


@implementation KyleLoginViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"Loggedin" sender:self];
    }
}

- (void)commsDidLogin:(BOOL)loggedIn
{
	// Re-enable the Login button
	[self.loginButton setEnabled:YES];
    
	// Did we login successfully ?
	if (loggedIn)
    {
		// Send out request to facebook and get information that we need
        NSString *fbInfoToRequest = @"me/?fields=username,name,gender,id,email,birthday,location";  // <--- asking for these
        request = [FBRequest requestForGraphPath:fbInfoToRequest];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             PFUser *user = [PFUser currentUser];
             
             NSLog(@"RESULTS: %@", result);
             
             //Writing info to PARSE, I think we will need user's Latitude and Longitude too
             
             user[@"username"]      = [result objectForKey:@"username"];
             if (!user[@"name"]) {
                 user[@"name"]          = [result objectForKey:@"name"];
             }
             if (!user[@"FBUsername"]) {
                 user[@"FBUsername"]    = [result objectForKey:@"username"];
             }
             if (!user[@"gender"]) {
                 user[@"gender"]        = [result objectForKey:@"gender"];
             }
             if (!user[@"FBID"]) {
                 user[@"FBID"]          = [result objectForKey:@"id"];
             }
             if (!user[@"email"]) {
                 user[@"email"]         = [result objectForKey:@"email"];
             }
             if (!user[@"birthday"]) {
                 user[@"birthday"]      = [result objectForKey:@"birthday"];
             }
             if (!user[@"about"]) {
                 user[@"about"] = @"...";
             }
             if (!user[@"location"]) {
                 user[@"location"] = [[result objectForKey:@"location"] objectForKey:@"name"];
             }
             [user save]; // <--- Don't want to save in bacgkground, only let user in if their info are good
             
             //Getting user profile picture size LARGE
             NSString *fbAPIForProfilePicture = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=320&height=400", [result objectForKey:@"username"]];
             
             NSURL *profilePictureURL = [NSURL URLWithString:fbAPIForProfilePicture];
             profilePictureData = [NSData dataWithContentsOfURL:profilePictureURL];
             
             ///Save profile picture to Parse as a file
             //Give the picture a name, Im making profile picture name with username, so everyone is different
             NSString *profilePictureName = [NSString stringWithFormat:@"%@.png", [result objectForKey:@"username"]];
             //Creating PFFile type
             PFFile *imageFile = [PFFile fileWithName:profilePictureName data:profilePictureData];
             [user setObject:imageFile forKey:@"profilePictureFile"];
             [user save]; // <--- Don't want to save in bacgkground, only let user in if their pictures are good
             
             [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error)
              {
                  if (!error) {
                      // do something with the new geoPoint
                      [[PFUser currentUser] setObject:geoPoint forKey:@"geoPoint"];
                      [[PFUser currentUser] saveInBackground];
                  }
              }];
             
             if ([PFUser currentUser]) {
                 AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                 PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                 [currentInstallation setDeviceTokenFromData:appDelegate.deviceTokenForPush];
                 [currentInstallation deviceType];
                 [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
                 [currentInstallation setBadge:0];
                 [currentInstallation saveInBackground];
             }
             
             [self performSegueWithIdentifier:@"Loggedin" sender:self];
         }];
	}
    else {
		// Show error alert
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

- (IBAction)actionLogin:(id)sender
{
    [self.loginButton setEnabled:NO];
    
    // Do the login
    [Comms login:self];
}

- (IBAction)unwindFBLoginViewController:(UIStoryboardSegue *)unwindSegue
{

}

@end
