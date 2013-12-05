//
//  BucketDetailCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BucketDetailCell;

@protocol BucketItemCheckButtonDataSource <NSObject>

- (void)checkButtonWasTappedInCell:(BucketDetailCell *)cell;

@end

@interface BucketDetailCell : UICollectionViewCell

@property (weak) id <BucketItemCheckButtonDataSource> delegate;

// Outlets
@property (weak, nonatomic) IBOutlet UIView      *mainView;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *creatorLabel;
@property (weak, nonatomic) IBOutlet UILabel     *quoteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet PFImageView *creatorAvatar;
@property (weak, nonatomic) IBOutlet UIButton    *checkButton;
@property (nonatomic) BOOL isSelected;


- (IBAction)checkButtonTapped:(id)sender;
- (void)setCheckButtonImageFor:(NSString *)state;
- (void)styleSubviews;
- (void)resetContents;


@end
