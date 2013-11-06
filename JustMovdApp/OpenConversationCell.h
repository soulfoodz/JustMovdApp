//
//  OpenConversationCell.h
//  JustMovdApp
//
//  Created by Kyle Mai on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenConversationCell : UITableViewCell
{
    UIView *backgroundView;
    UILabel *newBadgeLabel;
}

//Outlets
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property int isNew;


@end
