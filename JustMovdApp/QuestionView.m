//
//  QuestionView.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

@synthesize questionLabel, answerTextField;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 40)];
        [self addSubview:questionLabel];
        
        answerTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 180, 200, 30)];
        answerTextField.borderStyle = UITextBorderStyleRoundedRect;

        [self addSubview:answerTextField];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
