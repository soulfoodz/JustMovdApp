//
//  BucketDetailCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketDetailCell : UICollectionViewCell

// Outlets
@property (weak, nonatomic) IBOutlet UIView      *mainView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel     *quoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet PFImageView *creatorAvatar;

- (void)styleSubviews;
- (void)resetContents;

@end
