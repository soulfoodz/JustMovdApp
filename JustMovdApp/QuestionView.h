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

@property (strong, nonatomic) UILabel *questionLabel;

@property (strong, nonatomic) id <QuestionViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andFirstImage:(NSString*)firstImage andSecondImage:(NSString*)secondImage andQuestion:(NSString*)question;

@end
