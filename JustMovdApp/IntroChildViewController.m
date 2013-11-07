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

@synthesize index, myLabel, backgroundImage, backgroundView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myLabel.text = nil;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    
    UIImageView *bkView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100, 250, 400)];
    [bkView setImage:[UIImage imageNamed:backgroundView]];
    
    [self.view addSubview:bkView];
    
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-10);
    page.numberOfPages = 3;
    page.currentPage = index;
    [self.view addSubview:page];
    

}



@end
