//
//  QuestionView.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

@synthesize questionLabel1, questionLabel2, delegate;


-(id)initWithFrame:(CGRect)frame andFirstImage:(NSString*)firstImage andSecondImage:(NSString*)secondImage andFirstQuestion:(NSString*)question1 andSecondQuestion:(NSString*)question2{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        questionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, 180, 40)];
        questionLabel1.font = [UIFont fontWithName:@"Roboto-Regular" size:36];
        questionLabel1.text = question1;
        questionLabel1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel1];
        
        questionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 295, 180, 40)];
        questionLabel2.font = [UIFont fontWithName:@"Roboto-Regular" size:36];
        questionLabel2.text = question2;
        questionLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel2];
        
        UILabel *or1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 135, 60, 30)];
        or1.font = [UIFont fontWithName:@"Roboto-Regular" size:30];
        or1.text = @"O";
        or1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:or1];
        
        UILabel *or2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 235, 60, 30)];
        or2.font = [UIFont fontWithName:@"Roboto-Regular" size:30];
        or2.text = @"R";
        or2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:or2];
        
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
