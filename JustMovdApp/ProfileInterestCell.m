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
        self.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 75, 20)];
        titleLabel.textColor = [UIColor orangeColor];
        titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        [self addSubview:titleLabel];
        
        firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 30, 30)];
        [self addSubview:firstImageView];
        secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 40, 30, 30)];
        [self addSubview:secondImageView];
        thirdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 40, 30, 30)];
        [self addSubview:thirdImageView];
        fourthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(135, 40, 30, 30)];
        [self addSubview:fourthImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    
}

@end
