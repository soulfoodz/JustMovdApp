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
        descriptionLabel = [[UILabel alloc] init];
        titleLabel = [[UILabel alloc] init];
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

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width = 300.0;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [descriptionLabel setFrame:CGRectMake(88, 12, 200, self.frame.size.height - 15)];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:descriptionLabel];
    [titleLabel setFrame:CGRectMake(20, 17, 60, 20)];
    titleLabel.textColor = [UIColor orangeColor];
    [self addSubview:titleLabel];
}

@end
