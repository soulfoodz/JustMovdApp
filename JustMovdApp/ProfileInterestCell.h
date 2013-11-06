//
//  ProfileInterestCell.h
//  JustMovdApp
//
//  Created by Kyle Mai on 11/4/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileInterestCell : UITableViewCell
{
    UIView *backgroundView;
}

//Properties
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *firstImageView;
@property (strong, nonatomic) UIImageView *secondImageView;
@property (strong, nonatomic) UIImageView *thirdImageView;
@property (strong, nonatomic) UIImageView *fourthImageView;

@end
