//
//  PostsByUserCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PostsByUserCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostsByUserCell
@synthesize profilePicture;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize detailLabel;
@synthesize separatorView;
@synthesize commentCountLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 20)];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 200, 20)];
        detailLabel = [[UILabel alloc] init];
        detailLabel.numberOfLines = 0;
        //detailLabel.backgroundColor = [UIColor cyanColor];
        [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        commentCountLabel = [[UILabel alloc] init];
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
    frame.size.width = 300;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    separatorView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    [self addSubview:separatorView];
    
    profilePicture.layer.cornerRadius = 22;
    profilePicture.layer.masksToBounds = YES;
    [self addSubview:profilePicture];
    
    nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    nameLabel.textColor = [UIColor orangeColor];
    [self addSubview:nameLabel];
    
    timeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLabel];
    
    [detailLabel setFrame:CGRectMake(10, 80, 300, self.frame.size.height - 130)];
    detailLabel.font = [UIFont fontWithName:@"Roboto-Light" size:13.0];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.numberOfLines = 0;
    [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:detailLabel];
    
    [commentCountLabel setFrame:CGRectMake(0, self.frame.size.height - 30.0, 300.0, 30.0)];
    commentCountLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    commentCountLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12.0];
    commentCountLabel.textColor = [UIColor darkGrayColor];
    commentCountLabel.textAlignment = NSTextAlignmentCenter;
    commentCountLabel.layer.borderWidth = 0.5;
    commentCountLabel.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    [self addSubview:commentCountLabel];
}

@end
