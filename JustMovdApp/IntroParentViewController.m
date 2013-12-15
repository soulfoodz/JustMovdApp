//
//  IntroParentViewController.m
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//

#import "IntroParentViewController.h"
#import "IntroChildViewController.h"
#import "QuestionnaireViewController.h"
#import "SpinnerViewController.h"
#import "AppDelegate.h"
#import "ParseServices.h"

@interface IntroParentViewController ()
{
    FBRequest *request;
    NSData *profilePictureData;
    
    NSArray *backgroundImages;
    NSArray *backgroundViews;
    UIPageControl *pageControl;
    
}

@property (nonatomic, retain) UIBarButtonItem *skipBarButton;


@end

@implementation IntroParentViewController

@synthesize pageController;
@synthesize skipBarButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundImages = [[NSArray alloc] initWithObjects:@"chicago_skyline_blur", @"skyline_blur", @"boston_skyline_blur", nil];
    backgroundViews = [[NSArray alloc] initWithObjects:@"walkthrough_david", @"walkthrough_sarah", @"walkthrough_ashley", nil];
    backgroundImages = [[NSArray alloc] initWithObjects:@"walkthrough_meetpeople", @"walkthrough_localspots", @"walkthrough_havefun",@"walkthrough_atx", nil];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"skyline_blur"]];
    
    [self loadIntro];
    
}


-(void)loadIntro
{
    
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    pageController.dataSource = self;
    pageController.delegate = self;
    [[pageController view] setFrame:[[self view] bounds]];
    
    CGRect frame = pageController.view.frame;
    frame.size.height = frame.size.height+37;
    pageController.view.frame = frame;
    
    IntroChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [pageController didMoveToParentViewController:self];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"FacebookLoginButton"] forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(160, 460);
    
    [self.view addSubview:nextButton];
    [nextButton addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *eulaLabelBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    eulaLabelBtn.frame           = CGRectMake(0, 0, 180, 20);
    eulaLabelBtn.center          = CGPointMake(160, 520);
    eulaLabelBtn.titleLabel.textColor = [UIColor lightGrayColor];
    eulaLabelBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:10.0f];
    [eulaLabelBtn setTitle:@"By signing up you agree to the EULA"
                  forState:UIControlStateNormal];
    [eulaLabelBtn addTarget:self
                     action:@selector(goToEULA)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:eulaLabelBtn];
    
    
    UILabel *justMovdLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 200, 50)];
    
    justMovdLabel.text = @"JustMovd";
    justMovdLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:32];
    justMovdLabel.textAlignment = NSTextAlignmentCenter;
    
    justMovdLabel.center = CGPointMake(self.view.frame.size.width/2, 60);
    justMovdLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:justMovdLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 400, 300, 50)];
    
    descriptionLabel.text = @"The App For People New To A City";
    descriptionLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    
    descriptionLabel.center = CGPointMake(self.view.frame.size.width/2, 250);
    descriptionLabel.textColor = [UIColor whiteColor];
    
    // [self.view addSubview:descriptionLabel];
    
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 20);
    
    // [self.view addSubview:pageControl];
    
    
}



- (void)goToEULA
{
    NSString    *eulaString;
    UIAlertView *eulaAlert;
    
    eulaString = @"LICENSED APPLICATION END USER LICENSE AGREEMENT \n\nThe Products transacted through the Service are licensed, not sold, to You for use only under the terms of this license, unless a Product is accompanied by a separate license agreement, in which case the terms of that separate license agreement will govern, subject to Your prior acceptance of that separate license agreement. The licensor (“Application Provider”) reserves all rights not expressly granted to You. The Product that is subject to this license is referred to in this license as the “Licensed Application.”\n\n a. Scope of License: This license granted to You for the Licensed Application by Application Provider is limited to a non-transferable license to use the Licensed Application on any iPhone or iPod touch that You own or control and as permitted by the Usage Rules set forth in Section 9.b. of the App Store Terms and Conditions (the “Usage Rules”). This license does not allow You to use the Licensed Application on any iPod touch or iPhone that You do not own or control, and You may not distribute or make the Licensed Application available over a network where it could be used by multiple devices at the same time. You may not rent, lease, lend, sell, redistribute or sublicense the Licensed Application. You may not copy (except as expressly permitted by this license and the Usage Rules), decompile, reverse engineer, disassemble, attempt to derive the source code of, modify, or create derivative works of the Licensed Application, any updates, or any part thereof (except as and only to the extent any foregoing restriction is prohibited by applicable law or to the extent as may be permitted by the licensing terms governing use of any open sourced components included with the Licensed Application). Any attempt to do so is a violation of the rights of the Application Provider and its licensors. If You breach this restriction, You may be subject to prosecution and damages. The terms of the license will govern any upgrades provided by Application Provider that replace and/or supplement the original Product, unless such upgrade is accompanied by a separate license in which case the terms of that license will govern.\n\n b. Consent to Use of Data: You agree that Application Provider may collect and use technical data and related information, including but not limited to technical information about Your device, system and application software, and peripherals, that is gathered periodically to facilitate the provision of software updates, product support and other services to You (if any) related to the Licensed Application. Application Provider may use this information, as long as it is in a form that does not personally identify You, to improve its products or to provide services or technologies to You.\n\n c. Termination. The license is effective until terminated by You or Application Provider. Your rights under this license will terminate automatically without notice from the Application Provider if You fail to comply with any term(s) of this license. Upon termination of the license, You shall cease all use of the Licensed Application, and destroy all copies, full or partial, of the Licensed Application.\n\n d. Services; Third Party Materials. The Licensed Application may enable access to Application Provider’s and third party services and web sites (collectively and individually, 'Services'). Use of the Services may require Internet access and that You accept additional terms of service.\n\n You understand that by using any of the Services, You may encounter content that may be deemed offensive, indecent, or objectionable, which content may or may not be identified as having explicit language, and that the results of any search or entering of a particular URL may automatically and unintentionally generate links or references to objectionable material. Nevertheless, You agree to use the Services at Your sole risk and that the Application Provider shall not have any liability to You for content that may be found to be offensive, indecent, or objectionable.\n\n Certain Services may display, include or make available content, data, information, applications or materials from third parties (“Third Party Materials”) or provide links to certain third party web sites. By using the Services, You acknowledge and agree that the Application Provider is not responsible for examining or evaluating the content, accuracy, completeness, timeliness, validity, copyright compliance, legality, decency, quality or any other aspect of such Third Party Materials or web sites. The Application Provider does not warrant or endorse and does not assume and will not have any liability or responsibility to You or any other person for any third-party Services, Third Party Materials or web sites, or for any other materials, products, or services of third parties. Third Party Materials and links to other web sites are provided solely as a convenience to You. Financial information displayed by any Services is for general informational purposes only and is not intended to be relied upon as investment advice. Before executing any securities transaction based upon information obtained through the Services, You should consult with a financial professional. Location data provided by any Services is for basic navigational purposes only and is not intended to be relied upon in situations where precise location information is needed or where erroneous, inaccurate or incomplete location data may lead to death, personal injury, property or environmental damage. Neither the Application Provider, nor any of its content providers, guarantees the availability, accuracy, completeness, reliability, or timeliness of stock information or location data displayed by any Services.\n\n You agree that any Services contain proprietary content, information and material that is protected by applicable intellectual property and other laws, including but not limited to copyright, and that You will not use such proprietary content, information or materials in any way whatsoever except for permitted use of the Services. No portion of the Services may be reproduced in any form or by any means. You agree not to modify, rent, lease, loan, sell, distribute, or create derivative works based on the Services, in any manner, and You shall not exploit the Services in any unauthorized way whatsoever, including but not limited to, by trespass or burdening network capacity. You further agree not to use the Services in any manner to harass, abuse, stalk, threaten, defame or otherwise infringe or violate the rights of any other party, and that the Application Provider is not in any way responsible for any such use by You, nor for any harassing, threatening, defamatory, offensive or illegal messages or transmissions that You may receive as a result of using any of the Services.\n\n In addition, third party Services and Third Party Materials that may be accessed from, displayed on or linked to from the iPhone or iPod touch are not available in all languages or in all countries. The Application Provider makes no representation that such Services and Materials are appropriate or available for use in any particular location. To the extent You choose to access such Services or Materials, You do so at Your own initiative and are responsible for compliance with any applicable laws, including but not limited to applicable local laws. The Application Provider, and its licensors, reserve the right to change, suspend, remove, or disable access to any Services at any time without notice. In no event will the Application Provider be liable for the removal of or disabling of access to any such Services. The Application Provider may also impose limits on the use of or access to certain Services, in any case and without notice or liability.\n\n e. NO WARRANTY: YOU EXPRESSLY ACKNOWLEDGE AND AGREE THAT USE OF THE LICENSED APPLICATION IS AT YOUR SOLE RISK AND THAT THE ENTIRE RISK AS TO SATISFACTORY QUALITY, PERFORMANCE, ACCURACY AND EFFORT IS WITH YOU. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE LICENSED APPLICATION AND ANY SERVICES PERFORMED OR PROVIDED BY THE LICENSED APPLICATION ('SERVICES') ARE PROVIDED 'AS IS' AND 'AS AVAILABLE', WITH ALL FAULTS AND WITHOUT WARRANTY OF ANY KIND, AND APPLICATION PROVIDER HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS WITH RESPECT TO THE LICENSED APPLICATION AND ANY SERVICES, EITHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES AND/OR CONDITIONS OF MERCHANTABILITY, OF SATISFACTORY QUALITY, OF FITNESS FOR A PARTICULAR PURPOSE, OF ACCURACY, OF QUIET ENJOYMENT, AND NON-INFRINGEMENT OF THIRD PARTY RIGHTS. APPLICATION PROVIDER DOES NOT WARRANT AGAINST INTERFERENCE WITH YOUR ENJOYMENT OF THE LICENSED APPLICATION, THAT THE FUNCTIONS CONTAINED IN, OR SERVICES PERFORMED OR PROVIDED BY, THE LICENSED APPLICATION WILL MEET YOUR REQUIREMENTS, THAT THE OPERATION OF THE LICENSED APPLICATION OR SERVICES WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT DEFECTS IN THE LICENSED APPLICATION OR SERVICES WILL BE CORRECTED. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY APPLICATION PROVIDER OR ITS AUTHORIZED REPRESENTATIVE SHALL CREATE A WARRANTY. SHOULD THE LICENSED APPLICATION OR SERVICES PROVE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES OR LIMITATIONS ON APPLICABLE STATUTORY RIGHTS OF A CONSUMER, SO THE ABOVE EXCLUSION AND LIMITATIONS MAY NOT APPLY TO YOU.\n\n f. Limitation of Liability. TO THE EXTENT NOT PROHIBITED BY LAW, IN NO EVENT SHALL APPLICATION PROVIDER BE LIABLE FOR PERSONAL INJURY, OR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES WHATSOEVER, INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, LOSS OF DATA, BUSINESS INTERRUPTION OR ANY OTHER COMMERCIAL DAMAGES OR LOSSES, ARISING OUT OF OR RELATED TO YOUR USE OR INABILITY TO USE THE LICENSED APPLICATION, HOWEVER CAUSED, REGARDLESS OF THE THEORY OF LIABILITY (CONTRACT, TORT OR OTHERWISE) AND EVEN IF APPLICATION PROVIDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS DO NOT ALLOW THE LIMITATION OF LIABILITY FOR PERSONAL INJURY, OR OF INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THIS LIMITATION MAY NOT APPLY TO YOU. In no event shall Application Provider’s total liability to you for all damages (other than as may be required by applicable law in cases involving personal injury) exceed the amount of fifty dollars ($50.00). The foregoing limitations will apply even if the above stated remedy fails of its essential purpose.\n\n g. You may not use or otherwise export or re-export the Licensed Application except as authorized by United States law and the laws of the jurisdiction in which the Licensed Application was obtained. In particular, but without limitation, the Licensed Application may not be exported or re-exported (a) into any U.S. embargoed countries or (b) to anyone on the U.S. Treasury Department's list of Specially Designated Nationals or the U.S. Department of Commerce Denied Person’s List or Entity List. By using the Licensed Application, you represent and warrant that you are not located in any such country or on any such list. You also agree that you will not use these products for any purposes prohibited by United States law, including, without limitation, the development, design, manufacture or production of nuclear, missiles, or chemical or biological weapons.\n\n h. The Licensed Application and related documentation are 'Commercial Items', as that term is defined at 48 C.F.R. §2.101, consisting of 'Commercial Computer Software' and 'Commercial Computer Software Documentation', as such terms are used in 48 C.F.R. §12.212 or 48 C.F.R. §227.7202, as applicable. Consistent with 48 C.F.R. §12.212 or 48 C.F.R. §227.7202-1 through 227.7202-4, as applicable, the Commercial Computer Software and Commercial Computer Software Documentation are being licensed to U.S. Government end users (a) only as Commercial Items and (b) with only those rights as are granted to all other end users pursuant to the terms and conditions herein. Unpublished-rights reserved under the copyright laws of the United States.\n\n i. There is zero tolerance for posting objectionable content. Your account will be terminated immediately for posting objectionable content. Objectionable content is defined as any of the following:\n\n     1. Content that is defamatory, offensive, mean-spirited, or likely to place the targeted individual or group in harm's way.\n\n     2. Content that is excessively objectionable or crude, or content primarily designed to upset or disgust other users.\n\n       3. Content that is pornographic, defined by Webster's Dictionary as 'explicit descriptions or displays of sexual organs or activities intended to stimulate erotic rather than aesthetic or emotional feelings.'";
    
    eulaAlert = [[UIAlertView alloc] initWithTitle:@"EULA" message:eulaString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [eulaAlert show];
    
    /*
     UIViewController *eulaVC;
     UINavigationController *navC;
     UIWebView        *webView;
     NSString         *urlString;
     NSURL            *url;
     NSURLRequest     *aRequest;
     
     urlString  = @"http://www.apple.com/legal/internet-services/itunes/appstore/dev/stdeula/";
     url        = [NSURL URLWithString:urlString];
     aRequest   = [NSURLRequest requestWithURL:url];
     
     webView     = [UIWebView new];
     eulaVC      = [[UIViewController alloc] init];
     eulaVC.view = webView;
     
     [webView loadRequest:aRequest];
     navC = [[UINavigationController alloc] initWithRootViewController:eulaVC];
     [self presentViewController:eulaVC animated:YES completion:nil];
     */
}



-(void)nextView {
    [Comms login:self];
}



- (void)commsDidLogin:(BOOL)loggedIn
{
	if (loggedIn)
    {
        SpinnerViewController *spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
        spinner.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        coverView.backgroundColor = [UIColor grayColor];
        coverView.alpha = 0.1;
        
        [self.view addSubview:coverView];
        [self.view addSubview:spinner.view];
        
        [self saveDeviceTokenToCurrentInstallation];
        [self requestAndWritingFacebookInfo];
	}
    else {
		[[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again!"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
	}
}

- (void)requestAndWritingFacebookInfo
{
    // Request for Facebook ID
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             NSString *facebookId = [result objectForKey:@"id"];
             NSLog(@"Facebook data: %@", result);
             
             PFUser *user = [PFUser currentUser];
             
             //Writing info to PARSE
             user[@"username"]      = [result objectForKey:@"username"];
             user[@"name"]          = [result objectForKey:@"name"];
             user[@"firstName"]     = [result objectForKey:@"first_name"];
             user[@"FBUsername"]    = [result objectForKey:@"username"];
             user[@"gender"]        = [result objectForKey:@"gender"];
             user[@"FBID"]          = facebookId;
             user[@"email"]         = [result objectForKey:@"email"];
             user[@"birthday"]      = [result objectForKey:@"birthday"];
             
             if (!user[@"about"]){
                 user[@"about"]     = @"...";
             }
             
             if ([result valueForKeyPath:@"location.name"]){
                 if (!user[@"location"]){
                     user[@"location"] = [result valueForKeyPath:@"location.name"];
                 }
             } else {
                 if (!user[@"location"]){
                     user[@"location"] = @"...";
                 }
             }
             
             [user save];
             
             
             //Getting user profile picture size medium, file size about 40kb
             NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=320&height=400", facebookId]];
             profilePictureData = [NSData dataWithContentsOfURL:profilePictureURL];
             
             ///Save profile picture to Parse as a file
             //Give the picture a name, Im making profile picture name with username, so everyone is different
             NSString *profilePictureName = [NSString stringWithFormat:@"%@.png", [result objectForKey:@"username"]];
             //Creating PFFile type
             PFFile *imageFile = [PFFile fileWithName:profilePictureName data:profilePictureData];
             [user setObject:imageFile forKey:@"profilePictureFile"];
             
             [user save];
             //[[NSURLCache sharedURLCache] removeAllCachedResponses];
             
             //Checking user's interests to know which ViewController will be presented next
             [ParseServices queryForInterestsForUser:[PFUser currentUser] completionBlock:^(NSArray *interestResult, BOOL success)
              {
                  if (success) {
                      if ([interestResult count] == 0){
                          [self performSegueWithIdentifier:@"abc" sender:self];
                      } else {
                          [self dismissViewControllerAnimated:YES completion:^{
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"gotofeed" object:nil];
                          }];
                      }
                  }
                  else
                      NSLog(@"Error getting interests for logged in user!");
              }];
         }
         else
             NSLog(@"Error request Facebook info: %@", error);
     }];
}

- (void)saveDeviceTokenToCurrentInstallation
{
    if ([PFUser currentUser])
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:appDelegate.deviceTokenForPush];
        [currentInstallation deviceType];
        [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
        [currentInstallation setBadge:0];
        [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error) {
                 [currentInstallation saveEventually];
             }
         }];
    }
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
    
    //    childViewController.backgroundImage = [backgroundImages objectAtIndex:index];
    //    childViewController.backgroundView = [backgroundViews objectAtIndex:index];
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    pageControl.currentPage--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroChildViewController *)viewController index];
    
    index++;
    pageControl.currentPage++;
    
    
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotofeed" object:nil];
    }];
}


-(NSString*)getFirstName:(NSString*)fullName{
    
    NSArray *array = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    NSString *firstName = [array objectAtIndex:0];
    
    return firstName;
    
}

@end
