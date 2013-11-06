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
        containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 3;
        containerView.layer.masksToBounds = YES;
        
        [self addSubview:containerView];
        
        profilePicture = [[UIImageView alloc] init];
        [containerView addSubview:profilePicture];
        [profilePicture setContentMode:UIViewContentModeScaleAspectFill];
        profilePicture.clipsToBounds = YES;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 100, 30)];
        nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        [containerView addSubview:nameLabel];
        
        UILabel *matchedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 150, 30)];
        matchedLabel.text = @"Matched Interests:";
        matchedLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        [containerView addSubview:matchedLabel];
        
        firstInterest = [[UIImageView alloc] initWithFrame:CGRectMake(150, 200, 22, 22)];
        secondInterest = [[UIImageView alloc] initWithFrame:CGRectMake(180, 200, 22, 22)];
        thirdInterest = [[UIImageView alloc] initWithFrame:CGRectMake(210, 200, 22, 22)];
        fourthInterest = [[UIImageView alloc] initWithFrame:CGRectMake(240, 200, 22, 22)];
        
        [containerView addSubview:firstInterest];
        [containerView addSubview:secondInterest];
        [containerView addSubview:thirdInterest];
        [containerView addSubview:fourthInterest];
        
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 170, 80, 30)];
        ageLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        [containerView addSubview:ageLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 170, 50, 30)];
        distanceLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        [containerView addSubview:distanceLabel];

        
    }
    return self;
}

-(void)layoutSubviews{
    

    CGRect subviewFrame = CGRectMake(0, 0, 300, 170);
    profilePicture.frame = subviewFrame;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
