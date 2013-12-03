//
//  BucketCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketCell.h"
#import "FoursquareVenue.h"

#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

@implementation BucketCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)resetContents
{
    _mainImage.image     = nil;
    _titleLabel.text     = nil;
    _distanceLabel.text  = nil;
    _timeLabel.text      = nil;
    
    [self styleCell];
}


- (void)styleCell
{
    _titleLabel.font          = titleFont;
    _titleLabel.textColor     = titleColor;
    
    _distanceLabel.font       = detailsFont;
    _distanceLabel.textColor  = [UIColor lightGrayColor];
    
    _timeLabel.font           = detailsFont;
    _timeLabel.textColor      = [UIColor lightGrayColor];
    
    _mainImage.contentMode        = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds      = YES;
    
    _mainView.clipsToBounds       = YES;
    _mainView.layer.cornerRadius  = 4.0f;
    _mainView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    _mainView.layer.shadowOpacity = 0.2f;
    _mainView.layer.shadowOffset  = CGSizeMake(0, 1.0);
    _mainView.layer.shadowPath    = [[UIBezierPath bezierPathWithRoundedRect:_mainView.frame cornerRadius:4.0f] CGPath];
    
    _creatorAvatar.contentMode        = UIViewContentModeScaleAspectFill;
    _creatorAvatar.clipsToBounds      = YES;
    _creatorAvatar.layer.cornerRadius = _creatorAvatar.frame.size.width/2;
    _creatorAvatar.layer.borderWidth  = 2.0f;
    _creatorAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
}





@end
