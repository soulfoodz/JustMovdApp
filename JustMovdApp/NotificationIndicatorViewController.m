//
//  NotificationIndicatorViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/7/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "NotificationIndicatorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NotificationIndicatorViewController ()
{
    UIImageView *notiImageView;
}

@end

@implementation NotificationIndicatorViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithView:(UIView *)parentView
{
    self = [super init];
    
    if (self) {
        // Custom initialization
        PFInstallation *installation = [PFInstallation currentInstallation];
        if (installation.badge > 0)
        {
            NSLog(@"Badge: %li", (long)installation.badge);
            notiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 3, 20, 20)];
            notiImageView.layer.cornerRadius = 10;
            notiImageView.layer.masksToBounds = YES;
            notiImageView.image = [UIImage imageNamed:@"newmessageindicator"];
            notiImageView.tag = 1;
            [parentView addSubview:notiImageView];
        }
        else
        {
            NSLog(@"Badge: %li", (long)installation.badge);
            
            for (UIImageView *notiView in parentView.subviews) {
                if (notiView.tag == 1) {
                    [notiView removeFromSuperview];
                }
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
