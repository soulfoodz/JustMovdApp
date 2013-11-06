//
//  AboutCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/27/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "AboutEditCell.h"

@implementation AboutEditCell
@synthesize detailTextView;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width = 300;
    frame.size.height = 160;
    
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    detailTextView.editable = YES;
    detailTextView.userInteractionEnabled = YES;
    detailTextView.scrollEnabled = YES;
    //[detailTextView scrollRangeToVisible:NSMakeRange([detailTextView.text length] -1, 1)];
}

@end
