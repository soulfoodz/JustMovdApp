//
//  OpenConversationCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "OpenConversationCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation OpenConversationCell
@synthesize profilePicture;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize detailLabel;
@synthesize isNew;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 316, 83)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.cornerRadius = 3;
        [self addSubview:backgroundView];
        
        profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 190, 20)];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 190, 20)];
        detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 2;
        [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        newBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(285, 1, 30, 15)];
        newBadgeLabel.backgroundColor = [UIColor orangeColor];
        newBadgeLabel.layer.cornerRadius = 3;
        newBadgeLabel.textAlignment = NSTextAlignmentCenter;
        newBadgeLabel.text = @"New";
        newBadgeLabel.textColor = [UIColor whiteColor];
        newBadgeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:11.0];
        [backgroundView addSubview:newBadgeLabel];
        [newBadgeLabel setHidden:YES];
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
    
    profilePicture.layer.cornerRadius = 30;
    profilePicture.layer.masksToBounds = YES;
    [profilePicture setContentMode:UIViewContentModeScaleAspectFill];
    [backgroundView addSubview:profilePicture];
    
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:17.0];
    nameLabel.textColor = [UIColor orangeColor];
    [backgroundView addSubview:nameLabel];
    
    timeLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    [backgroundView addSubview:timeLabel];
    
    [detailLabel setFrame:CGRectMake(80, 35, 200, 40)];
    detailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.numberOfLines = 2;
    [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [backgroundView addSubview:detailLabel];
    
    NSLog(@"isNew %i", isNew);
    if (isNew == 1)
    {
        [newBadgeLabel setHidden:NO];
    }
    else
    {
        [newBadgeLabel setHidden:YES];
    }
}

@end
