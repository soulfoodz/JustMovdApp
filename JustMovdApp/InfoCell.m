//
//  InfoCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "InfoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation InfoCell
@synthesize descriptionLabel;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backgroundView = [[UIView alloc] init];
        titleLabel = [[UILabel alloc] init];
        descriptionLabel = [[UILabel alloc] init];
        //self.layer.cornerRadius = 5;
        //self.layer.masksToBounds = YES;
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
    [backgroundView setFrame:CGRectMake(10, 1, 300, self.frame.size.height - 1)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 3;
    [self addSubview:backgroundView];

    
    [descriptionLabel setFrame:CGRectMake(88, 12, 200, self.frame.size.height - 15)];
    descriptionLabel.contentMode = UIViewContentModeTop;
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    [backgroundView addSubview:descriptionLabel];
    
    [titleLabel setFrame:CGRectMake(20, 17, 60, 20)];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    [backgroundView addSubview:titleLabel];
}

@end
