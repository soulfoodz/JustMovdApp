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

@synthesize profilePicture, nameLabel, ageLabel, genderLabel, firstInterest, secondInterest, thirdInterest, fourthInterest;

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
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 100, 30)];
        nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        [containerView addSubview:nameLabel];
        
        firstInterest = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 22, 22)];
        secondInterest = [[UIImageView alloc] initWithFrame:CGRectMake(40, 200, 22, 22)];
        thirdInterest = [[UIImageView alloc] initWithFrame:CGRectMake(70, 200, 22, 22)];
        fourthInterest = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 22, 22)];
        
        [containerView addSubview:firstInterest];
        [containerView addSubview:secondInterest];
        [containerView addSubview:thirdInterest];
        [containerView addSubview:fourthInterest];

        
        
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
