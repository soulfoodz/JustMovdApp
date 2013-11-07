//
//  IntroParentViewController.m
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//  Copyright (c) 2013 Tyler Mikev. All rights reserved.
//

#import "IntroParentViewController.h"
#import "IntroChildViewController.h"
#import "QuestionnaireViewController.h"

@interface IntroParentViewController ()
{
    FBRequest *request;
    NSData *profilePictureData;

    NSArray *backgroundImages;

}

@property (nonatomic, retain) UIBarButtonItem *skipBarButton;


@end

@implementation IntroParentViewController

@synthesize pageController;
@synthesize skipBarButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundImages = [[NSArray alloc] initWithObjects:@"login1", @"login2", @"login3", nil];
    self.view.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:246/255.0 alpha:1.0];

    [self loadIntro];
    
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
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"facebooklogin"] forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(160, 480);
    
    [self.view addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *justMovdLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 200, 200, 50)];
    
    justMovdLabel.text = @"JustMovd";
    justMovdLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:28];
    justMovdLabel.textAlignment = NSTextAlignmentCenter;
    
    justMovdLabel.center = CGPointMake(self.view.frame.size.width/2, 100);
    
    [self.view addSubview:justMovdLabel];
}



-(void)nextView {
    [Comms login:self];
}



- (void)commsDidLogin:(BOOL)loggedIn
{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, 200);
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    coverView.backgroundColor = [UIColor grayColor];
    coverView.alpha = 0.4;
    
    [self.view addSubview:coverView];
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
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
             if (!user[@"firstName"]) {
                 user[@"firstName"]          = [self getFirstName:[result objectForKey:@"name"]];
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
             
             if ([[result objectForKey:@"location"] objectForKey:@"name"]){
                 if (!user[@"location"]){
                     user[@"location"] = [[result objectForKey:@"location"] objectForKey:@"name"];
                 }
             } else {
                 if (!user[@"location"]){
                     user[@"location"] = @"...";
                 }
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
             
             [user save];
             [[NSURLCache sharedURLCache] removeAllCachedResponses];
             
             
             
             PFQuery *query = [PFQuery queryWithClassName:@"Interests"];
             [query whereKey:@"User" equalTo:[PFUser currentUser]];
             
             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 if ([objects count] == 0){
                     [self performSegueWithIdentifier:@"abc" sender:self];
                 } else {
                     [self dismissViewControllerAnimated:YES completion:^{
                         nil;
                     }];
                 }
             }];
             
             
         }];
	}
    else {
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
    
    
    coverView = nil;
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"abc"] ){
        QuestionnaireViewController *questVC = segue.destinationViewController;
        questVC.delegate = self;
    }
}


- (IntroChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Questionnaire" bundle:nil];
    IntroChildViewController *childViewController = [sb instantiateViewControllerWithIdentifier:@"introChild"];
    
    childViewController.index = index;
    childViewController.backgroundImage = [backgroundImages objectAtIndex:index];
    
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


-(void)viewControllerDone:(id)view{
    [self dismissViewControllerAnimated:NO completion:^{
        nil;
    }];
}


-(NSString*)getFirstName:(NSString*)fullName{
    
    NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    NSString *firstName = [array objectAtIndex:0];
    
    return firstName;
    
}


@end
