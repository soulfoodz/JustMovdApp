//
//  BucketListHeaderView.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/17/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketListHeaderView.h"

#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]

@interface BucketListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BucketListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)styleView
{
    self.titleLabel.font      = titleFont;
    self.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.completedLabel.font  = titleFont;
    self.completedLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:158.0/255.0 blue:151.0/255.0 alpha:1.0];
    
    self.mainView.layer.cornerRadius       = 3.0f;
    self.mainView.layer.shadowColor        = [UIColor blackColor].CGColor;
    self.mainView.layer.shadowOpacity      = 0.3f;
    self.mainView.layer.shadowRadius       = 0.6f;
    self.mainView.layer.shadowOffset       = CGSizeMake(0, 0.6f);
    self.mainView.layer.shadowPath         = [[UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:3.0f] CGPath];
    self.mainView.layer.shouldRasterize    = YES;
    self.mainView.layer.rasterizationScale = 2.0f;
    
    self.mainView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
}

@end
