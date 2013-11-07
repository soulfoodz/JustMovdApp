//
//  MatchTableViewCell.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 11/4/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "MatchTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MatchTableViewCell

@synthesize profilePicture, nameLabel, ageLabel, genderLabel, firstInterest, secondInterest, thirdInterest, fourthInterest, distanceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        //[self layoutSubviews];
        
        self.backgroundColor = [UIColor clearColor];
        cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cellBackgroundView.layer.cornerRadius = 3;
        cellBackgroundView.layer.masksToBounds = YES;
        
        [self addSubview:cellBackgroundView];
        
        profilePicture = [[UIImageView alloc] init];
        profilePicture.layer.masksToBounds = YES;
        [cellBackgroundView addSubview:profilePicture];
        
        profilePicture.clipsToBounds = YES;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 100, 30)];
        nameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18];
        nameLabel.textColor = [UIColor orangeColor];
        
        [cellBackgroundView addSubview:nameLabel];
        
        
        UILabel *matchedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 120, 30)];
        matchedLabel.text = @"Matched Interests:";
        matchedLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
        [cellBackgroundView addSubview:matchedLabel];
        
        firstInterest = [[UIImageView alloc] initWithFrame:CGRectMake(120, 200, 22, 22)];
        secondInterest = [[UIImageView alloc] initWithFrame:CGRectMake(150, 200, 22, 22)];
        thirdInterest = [[UIImageView alloc] initWithFrame:CGRectMake(180, 200, 22, 22)];
        fourthInterest = [[UIImageView alloc] initWithFrame:CGRectMake(210, 200, 22, 22)];
        
        [cellBackgroundView addSubview:firstInterest];
        [cellBackgroundView addSubview:secondInterest];
        [cellBackgroundView addSubview:thirdInterest];
        [cellBackgroundView addSubview:fourthInterest];
        
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 170, 80, 30)];
        ageLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        [cellBackgroundView addSubview:ageLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 170, 50, 30)];
        distanceLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
        [cellBackgroundView addSubview:distanceLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGRect subviewFrame = CGRectMake(0, 0, 300, 170);
    [profilePicture setFrame:subviewFrame];
    [profilePicture setContentMode:UIViewContentModeScaleAspectFill];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
