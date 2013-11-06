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
        backgroundView = [[UIView alloc] init];
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 20)];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 20)];
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

//- (void)setFrame:(CGRect)frame
//{
//    frame.origin.x = 10;
//    frame.size.width = 300;
//    [super setFrame:frame];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [backgroundView setFrame:CGRectMake(10, 5, 300, self.frame.size.height - 10)];
    self.backgroundColor = [UIColor clearColor];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 3;
    [self addSubview:backgroundView];
    
//    separatorView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
//    [self addSubview:separatorView];
    
    profilePicture.layer.cornerRadius = 30;
    profilePicture.layer.masksToBounds = YES;
    [backgroundView addSubview:profilePicture];
    
    nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:16.0];
    nameLabel.textColor = [UIColor orangeColor];
    [backgroundView addSubview:nameLabel];
    
    timeLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    [backgroundView addSubview:timeLabel];
    
    [detailLabel setFrame:CGRectMake(80, 80, 220, self.frame.size.height - 130)];
    detailLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    detailLabel.textColor = [UIColor darkGrayColor];
    detailLabel.numberOfLines = 0;
    [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [backgroundView addSubview:detailLabel];
    
    [commentCountLabel setFrame:CGRectMake(0, backgroundView.frame.size.height - 30.0, 300.0, 30.0)];
    commentCountLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    commentCountLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
    commentCountLabel.textColor = [UIColor darkGrayColor];
    commentCountLabel.textAlignment = NSTextAlignmentCenter;
    commentCountLabel.layer.borderWidth = 0.5;
    commentCountLabel.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    commentCountLabel.layer.cornerRadius = 3;
    [backgroundView addSubview:commentCountLabel];
}

@end
