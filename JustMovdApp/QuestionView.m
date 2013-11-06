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
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 30)];
        topLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:25];
        topLabel.text = @"Would You Rather...";
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
        
        questionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 260, 125, 40)];
        questionLabel1.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        questionLabel1.text = question1;
        questionLabel1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel1];
        
        questionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(130, 260, 125, 40)];
        questionLabel2.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
        questionLabel2.text = question2;
        questionLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel2];
        
        UILabel *or1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 235, 60, 30)];
        or1.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        or1.text = @"OR";
        or1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:or1];
        
//        UILabel *or2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 235, 60, 30)];
//        or2.font = [UIFont fontWithName:@"Roboto-Regular" size:30];
//        or2.text = @"R";
//        or2.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:or2];
        
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

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.90];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 30)];
        topLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:25];
        topLabel.text = @"Would You Rather...";
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
        
        UILabel *firstRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 180, 20)];
        firstRow.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        firstRow.text = @"Before we get you started";
        firstRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:firstRow];
        
        UILabel *secondRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, 180, 20)];
        secondRow.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        secondRow.text = @"we want to play a little";
        secondRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:secondRow];
        
        UILabel *thirdRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, 180, 20)];
        thirdRow.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        thirdRow.text = @"game to know more about";
        thirdRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:thirdRow];
        
        UILabel *fourthRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 180, 20)];
        fourthRow.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        fourthRow.text = @"you and your interests.";
        fourthRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fourthRow];
        
        
        
        UILabel *fifthRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 190, 180, 20)];
        fifthRow.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
        fifthRow.text = @"Cool? Cool.";
        fifthRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:fifthRow];
        
        UILabel *sixthRow = [[UILabel alloc] initWithFrame:CGRectMake(40, 210, 180, 20)];
        sixthRow.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
        sixthRow.text = @"Glad we had this talk.";
        sixthRow.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sixthRow];
        
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        startButton.tag = 3;
        
        CGRect frame2 = startButton.frame;
        frame2.size.height = 110;
        frame2.size.width = 110;
        startButton.frame = frame2;
        
        startButton.center = CGPointMake(130, 300);
        
        [startButton setBackgroundImage:[UIImage imageNamed:@"letsplay"] forState:UIControlStateNormal];
        
        [startButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:startButton];

    }
    
    return self;
}


-(void)imageTapped:(UIButton*)sender{
    [delegate passBackQuestionView:self withTag:sender.tag];
}




@end
