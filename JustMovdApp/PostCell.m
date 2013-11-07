//
//  PostCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/3/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PostCell.h"

#define maxContentWidth 200.0f
#define detailLabelFont [UIFont fontWithName:@"Roboto-Regular" size:15.0]

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
@synthesize delegate;
@synthesize avatarButton;
@synthesize checkInButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;

        profilePicture    = [[PFImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        //avatarButton      = [[UIButton alloc] initWithFrame:profilePicture.bounds];
        avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        checkInImage      = [[PFImageView alloc] initWithFrame:CGRectMake(5, 120, 288, 180)];
        checkInButton     = [[UIButton alloc] initWithFrame:checkInImage.bounds];
        nameLabel         = [[UILabel alloc] initWithFrame:CGRectMake(86, 10, 200, 20)];
        checkInLabel      = [UILabel new];
        timeLabel         = [UILabel new];
        detailLabel       = [UILabel new];
        commentCountLabel = [UILabel new];

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
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView                = cellBackground;
    self.backgroundView.clipsToBounds  = YES;
    self.backgroundView.frame          = CGRectMake(self.bounds.origin.x +10,
                                                    self.bounds.origin.y +5,
                                                    self.bounds.size.width -20,
                                                    self.bounds.size.height -10);
    self.backgroundView.layer.shouldRasterize = YES;
    self.backgroundView.layer.rasterizationScale = 2.0;

    
    // Set Profile pic and button on top
    profilePicture.layer.cornerRadius       = 32;
    profilePicture.userInteractionEnabled   = YES;
    profilePicture.layer.masksToBounds      = YES;
    profilePicture.contentMode              = UIViewContentModeScaleAspectFill;
    profilePicture.layer.shouldRasterize    = YES;
    profilePicture.layer.rasterizationScale = 2.0;

//    [avatarButton setFrame:profilePicture.bounds];
//    avatarButton.backgroundColor          = [UIColor redColor];
//    avatarButton.userInteractionEnabled   = YES;
//    [avatarButton addTarget:nil action:@selector(profilePictureTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20, 15, profilePicture.frame.size.width, profilePicture.frame.size.height)];
    [button addTarget:self action:@selector(profilePictureTapped) forControlEvents:UIControlEventTouchUpInside];
    //button.backgroundColor = [UIColor redColor];
    [self addSubview:button];
    [self.backgroundView addSubview:profilePicture];
    
    nameLabel.font      = [UIFont fontWithName:@"Roboto-Medium" size:17.0];
    //nameLabel.textColor = [UIColor orangeColor];
    nameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:40.0/255.0 alpha:1.0];
    [self.backgroundView addSubview:nameLabel];
    
    timeLabel.font      = [UIFont fontWithName:@"Roboto-Light" size:12.0];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.backgroundView addSubview:timeLabel];
    
    // Check for checkIn image
    if (!hasCheckIn)
        timeLabel.frame = CGRectMake(86, 32, 200, 16);
    else {
        // Move the timeLabel frame down.
        timeLabel.frame = CGRectMake(86, 48, 200, 16);
        checkInLabel.frame     = CGRectMake(86, 32, 200, 16);
        checkInLabel.font      = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        checkInLabel.textColor = [UIColor darkGrayColor];
        
        [self.backgroundView addSubview:checkInLabel];
    }
    
    CGPoint timePoint         = CGPointMake(timeLabel.frame.origin.x,
                                            timeLabel.frame.origin.y + timeLabel.frame.size.height + 10);
    CGFloat labelHeight       = [self sizeForString:detailLabel.text withFont:detailLabelFont];
    detailLabel.frame         = CGRectMake(timePoint.x, timePoint.y, maxContentWidth, labelHeight);
    detailLabel.font          = detailLabelFont;
    detailLabel.textColor     = [UIColor darkGrayColor];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.backgroundView addSubview:detailLabel];
    
    if (hasCheckIn){
        CGFloat yOrigin = (detailLabel.frame.size.height + detailLabel.frame.origin.y);
        checkInImage.frame                  = CGRectMake(6, yOrigin + 2, 288, 180);
        checkInImage.layer.shadowColor      = [UIColor blackColor].CGColor;
        checkInImage.layer.shadowOpacity    = 0.2;
        checkInImage.layer.shadowRadius     = 1.5;
        checkInImage.layer.shadowOffset     = CGSizeMake(0.0, 0.0);
        checkInImage.userInteractionEnabled = YES;
        checkInImage.contentMode            = UIViewContentModeScaleAspectFit;
        
        checkInButton.backgroundColor        = [UIColor clearColor];
        checkInButton.userInteractionEnabled = YES;
        [checkInButton addTarget:nil action:@selector(profilePictureTapped) forControlEvents:UIControlEventTouchUpInside];
        [checkInImage addSubview:checkInButton];
        
        [self.backgroundView addSubview:checkInImage];
    }
    
    if (commentCountLabel) [self setupCommentsView];
}


- (void)setupCommentsView
{
    commentView                     = [UIView new];
    commentView.frame               = CGRectMake(0, self.bounds.size.height - 40, 300.0, 30.0);
    commentView.layer.borderWidth   = 0.5;
    commentView.backgroundColor     = [UIColor colorWithRed:245.0/255.0
                                                      green:245.0/255.0
                                                       blue:245.0/255.0
                                                      alpha:1.0];
    
    commentView.layer.borderColor   = [UIColor colorWithRed:230.0/255.0
                                                      green:230.0/255.0
                                                       blue:230.0/255.0
                                                      alpha:1.0].CGColor;
    
    CGRect rect                     = commentView.bounds;
    commentCountLabel.frame         = CGRectMake(rect.origin.x +10, rect.origin.y +8, rect.size.width -10, rect.size.height /2);
    commentCountLabel.font          = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
    commentCountLabel.textColor     = [UIColor darkGrayColor];
    commentCountLabel.textAlignment = NSTextAlignmentLeft;
    
    [commentView addSubview:commentCountLabel];
    [self.backgroundView addSubview:commentView];
    
}


- (void)profilePictureTapped
{
    [delegate avatarImageWasTappedInCell:self];
    NSLog(@"Tapped");
}


- (void)checkInTapped
{
    [delegate checkInMapImageWasTappedInCell:self];
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
    checkInImage.image     = nil;
    profilePicture.image   = nil;
    nameLabel.text         = nil;
    detailLabel.text       = nil;
    commentCountLabel.text = nil;
    checkInLabel.text      = nil;
    timeLabel.text         = nil;
    hasCheckIn             = NO;
}




@end