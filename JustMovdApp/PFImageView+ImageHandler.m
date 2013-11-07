//
//  PFImageView+ImageHandler.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PFImageView+ImageHandler.h"

@implementation PFImageView (ImageHandler)


- (void)setFile:(PFFile *)file forAvatarImageView:(PFImageView *)imageView
{
    if (!file) {
        NSLog(@"Couldn't find a file!");
        return;
    }
    
    imageView.image = [UIImage imageNamed:@"avatar_placeholder.png"];
    imageView.file = file;
    [imageView loadInBackground];
}


- (void)setFile:(PFFile *)file forImageView:(PFImageView *)imageView
{
    if (!file) {
        NSLog(@"Couldn't find a file!");
        return;
    }
    
    imageView.image = [UIImage imageNamed:@"avatar_placeholder.png"];
    imageView.file = file;
    [imageView loadInBackground];
}


@end
