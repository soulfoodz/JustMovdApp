//
//  ActivityFeedCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/24/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ActivityFeedCell.h"
#import "PFImageView+ImageHandler.h"


#define maxContentWidth 290.0f
#define avatarSpacing 6.0f
#define nameOriginX (avatarSpacing + self.profileImageView.frame.size.width + 10.0f)
#define dateOriginX (avatarSpacing + self.profileImageView.frame.size.width + 10.0f)
#define headerInsetY 6.0f
#define headerViewHeight 56.0f
#define footerViewHeight 40.0f
#define contentLabelInset 6.0f

#define contentFontWithSize [UIFont fontWithName:@"Roboto-Regular" size:13.0]


#define CELL_HEIGHT (CGFloat)(self.headerView.frame.size.height + self.contentView.size.height + self.footerView.size.height)



@implementation ActivityFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        UIButton *commentIconButton;
        UIImage *commentIcon;
        
        self.headerView      = [UIView new];
        self.contentMainView = [UIView new];
        self.footerView      = [UIView new];
        self.contentLabel    = [UILabel new];
        self.dateLabel       = [UILabel new];
        self.nameLabel       = [UILabel new];
        self.profileImageView    = [PFImageView new];
        
        // self.backgroundColor = [UIColor redColor];
        
        // Setup the nameLabel
        self.nameLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15.0];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.numberOfLines = 1;
        [self.headerView addSubview:self.nameLabel];
        
        // Setup the dateLabel
        self.dateLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:11.0];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.numberOfLines = 1;
        [self.headerView addSubview:self.dateLabel];
        
        // Setup the contentLabel
        self.contentLabel.font = contentFontWithSize;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.numberOfLines = 0;
        [self.contentMainView addSubview:self.contentLabel];
        
        // Setup the profileImage
        self.profileImageView.backgroundColor = [UIColor clearColor];
        self.profileImageView.layer.cornerRadius = 22.0f;
        self.profileImageView.clipsToBounds = YES;
        [self.headerView addSubview:self.profileImageView];
        
        
        // Setup the profileImageButton
        self.profileImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.profileImageButton.backgroundColor = [UIColor clearColor];
        self.profileImageButton.userInteractionEnabled = NO;
        [self.profileImageButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.profileImageButton];
        
        // Setup the headerView
        self.headerView.frame = CGRectMake(0, 0, 320, headerViewHeight);
        [self.contentView addSubview:self.headerView];
        self.headerView.backgroundColor = [UIColor whiteColor];

        commentIcon = [UIImage imageNamed:@"activityfeedcell_icon_comment"];
        commentIconButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 18, 18)];
        [commentIconButton setBackgroundImage:commentIcon forState:UIControlStateNormal];
        
        [self.footerView addSubview:commentIconButton];
        [self.contentView addSubview:self.footerView];
        self.footerView.backgroundColor = [UIColor whiteColor];
        self.contentMainView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.contentMainView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //* Set profileImageView
    self.profileImageView.frame = CGRectMake(6, headerInsetY, 44, 44);
    self.profileImageButton.frame = CGRectMake(6, headerInsetY, 44, 44);
    
    //* Set nameLabel
    CGSize nameSize = [self sizeForString:self.nameLabel.text withFont:self.nameLabel.font];
    self.nameLabel.frame = CGRectMake(nameOriginX, headerInsetY, nameSize.width, nameSize.height);
    
    //* Set dateLabel
    CGSize dateSize = [self sizeForString:self.dateLabel.text withFont:self.dateLabel.font];
    self.dateLabel.frame = CGRectMake(nameOriginX, headerInsetY + nameSize.height + 4, dateSize.width, dateSize.height);
    
    //* Set contentLabel
    CGSize contentSize = [self sizeForString:self.contentLabel.text withFont:self.contentLabel.font];
    self.contentLabel.frame = CGRectMake(10, contentLabelInset, contentSize.width, contentSize.height);
    self.contentMainView.frame = CGRectMake(0, self.headerView.frame.size.height, 320, contentSize.height + contentLabelInset);
    
    // Set footerView.frame
    self.footerView.frame = CGRectMake(0, self.contentMainView.frame.size.height + self.headerView.frame.size.height, 320, footerViewHeight);
}


//+ (CGFloat)heightForCellWithContentString:(NSString *)contentString
//{
//    CGSize contentSize = [contentString sizeWithFont:contentFontWithSize
//                                   constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
//                                       lineBreakMode:NSLineBreakByWordWrapping];
//
//    CGFloat cellHeight = (contentSize.height + headerViewHeight + footerViewHeight);
//    return cellHeight;
//}


- (void)setUser:(PFUser *)user
{

   // self.profileImageView.image = [UIImage imageNamed:@"AvatarPlaceholder.png"];

    PFFile *imageFile = user[@"profilePictureSmall"];
    [self.profileImageView setFile:imageFile forImageView:self.profileImageView];
    
    // Activate profileImageButton
    self.profileImageButton.userInteractionEnabled = YES;

    self.nameLabel.text = [user objectForKey:@"username"];
}


- (void)setContentLabelTextWith:(NSString *)contentString
{
    //CGSize contentSize = [self sizeForString:contentString withFont:contentFontWithSize];
    
    self.contentLabel.text = contentString;
}

- (void)removeFooter
{
    if (self.footerView)
    {
        NSArray *subViews = [self.footerView subviews];
        [subViews respondsToSelector:@selector(removeFromSuperview)];
        [self.footerView removeFromSuperview];
    }
}


- (void)setDate:(NSDate *)date
{
    if (!date) {
        date = [NSDate date];
    }
    NSString *dateString = [self.timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:date];

    CGSize dateSize = [self sizeForString:dateString withFont:self.dateLabel.font];
    self.dateLabel.frame = CGRectMake(nameOriginX, headerInsetY + self.nameLabel.frame.size.height + 4, dateSize.width, dateSize.height);
    
    // Set the label with a human readable time
    self.dateLabel.text = dateString;
}


- (void)didTapUserButtonAction:(UIButton *)sender
{
    [self.delegate avatarImageWasTappedForUser:self.user];
}


- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width = 300;
    [super setFrame:frame];
}


- (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGSize size = [string sizeWithFont:font
                     constrainedToSize:CGSizeMake(maxContentWidth, CGFLOAT_MAX)
                         lineBreakMode:NSLineBreakByWordWrapping];
    
    return size;
}





@end
