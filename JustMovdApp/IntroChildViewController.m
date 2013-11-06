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

@synthesize index, myLabel, backgroundImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myLabel.text = nil;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];

}



@end
