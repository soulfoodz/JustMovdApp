//
//  SpinnerViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/5/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "SpinnerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SpinnerViewController ()

@end

@implementation SpinnerViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithSize:(float)size andCornerRadius:(float)radius andView:(UIView *)view;
{
    self = [super init];
    
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, size, size)];
        self.view.layer.cornerRadius = radius;
        self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        UIActivityIndicatorView *spinner = [UIActivityIndicatorView new];
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner startAnimating];
        [self.view addSubview:spinner];
        spinner.center = self.view.center;
        [view addSubview:self.view];
        self.view.center = view.center;
        [view bringSubviewToFront:self.view];
    }
    
    return self;
}

- (id)initWithDefaultSizeWithView:(UIView *)view
{
    self = [super init];
    
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, 100, 100)];
        self.view.layer.cornerRadius = 20;
        self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        UIActivityIndicatorView *spinner = [UIActivityIndicatorView new];
        [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner startAnimating];
        [self.view addSubview:spinner];
        spinner.center = self.view.center;
        [view addSubview:self.view];
        self.view.center = view.center;
        [view bringSubviewToFront:self.view];
    }
    
    return self;
}


@end
