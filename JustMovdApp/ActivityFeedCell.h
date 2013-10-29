//
//  ActivityFeedCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/24/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTTimeIntervalFormatter.h"
#import <Parse/Parse.h>
#import "ActivityFeedCellDelegate.h"

@interface ActivityFeedCell : UITableViewCell

@property (strong, nonatomic) id <ActivityFeedCellDelegate> delegate;
@property (strong, nonatomic) PFUser *user;

@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *profileImageButton;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIView *contentMainView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) PFImageView *profileImageView;
@property (strong, nonatomic) TTTTimeIntervalFormatter *timeFormatter;


+ (CGFloat)heightForCellWithContentString:(NSString *)contentString;
- (void)setContentLabelTextWith:(NSString *)contentString;
- (void)setUser:(PFUser *)user;
- (void)setDate:(NSDate *)date;
- (void)removeFooter;
- (void)didTapUserButtonAction:(UIButton *)sender;
- (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font;

@end
