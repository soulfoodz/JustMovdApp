//
//  ConversationBubbleLeftCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/30/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "MessageBubbleLeftCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageBubbleLeftCell
@synthesize profileMiniPic;
@synthesize bubbleView;
@synthesize chatContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        profileMiniPic = [[UIImageView alloc] init];
        profileMiniPic.layer.cornerRadius = 20;
        profileMiniPic.layer.masksToBounds = YES;
        [profileMiniPic setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:profileMiniPic];
        
        bubbleView = [[UIView alloc] init];
        bubbleView.layer.cornerRadius = 2;
        bubbleView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [self addSubview:bubbleView];
        
        chatContent = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 200, 40)];
        chatContent.scrollEnabled = NO;
        chatContent.selectable = YES;
        chatContent.userInteractionEnabled = YES;
        chatContent.editable = NO;
        chatContent.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        chatContent.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        chatContent.layer.cornerRadius = 7;
        [chatContent setDataDetectorTypes:UIDataDetectorTypeLink];
        [chatContent setDataDetectorTypes:UIDataDetectorTypePhoneNumber];
        [self addSubview:chatContent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (CGFloat)heightForTextViewContainingString:(NSString*)string
{
    //float horizontalPadding = 24;
    //float verticalPadding = 16;
    float widthOfTextView = chatContent.contentSize.width; // - horizontalPadding;
    float height = [string boundingRectWithSize:CGSizeMake(widthOfTextView, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]} context:nil].size.height;// + verticalPadding;
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float textViewHeight = [self heightForTextViewContainingString:chatContent.text];
    CGSize size = [chatContent sizeThatFits:CGSizeMake(FLT_MAX, textViewHeight - 10)];
    if (size.width > 200) {
        size = [chatContent sizeThatFits:CGSizeMake(200, FLT_MAX)];
    }
    [chatContent setFrame:CGRectMake(53, self.frame.size.height - size.height - 10, size.width + 5, size.height)];
    
    [profileMiniPic setFrame:CGRectMake(5, self.frame.size.height - 45, 40, 40)];
    [bubbleView setFrame:CGRectMake(50, self.frame.size.height - 10, 4, 4)];
    
}

@end
