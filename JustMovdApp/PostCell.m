//
//  PostCell.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/3/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PostCell.h"

#define maxContentWidth       200.0f
#define nameLabelFont         [UIFont fontWithName:@"Roboto-Medium" size:17.0]
#define detailLabelFont       [UIFont fontWithName:@"Roboto-Regular" size:15.0]
#define checkInLabelFont      [UIFont fontWithName:@"Roboto-Regular" size:13.0]
#define commentCountLabelFont [UIFont fontWithName:@"Roboto-Regular" size:12.0]
#define timeLabelFont         [UIFont fontWithName:@"Roboto-Light" size:12.0]


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
@synthesize avatarButton;
@synthesize checkInButton;
@synthesize reportButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        profilePicture    = [[PFImageView alloc] initWithFrame:CGRectMake(10, 10, 64, 64)];
        checkInImage      = [[PFImageView alloc] initWithFrame:CGRectMake(5, 120, 288, 180)];
        nameLabel         = [[UILabel alloc] initWithFrame:CGRectMake(86, 10, 200, 20)];
        checkInLabel      = [UILabel new];
        timeLabel         = [UILabel new];
        detailLabel       = [UILabel new];
        commentCountLabel = [UILabel new];
        reportButton      = [UIButton buttonWithType:UIButtonTypeCustom];
        checkInButton     = [UIButton buttonWithType:UIButtonTypeCustom];
        avatarButton      = [UIButton buttonWithType:UIButtonTypeCustom];

        [detailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        [avatarButton addTarget:self action:@selector(profilePictureTapped) forControlEvents:UIControlEventTouchUpInside];
        [checkInButton addTarget:self action:@selector(checkInTapped) forControlEvents:UIControlEventTouchUpInside];
        [reportButton addTarget:self action:@selector(reportButtonTapped) forControlEvents:UIControlEventTouchUpInside];
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
    
    avatarButton.frame           = profilePicture.frame;
    avatarButton.backgroundColor = [UIColor clearColor];
    [self addSubview:avatarButton];
    [self.backgroundView addSubview:profilePicture];
    
    // Set nameLabel
    nameLabel.font      = nameLabelFont;
    nameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:171.0/255.0 blue:40.0/255.0 alpha:1.0];
    [self.backgroundView addSubview:nameLabel];
    
    // Set reportButton
    reportButton.frame = CGRectMake((self.backgroundView.frame.size.width + self.backgroundView.frame.origin.x) - 30, nameLabel.frame.origin.y +4, 28, 28);
    [reportButton setImage:[UIImage imageNamed:@"postcell_reportbutton_flagicon"] forState: UIControlStateNormal];
    [self addSubview:reportButton];
    
    // Set timeLabel
    timeLabel.font      = timeLabelFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.backgroundView addSubview:timeLabel];
    
    // Check for checkIn image
    if (!hasCheckIn)
        timeLabel.frame = CGRectMake(86, 32, 200, 16);
    else {
        // Move the timeLabel frame down.
        timeLabel.frame = CGRectMake(86, 48, 200, 16);
        checkInLabel.frame     = CGRectMake(86, 32, 200, 16);
        checkInLabel.font      = checkInLabelFont;
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
        checkInButton.backgroundColor       = [UIColor clearColor];
        checkInButton.frame                 = checkInImage.frame;
        checkInButton.enabled               = YES;
        [self addSubview:checkInButton];
        
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
    commentCountLabel.font          = commentCountLabelFont;
    commentCountLabel.textColor     = [UIColor darkGrayColor];
    commentCountLabel.textAlignment = NSTextAlignmentLeft;
    
    [commentView addSubview:commentCountLabel];
    [self.backgroundView addSubview:commentView];
    
}


- (void)profilePictureTapped
{
    [self.delegate avatarImageWasTappedInCell:self];
    NSLog(@"Tapped");
}


- (void)checkInTapped
{
    [self.delegate checkInMapImageWasTappedInCell:self];
    NSLog(@"Tapped");
}


- (void)reportButtonTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Report post as inappropriate", nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.delegate flagPostInCell:self];
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
    checkInButton.enabled  = NO;
    hasCheckIn             = NO;
}




@end