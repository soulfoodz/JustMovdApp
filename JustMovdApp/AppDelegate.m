//
//  AppDelegate.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "OpenConversationViewController.h"
#import "MessagingViewController.h"
#import "OpenConversationViewController.h"
#import "SWRevealViewController.h"
#import "SideBarViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"VoLGglRLMEfV6y4YWx8t9b2X0OWYjCXwkWbzA9EO" clientKey:@"JNEhs1jNpYFEWW4eejYmN5EqXFoT0JFjAkB3TD0n"];

    [PFFacebookUtils initializeFacebook];
    
    //Register for push Notification
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    presentingMessagingOn = [[NSNotificationCenter defaultCenter] addObserverForName:@"PresentingMessagingOn" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        isMessagingPresented = YES;
    }];
    
    presentingMessagingOff = [[NSNotificationCenter defaultCenter] addObserverForName:@"PresentingMessagingOff" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        isMessagingPresented = NO;
    }];
    
    //Extra initialize
    hudView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    hudView.backgroundColor = [UIColor orangeColor];
    hudView.textAlignment = NSTextAlignmentCenter;
    hudView.textColor = [UIColor whiteColor];
    hudView.font = [UIFont fontWithName:@"Roboto-Light" size:13.0];
    [self.window addSubview:hudView];
    
    hudWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    hudWindow.windowLevel = UIWindowLevelStatusBar;
    hudWindow.backgroundColor = [UIColor orangeColor];
    [hudWindow addSubview:hudView];
    hudWindow.alpha = 0;
    
    return YES;
}

#pragma mark Push Notification Setup

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    self.deviceTokenForPush = deviceToken;
    
    // Store the deviceToken in the current Installation and save it to Parse.
    if ([PFUser currentUser]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation deviceType];
        [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
        [currentInstallation saveInBackground];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to Register for Push: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo: %@", userInfo);
    
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"Active");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewMessageNotification" object:nil];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        //Showing HUD
        if (!isMessagingPresented)
        {
            hudWindow.hidden = NO;
            hudView.text = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            [UIView animateWithDuration:0.5 animations:^{
                hudWindow.alpha = 1.0;
            }];
            
            [self performSelector:@selector(hideHUDView) withObject:nil afterDelay:10.0];
        }
    }
    else
    {
        NSLog(@"Background");
        //[PFPush handlePush:userInfo];
//        UIStoryboard *messagesSB = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
//            OpenConversationViewController *conversationVC = [messagesSB instantiateViewControllerWithIdentifier:@"conversation"];
//        UINavigationController *navigationForConversationVC = [[UINavigationController alloc] initWithRootViewController:conversationVC];
//        
//        UIStoryboard *questionSB = [UIStoryboard storyboardWithName:@"Questionnaire" bundle:nil];
//        SideBarViewController *sideBarVC = [questionSB instantiateViewControllerWithIdentifier:@"sidebarVC"];
//        
//        SWRevealViewController *revealVC = [[SWRevealViewController alloc] initWithRearViewController:sideBarVC frontViewController:navigationForConversationVC];
//        [self.window setRootViewController:revealVC];
    }
}

- (void)hideHUDView
{
    [UIView animateWithDuration:0.5 animations:^{
        hudWindow.alpha = 0.0;
    }];
}

// ====================

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([PFUser currentUser]) {
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error)
        {
            if (!error) {
                // do something with the new geoPoint
                [[PFUser currentUser] setObject:geoPoint forKey:@"geoPoint"];
                [[PFUser currentUser] saveInBackground];
            }
        }];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:presentingMessagingOn];
    [[NSNotificationCenter defaultCenter] removeObserver:presentingMessagingOff];
}


#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}

@end
