//
//  IntroChildViewController.m
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//  Copyright (c) 2013 Tyler Mikev. All rights reserved.
//

#import "IntroChildViewController.h"

@interface IntroChildViewController ()

@end

@implementation IntroChildViewController

@synthesize index, myLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];

    myLabel.text = [NSString stringWithFormat:@"%ld", (long)index];

}



@end
