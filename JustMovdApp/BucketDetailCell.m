//
//  BucketDetailCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailCell.h"
#import <QuartzCore/QuartzCore.h>

#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

@interface BucketDetailCell ()




@end

@implementation BucketDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)styleSubviews
{
    _titleLabel.font         = titleFont;
    _titleLabel.textColor    = titleColor;
    
    _subtitleLabel.font      = detailsFont;
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    
    _creatorLabel.font       = subtitleFont;
    _creatorLabel.textColor  = [UIColor lightGrayColor];
    
    _quoteLabel.font      = detailsFont;
    _quoteLabel.textColor = [UIColor darkGrayColor];
    
    _mainImage.contentMode   = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds = YES;
    
    _mainView.clipsToBounds       = YES;
        
    _creatorAvatar.contentMode        = UIViewContentModeScaleAspectFill;
    _creatorAvatar.layer.cornerRadius = _creatorAvatar.frame.size.width/2;
    _creatorAvatar.layer.borderWidth  = 2.0f;
    _creatorAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
    _creatorAvatar.clipsToBounds      = YES;
}


- (void)resetContents
{
    _mainImage.image     = nil;
    _titleLabel.text     = nil;
    _subtitleLabel.text  = nil;
    _creatorLabel.text   = nil;
    _creatorAvatar.image = nil;
    _mainImage.image     = nil;
    
    [self styleSubviews];
}










@end
