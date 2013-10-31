//
//  TestViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/30/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import "IntroParentViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController



- (void)viewDidLoad
{
    [super viewDidLoad];


}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"logout" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(160, 300);
    
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    if (![PFUser currentUser]){
        
        IntroParentViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroParentViewController"];
        
        [self presentViewController:signupVC animated:NO completion:^{
            nil;
        }];
    }
    
    
}


-(void)logout{
    [PFUser logOut];
    
    IntroParentViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroParentViewController"];
    
    [self presentViewController:signupVC animated:YES completion:^{
        nil;
    }];
}


@end
