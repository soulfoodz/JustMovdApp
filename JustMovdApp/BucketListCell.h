//
//  BucketListCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/12/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListCell : UITableViewCell

@property (strong, nonatomic) PFImageView *mainImage;
@property (strong, nonatomic) PFImageView *creatorAvatar;
@property (strong, nonatomic) UILabel *creatorLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *bucketNumLabel;

- (void)styleCell;
- (void)resetContents;

@end
