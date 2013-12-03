//
//  BucketCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet PFImageView *mainImage;
@property (weak, nonatomic) IBOutlet PFImageView *creatorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)resetContents;

@end
