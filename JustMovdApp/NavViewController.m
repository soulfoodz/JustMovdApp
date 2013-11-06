//
//  NavViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/31/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "NavViewController.h"
#import "StatusUpdateViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    StatusUpdateViewController *statusVC = segue.destinationViewController;
//    if (self.presenting) {
//        <#statements#>
//    }
//}

@end
