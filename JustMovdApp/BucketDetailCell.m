//
//  BucketDetailCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketDetailCell.h"

#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

@interface BucketDetailCell ()

@property (weak, nonatomic) IBOutlet UIView      *mainView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel     *quoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *creatorAvatar;


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
    _titleLabel.font          = titleFont;
    _titleLabel.textColor     = titleColor;
    
    _subtitleLabel.font       = detailsFont;
    _subtitleLabel.textColor  = [UIColor lightGrayColor];
    
    _creatorLabel.font           = detailsFont;
    _creatorLabel.textColor      = [UIColor lightGrayColor];
    
    _mainImage.contentMode        = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds      = YES;
    
    _mainView.clipsToBounds       = YES;
    _mainView.layer.cornerRadius  = 4.0f;
    _mainView.layer.shadowPath    = [[UIBezierPath bezierPathWithRoundedRect:_mainView.frame cornerRadius:4.0f] CGPath];
    
    _creatorAvatar.contentMode        = UIViewContentModeScaleAspectFill;
    _creatorAvatar.clipsToBounds      = YES;
    _creatorAvatar.layer.cornerRadius = _creatorAvatar.frame.size.width/2;
    _creatorAvatar.layer.borderWidth  = 2.0f;
    _creatorAvatar.layer.borderColor  = [UIColor whiteColor].CGColor;
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
