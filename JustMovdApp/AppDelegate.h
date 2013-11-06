//
//  AppDelegate.h
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UILabel *hudView;
    UIWindow *hudWindow;
    id presentingMessagingOn;
    id presentingMessagingOff;
    BOOL isMessagingPresented;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSData *deviceTokenForPush;

@end
