//
//  PostsByUserCell.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/28/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsByUserCell : UITableViewCell

//Outlets
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *commentCountLabel;

@end
