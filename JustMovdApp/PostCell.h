//
//  PostCell.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/3/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

//Outlets
@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) PFImageView *profilePicture;
@property (strong, nonatomic) PFImageView *checkInImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *commentCountLabel;
@property (strong, nonatomic) UILabel *checkInLabel;
@property (nonatomic) BOOL hasCheckIn;


- (void)resetContents;



@end
