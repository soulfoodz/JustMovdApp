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
        
        [self addSubview:option1];
        
        UIImageView *option2 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 140, 110, 110)];
        [option2 setImage:[UIImage imageNamed:@"coffee_circle.png"]];
        
        [self addSubview:option2];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;

        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andFirstImage:(NSString*)firstImage andSecondImage:(NSString*)secondImage andQuestion:(NSString*)question{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 200, 40)];
        questionLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:40];
        questionLabel.text = question;
        questionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.90];
        
        UIImageView *option1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 140, 110, 110)];
        [option1 setImage:[UIImage imageNamed:firstImage]];
        
        [self addSubview:option1];
        
        UIImageView *option2 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 140, 110, 110)];
        [option2 setImage:[UIImage imageNamed:secondImage]];
        
        [self addSubview:option2];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        
    }
    return self;
    
    
}




@end
