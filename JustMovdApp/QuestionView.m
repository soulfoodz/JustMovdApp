//
//  QuestionView.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

@synthesize questionLabel, delegate;


-(id)initWithFrame:(CGRect)frame andFirstImage:(NSString*)firstImage andSecondImage:(NSString*)secondImage andQuestion:(NSString*)question{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 220, 40)];
        questionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:28];
        questionLabel.text = question;
        questionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.90];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setBackgroundImage:[UIImage imageNamed:firstImage] forState:UIControlStateNormal];
        
        [button1 addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        button1.tag = 0;
        
        CGRect frame1 = button1.frame;
        frame1.size.height = 110;
        frame1.size.width = 110;
        button1.frame = frame1;
        
        button1.center = CGPointMake(70, 200);
        
        [self addSubview:button1];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setBackgroundImage:[UIImage imageNamed:secondImage] forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1;


        CGRect frame2 = button2.frame;
        frame2.size.height = 110;
        frame2.size.width = 110;
        button2.frame = frame2;
        
        button2.center = CGPointMake(190, 200);
        
        [self addSubview:button2];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        
    }
    return self;
    
    
}

-(void)imageTapped:(UIButton*)sender{
    [delegate passBackQuestionView:self withTag:sender.tag];
}




@end
