//
//  AboutCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/27/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "AboutEditCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AboutEditCell
{
    UIView *backgroundView;
}
@synthesize detailTextView;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 150)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.cornerRadius = 3;
        
        self.backgroundColor = [UIColor clearColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
        titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"About Me";
        
        detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, 270, 100)];
        detailTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        detailTextView.backgroundColor = [UIColor clearColor];
        detailTextView.textColor = [UIColor darkGrayColor];
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

    [detailTextView scrollRangeToVisible:NSMakeRange([detailTextView.text length] -1, 1)];
    [backgroundView addSubview:titleLabel];
    [backgroundView addSubview:detailTextView];
    [self addSubview:backgroundView];
}


@end
