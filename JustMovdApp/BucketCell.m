//
//  BucketCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketCell.h"
#import "FoursquareVenue.h"
#import <QuartzCore/QuartzCore.h>

#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

@interface BucketCell ()

// lies under mainview and provides drop shadow
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation BucketCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


- (void)resetContents
{
    _creatorAvatar.image = nil;
    _mainImage.image     = nil;
    _titleLabel.text     = nil;
    _distanceLabel.text  = nil;
    _categoryLabel.text  = nil;
    _isChecked           = NO;
    
    [self styleSubviews];
}


- (void)styleSubviews
{
    // This shadowView goes under the mainView and is strictly used for a shadow
    // It needs to be here because we maskToBounds all subviews of mainView,
    // which means the cell's shadow wouldn't be displayed
    
    _shadowView.layer.cornerRadius       = 3.0f;
    _shadowView.layer.shadowColor        = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOpacity      = 0.3f;
    _shadowView.layer.shadowRadius       = 0.6f;
    _shadowView.layer.shadowOffset       = CGSizeMake(0, 0.6f);
    _shadowView.layer.shadowPath         = [[UIBezierPath bezierPathWithRoundedRect:_mainView.bounds cornerRadius:3.0f] CGPath];
    _shadowView.layer.shouldRasterize    = YES;
    _shadowView.layer.rasterizationScale = 2.0f;
    
    _mainView.layer.masksToBounds = YES;
    _mainView.layer.cornerRadius  = 3.0f;

    _titleLabel.font         = titleFont;
    _titleLabel.textColor    = titleColor;
    
    _distanceLabel.font      = detailsFont;
    _distanceLabel.textColor = [UIColor whiteColor];
    
    _categoryLabel.font      = detailsFont;
    _categoryLabel.textColor = [UIColor lightGrayColor];
    
    _creatorLabel.font       = detailsFont;
    _creatorLabel.textColor  = [UIColor lightGrayColor];
    
    _mainImage.contentMode   = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds = YES;
    
    float radiusFloat                  = _creatorAvatar.frame.size.width/2;
    _creatorAvatar.contentMode         = UIViewContentModeScaleAspectFill;
    _creatorAvatar.clipsToBounds       = YES;
    _creatorAvatar.layer.cornerRadius  = radiusFloat;
    _creatorAvatar.layer.borderWidth   = 2.0f;
    _creatorAvatar.layer.borderColor   = [UIColor whiteColor].CGColor;
    _creatorAvatar.layer.shadowColor   = [UIColor blackColor].CGColor;
    _creatorAvatar.layer.shadowOpacity = 0.3f;
    _creatorAvatar.layer.shadowRadius  = 0.6f;
    _creatorAvatar.layer.shadowOffset  = CGSizeMake(0.0, 0.6f);
    _creatorAvatar.layer.shadowPath    = [UIBezierPath bezierPathWithRoundedRect:_creatorAvatar.bounds
                                                                    cornerRadius:radiusFloat].CGPath;
    _creatorAvatar.layer.shouldRasterize = YES;
    _creatorAvatar.layer.rasterizationScale = 2.0f;
    
    _isCheckedOverlay.hidden = YES;
}



@end
