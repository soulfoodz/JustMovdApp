//
//  BucketListCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/12/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "BucketListCell.h"

#define yInset 5
#define xInset 10
#define heightDiff 30
#define widthDiff 20
#define mainImageHeight 150
#define iconSize 16
#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define titleColor   [UIColor colorWithRed:80.0/255.0 green:187.0/255.0 blue:182.0/255.0 alpha:1.0]

@interface BucketListCell ()

@property (strong, nonatomic) UIImageView *distanceIcon;
@property (strong, nonatomic) UIImageView *timeIcon;

@end


@implementation BucketListCell

@synthesize bucketNumLabel;
@synthesize timeLabel;
@synthesize distanceLabel;
@synthesize titleLabel;
@synthesize mainImage;
@synthesize distanceIcon;
@synthesize timeIcon;
@synthesize creatorAvatar;
@synthesize creatorLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        
        mainImage      = [PFImageView new];
        creatorAvatar  = [PFImageView new];
        distanceIcon   = [UIImageView new];
        timeIcon       = [UIImageView new];
        bucketNumLabel = [UILabel new];
        timeLabel      = [UILabel new];
        distanceLabel  = [UILabel new];
        titleLabel     = [UILabel new];
        creatorLabel   = [UILabel new];
    }
    return self;
}


-(void)layoutSubviews
{
    UIView *cellBackground;
    CGRect cellBounds = self.bounds;
    
    cellBackground                     = [UIView new];
    cellBackground.layer.cornerRadius  = 3;
    cellBackground.layer.masksToBounds = YES;
    cellBackground.backgroundColor     = [UIColor whiteColor];
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView                = cellBackground;
    self.backgroundView.clipsToBounds  = YES;
    self.backgroundView.frame = CGRectMake(cellBounds.origin.x + xInset,
                                           cellBounds.origin.y + yInset,
                                           cellBounds.size.width - widthDiff,
                                           cellBounds.size.height - heightDiff);

    self.backgroundView.layer.shouldRasterize = YES;
    self.backgroundView.layer.rasterizationScale = 2.0;
    
    mainImage.frame     = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                     self.bounds.size.width, mainImageHeight);
    
    titleLabel.frame    = CGRectMake(10, mainImage.frame.size.height +6,
                                     280, 20);
    bucketNumLabel.frame = CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 4,
                                      280, 14);
    distanceIcon.frame  = CGRectMake(10, bucketNumLabel.frame.origin.y + bucketNumLabel.frame.size.height + 16, iconSize, iconSize);
    distanceLabel.frame = CGRectMake(distanceIcon.frame.origin.x + distanceIcon.frame.size.width + 4,
                                     distanceIcon.frame.origin.y,
                                     40, 20);
    timeIcon.frame      = CGRectMake(distanceLabel.frame.origin.x + distanceLabel.frame.size.width + 10, distanceIcon.frame.origin.y,
                                     iconSize, iconSize);
    timeLabel.frame     = CGRectMake(timeIcon.frame.origin.x + iconSize + 4, timeIcon.frame.origin.y, 70, 20);
    
    timeIcon.image       = [UIImage imageNamed:@"bucketlistcell_timeicon"];
    timeIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    distanceIcon.image       = [UIImage imageNamed:@"bucketlistcell_distanceicon"];
    distanceIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    creatorAvatar.frame  = CGRectMake(self.bounds.size.width - 70, self.backgroundView.frame.size.height+self.backgroundView.frame.origin.y - 40, 50, 50);
    creatorAvatar.contentMode = UIViewContentModeScaleAspectFill;
    creatorAvatar.layer.cornerRadius = creatorAvatar.frame.size.width/2;
    creatorAvatar.layer.borderWidth = 2.0f;
    creatorAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    creatorAvatar.clipsToBounds = YES;
    
    [self.backgroundView addSubview:timeIcon];
    [self.backgroundView addSubview:distanceIcon];
    [self.backgroundView addSubview:distanceLabel];
    [self.backgroundView addSubview:timeLabel];
    [self.backgroundView addSubview:titleLabel];
    [self.backgroundView addSubview:mainImage];
    [self.backgroundView addSubview:bucketNumLabel];
    [self addSubview:creatorAvatar];
    
    [self styleCell];
}


- (void)styleCell
{
    titleLabel.font          = titleFont;
    titleLabel.textColor     = titleColor;
    
    bucketNumLabel.font      = subtitleFont;
    bucketNumLabel.textColor = [UIColor lightGrayColor];
    
    distanceLabel.font       = detailsFont;
    distanceLabel.textColor  = [UIColor lightGrayColor];
    timeLabel.font           = detailsFont;
    timeLabel.textColor      = [UIColor lightGrayColor];
    
    mainImage.contentMode    = UIViewContentModeScaleAspectFill;
    mainImage.clipsToBounds  = YES;
}


- (void)resetContents
{
    mainImage.image     = nil;
    titleLabel.text     = nil;
    bucketNumLabel.text = nil;
    distanceLabel.text  = nil;
    timeLabel.text      = nil;
    [self styleCell];
}



@end
