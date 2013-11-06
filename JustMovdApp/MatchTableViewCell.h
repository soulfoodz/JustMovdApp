//
//  MatchTableViewCell.h
//  JustMovdApp
//
//  Created by Kabir Mahal on 11/4/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchTableViewCell : UITableViewCell
{
    UIView *containerView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *ageLabel;
@property (strong, nonatomic) UILabel *genderLabel;
@property (strong, nonatomic) UIImageView *firstInterest;
@property (strong, nonatomic) UIImageView *secondInterest;
@property (strong, nonatomic) UIImageView *thirdInterest;
@property (strong, nonatomic) UIImageView *fourthInterest;
@property (strong, nonatomic) UILabel *distanceLabel;

@end
