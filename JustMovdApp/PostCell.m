//
//  PostCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/3/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PostCell.h"

#define maxContentWidth 200.0f
#define detailLabelFont [UIFont fontWithName:@"Roboto-Regular" size:14.0]

@implementation PostCell

@synthesize profilePicture;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize detailLabel;
@synthesize separatorView;
@synthesize commentCountLabel;
@synthesize checkInImage;
@synthesize hasCheckIn;
@synthesize checkInLabel;
@synthesize commentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];

        profilePicture    = [[PFImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        checkInImage      = [[PFImageView alloc] initWithFrame:CGRectMake(5, 120, 288, 180)];
        nameLabel         = [[UILabel alloc] initWithFrame:CGRectMake(86, 10, 200, 20)];
        checkInLabel      = [UILabel new];
        timeLabel         = [UILabel new];
        detailLabel       = [UILabel new];
        commentCountLabel = [UILabel new];

        detailLabel.numberOfLines = 0;
        checkInImage.contentMode  = UIViewContentModeScaleAspectFit;

        [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *cellBackground;
    
    cellBackground                     = [UIView new];
    cellBackground.layer.cornerRadius  = 3;
    cellBackground.layer.masksToBounds = YES;
    cellBackground.backgroundColor     = [UIColor whiteColor];
    self.backgroundView                = cellBackground;
    self.backgroundView.clipsToBounds  = YES;
    self.backgroundView.frame          = CGRectMake(self.bounds.origin.x +10,
                                                    self.bounds.origin.y +5,
                                                    self.bounds.size.width -20,
                                                    self.bounds.size.height -10);
    
    profilePicture.layer.cornerRadius   = 32;
    profilePicture.layer.masksToBounds  = YES;
    profilePicture.contentMode          = UIViewContentModeScaleAspectFit;
    [self.backgroundView addSubview:profilePicture];
    
    nameLabel.font      = [UIFont fontWithName:@"Roboto-Medium" size:16.0];
    nameLabel.textColor = [UIColor orangeColor];
    [self.backgroundView addSubview:nameLabel];
    
    timeLabel.font      = [UIFont fontWithName:@"Roboto-Light" size:12.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    //timeLabel.frame     = CGRectMake(86, 30, 200, 16);
    [self.backgroundView addSubview:timeLabel];
    
    // Check for checkIn image
    if (!hasCheckIn){
        checkInImage = nil;
        checkInLabel = nil;
        timeLabel.frame = CGRectMake(86, 30, 200, 16);
    } else {
        // Move the timeLabel frame down.
        timeLabel.frame = CGRectMake(86, 46, 200, 16);
        checkInLabel.frame     = CGRectMake(86, 30, 200, 16);
        checkInLabel.font      = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        checkInLabel.textColor = [UIColor darkGrayColor];
        
        [self.backgroundView addSubview:checkInLabel];
    }
    
    CGPoint timePoint         = CGPointMake(timeLabel.frame.origin.x,
                                            timeLabel.frame.origin.y + timeLabel.frame.size.height + 10);
    CGFloat labelHeight       = [self sizeForString:detailLabel.text withFont:detailLabelFont];
    detailLabel.frame         = CGRectMake(timePoint.x, timePoint.y, maxContentWidth, labelHeight);
    detailLabel.font          = detailLabelFont;
    detailLabel.textColor     = [UIColor blackColor];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.backgroundView addSubview:detailLabel];
    
    if (hasCheckIn){
        CGFloat yOrigin = (detailLabel.frame.size.height + detailLabel.frame.origin.y);
        checkInImage      = [[PFImageView alloc] initWithFrame:CGRectMake(5, yOrigin + 2, 288, 180)];
        //checkInImage.frame               = CGRectMake(6, yOrigin + 2, 288, 180);
        checkInImage.layer.shadowColor   = [UIColor blackColor].CGColor;
        checkInImage.layer.shadowOpacity = 0.2;
        checkInImage.layer.shadowRadius  = 1.5;
        checkInImage.layer.shadowOffset  = CGSizeMake(0.0, 0.0);
        [self.backgroundView addSubview:checkInImage];
    }
    
    
   // CGFloat commentOriginY = detailLabel.frame.origin.y + detailLabel.frame.size.height + 10;
    commentCountLabel.frame             = CGRectMake(10, 8, 290.0, 16.0);
    commentCountLabel.font              = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    commentCountLabel.textColor         = [UIColor darkGrayColor];
    commentCountLabel.textAlignment     = NSTextAlignmentLeft;
    
    commentView                         = [UIView new];
    commentView.frame                   = CGRectMake(0, self.bounds.size.height - 40, 300.0, 30.0);
    commentView.layer.borderWidth       = 0.5;
    commentView.backgroundColor         = [UIColor colorWithRed:245.0/255.0
                                                          green:245.0/255.0
                                                           blue:245.0/255.0
                                                          alpha:1.0];

    commentView.layer.borderColor       = [UIColor colorWithRed:230.0/255.0
                                                          green:230.0/255.0
                                                           blue:230.0/255.0
                                                          alpha:1.0].CGColor;
    [commentView addSubview:commentCountLabel];
    [self.backgroundView addSubview:commentView];
    
    
    [self resizeCellBackground];
}


- (void)resizeCellBackground
{
    self.backgroundView.frame = CGRectMake(self.bounds.origin.x +10,
                                           self.bounds.origin.y +5,
                                           self.bounds.size.width -20,
                                           self.bounds.size.height - 10);
}


- (CGFloat)sizeForString:(NSString *)string withFont:(UIFont *)font
{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(maxContentWidth, 0)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:detailLabelFont}
                                           context:nil];
    int height = (int)textRect.size.height +1;
    
    return (float)height;
}


- (void)resetContents
{
    //checkInImage.image     = nil;
    profilePicture.image   = nil;
    nameLabel.text         = nil;
    detailLabel.text       = nil;
    commentCountLabel.text = nil;
    checkInLabel.text      = nil;
    timeLabel.text         = nil;
    hasCheckIn             = NO;
}


@end