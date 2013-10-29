//
//  FBLoginViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/26/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "FBLoginViewController.h"

@interface FBLoginViewController ()
{
    FBRequest *request;
    NSData *profilePictureData;
}

@end


@implementation FBLoginViewController

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
	// Do any additional setup after loading the view.
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
             
             user[@"username"]          = [result objectForKey:@"username"];
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
             if (!user[@"location"]) {
                 user[@"location"]      = [[result objectForKey:@"location"] objectForKey:@"name"];
             }
             if (!user[@"about"]) {
                 user[@"about"]         = @"...";
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
             [[NSURLCache sharedURLCache] removeAllCachedResponses];
             [self dismissViewControllerAnimated:YES completion:nil];
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

@end