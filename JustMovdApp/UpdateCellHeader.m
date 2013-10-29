//
//  UpdateCellHeader.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "UpdateCellHeader.h"

@implementation UpdateCellHeader

- (id)initWithFrame:(CGRect)frame
{ 
    self = [super initWithFrame:frame];
    if (self)
    {
        [[[NSBundle mainBundle] loadNibNamed:@"UpdateCellHeader" owner:self options:nil] lastObject];
        [self addSubview:self.contentView];
    }
    return self;
}


@end
