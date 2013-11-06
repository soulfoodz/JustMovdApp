//
//  ProfileInterestCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/4/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ProfileInterestCell.h"

@implementation ProfileInterestCell
@synthesize firstImageView;
@synthesize secondImageView;
@synthesize thirdImageView;
@synthesize fourthImageView;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 1, 300, self.frame.size.height - 1)];
        backgroundView.layer.cornerRadius = 3;
        [self addSubview:backgroundView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 60, 20)];
        titleLabel.textColor = [UIColor orangeColor];
        titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        [backgroundView addSubview:titleLabel];
        
        firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 22, 22)];
        [backgroundView addSubview:firstImageView];
        secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(132, 10, 22, 22)];
        [backgroundView addSubview:secondImageView];
        thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(164, 10, 22, 22)];
        [backgroundView addSubview:thirdImageView];
        fourthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(196, 10, 22, 22)];
        [backgroundView addSubview:fourthImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    backgroundView.backgroundColor = [UIColor whiteColor];
}

@end
