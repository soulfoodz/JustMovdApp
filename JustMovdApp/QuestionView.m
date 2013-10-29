//
//  QuestionView.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

@synthesize questionLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 40)];
        questionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:40];
        questionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.90];
        
        UIImageView *option1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 140, 110, 110)];
        [option1 setImage:[UIImage imageNamed:@"beer_size@2x.png"]];
        
        UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:option1 action:@selector(imageTapped)];
        [option1 addGestureRecognizer:firstTap];
        
        [self addSubview:option1];
        
        UIImageView *option2 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 140, 110, 110)];
        [option2 setImage:[UIImage imageNamed:@"coffee_circle.png"]];
        
        UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:option2 action:@selector(imageTapped)];
        [option2 addGestureRecognizer:secondTap];
        
        [self addSubview:option2];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        
    }
    return self;
}

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
        CGRect frame1 = button1.frame;
        frame1.size.height = 110;
        frame1.size.width = 110;
        button1.frame = frame1;
        
        button1.center = CGPointMake(70, 200);
        
        [self addSubview:button1];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setBackgroundImage:[UIImage imageNamed:secondImage] forState:UIControlStateNormal];

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

-(void)imageTapped{
    NSLog(@"tap: %i", self.tag);
}




@end
