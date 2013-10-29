//
//  PictureCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "PictureCell.h"
#import <Accelerate/Accelerate.h>

@implementation PictureCell
@synthesize usernameLabel;
@synthesize profilePictureBlur;
@synthesize profilePictureOriginal;
@synthesize fromTownLabel;
@synthesize messageButton;



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
//    frame.origin.x = 10;
//    frame.size.width = 300;
    frame.size.height = 320;
    [super setFrame:frame];
}

- (void)layoutSubviews
{

    
}


@end
