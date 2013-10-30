//
//  IntroParentViewController.m
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//  Copyright (c) 2013 Tyler Mikev. All rights reserved.
//

#import "IntroParentViewController.h"
#import "IntroChildViewController.h"

@interface IntroParentViewController ()
{
    FBRequest *request;
    NSData *profilePictureData;


}

@property (nonatomic, retain) UIBarButtonItem *skipBarButton;


@end

@implementation IntroParentViewController

@synthesize pageController;
@synthesize skipBarButton;


- (void)viewDidLoad
{
    [super viewDidLoad];



    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser])
    {
        [self loadIntro];
    }
    else
    {
        [self performSegueWithIdentifier:@"toAppDirectly" sender:self];
    }
    
}

-(void)loadIntro{
    
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    IntroChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [pageController didMoveToParentViewController:self];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"Next View" forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(160, 400);
    
    
    [self.view addSubview:nextButton];
    
    [nextButton addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    
    
}




-(void)nextView{
    
    // Do the login
    [Comms login:self];
}


- (void)commsDidLogin:(BOOL)loggedIn
{
	// Re-enable the Login button
	//[self.loginButton setEnabled:YES];
    
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
             if (!user[@"about"]){
                 user[@"about"] = @"...";
             }
             
             
             [user save]; // <--- Don't want to save in background, only let user in if their info are good
             
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
             
             [self performSegueWithIdentifier:@"abc" sender:self];
             
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



- (IntroChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Questionnaire" bundle:nil];
    IntroChildViewController *childViewController = [sb instantiateViewControllerWithIdentifier:@"introChild"];
    
    childViewController.index = index;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroChildViewController *)viewController index];
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}



@end
