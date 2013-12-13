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
        self.backgroundColor = [UIColor whiteColor];
        titleLabel = [[UILabel alloc] init];
        descriptionLabel = [[UILabel alloc] init];
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
    
    [titleLabel setFrame:CGRectMake(15, 12, 60, 20)];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [descriptionLabel setFrame:CGRectMake(15, 40, 290, self.frame.size.height - 15)];
    descriptionLabel.contentMode = UIViewContentModeTop;
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [descriptionLabel sizeToFit];
    
    [self addSubview:descriptionLabel];
    [self addSubview:titleLabel];
}

@end
