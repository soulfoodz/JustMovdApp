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
#define heightDiff 10
#define widthDiff 20
#define mainImageHeight 200
#define iconSize 20
#define titleFont    [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define subtitleFont [UIFont fontWithName:@"Roboto-Regular" size:15.0]
#define detailsFont  [UIFont fontWithName:@"Roboto-Regular" size:11.0]
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
@synthesize localAvatar;
@synthesize mainImage;
@synthesize distanceIcon;
@synthesize timeIcon;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        bucketNumLabel = [UILabel new];
        timeLabel      = [UILabel new];
        distanceLabel  = [UILabel new];
        titleLabel     = [UILabel new];
        //localAvatar    = [PFImageView alloc] initWithFrame:<#(CGRect)#>;
        distanceIcon   = [UIImageView new];
        timeIcon       = [UIImageView new];
        
        CGRect cellBounds = self.frame;
        self.contentView.frame = CGRectMake(cellBounds.origin.y - xInset,
                                            cellBounds.origin.y - yInset,
                                            cellBounds.size.width - widthDiff,
                                            cellBounds.size.height - heightDiff);
        
        CGRect viewBounds = self.backgroundView.frame;
        mainImage         = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                          viewBounds.size.width, mainImageHeight)];

        titleLabel.frame    = CGRectMake(10, mainImage.frame.size.height +10,
                                         280, 16);
        bucketNumLabel.frame = CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10,
                                          280, 14);
        distanceIcon.frame  = CGRectMake(10, bucketNumLabel.frame.origin.y + bucketNumLabel.frame.size.height + 20,
                                         iconSize, iconSize);
        distanceLabel.frame = CGRectMake(distanceIcon.frame.origin.x + distanceIcon.frame.size.width + 6,
                                         distanceIcon.frame.origin.y,
                                         70, 20);
        timeIcon.frame      = CGRectMake(distanceLabel.frame.origin.x + distanceLabel.frame.size.width + 20, distanceIcon.frame.origin.y,
                                         iconSize, iconSize);
        timeLabel.frame     = CGRectMake(timeIcon.frame.origin.x + iconSize + 6, timeIcon.frame.origin.y, 70, 20);
        
        timeIcon.image       = [UIImage imageNamed:@"coffee@2x"];
        timeIcon.contentMode = UIViewContentModeScaleAspectFill;

        distanceIcon.image       = [UIImage imageNamed:@"coffee@2x"];
        distanceIcon.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:timeIcon];
        [self.contentView addSubview:distanceIcon];
        [self.contentView addSubview:distanceLabel];
        [self.contentView addSubview:timeLabel];
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:mainImage];
        [self.contentView addSubview:bucketNumLabel];
        }
    
    return self;
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
    
    mainImage.clipsToBounds  = YES;
    mainImage.contentMode    = UIViewContentModeScaleAspectFill;
    
    self.contentView.layer.cornerRadius       = 3.0f;
    self.contentView.layer.rasterizationScale = 2.0f;
    self.contentView.layer.shouldRasterize    = YES;
    self.contentView.clipsToBounds            = YES;
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)resetContents
{
    mainImage.image     = nil;
    titleLabel.text     = nil;
    bucketNumLabel.text = nil;
    distanceLabel.text  = nil;
    timeLabel.text      = nil;
}



@end
