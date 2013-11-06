//
//  QuestionView.h
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewDelegate.h"

@interface QuestionView : UIView

@property (strong, nonatomic) UILabel *questionLabel1;
@property (strong, nonatomic) UILabel *questionLabel2;

@property (strong, nonatomic) id <QuestionViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andFirstImage:(NSString*)firstImage andSecondImage:(NSString*)secondImage andFirstQuestion:(NSString*)question1 andSecondQuestion:(NSString*)question2;

@end
