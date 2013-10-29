//
//  IntroParentViewController.h
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//  Copyright (c) 2013 Tyler Mikev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comms.h"


@interface IntroParentViewController : UIViewController <UIPageViewControllerDataSource, CommsDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
