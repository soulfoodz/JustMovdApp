//
//  BucketDetailViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailViewController.h"

@interface BucketDetailViewController ()

@end

@implementation BucketDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)tableHeaderView
{
    UIImageView *imageView;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    imageView.image = self.bucket[@"image"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.tableHeaderView = imageView;
}


- (void)getInfoCell
{
    
}



@end
