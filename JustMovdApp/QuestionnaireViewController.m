//
//  QuestionnaireViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "QuestionView.h"

@interface QuestionnaireViewController ()
{
    UIView *questionsHolder;
    
    QuestionView *onScreenView;
    QuestionView *nextView;
    //QuestionView *tempView;
    NSArray *questions;
    NSMutableArray *answers;
    
    NSMutableArray *questionViewsArray;
    CGRect onScreenFrame;
    CGRect offScreenFrame;
    
    int counter;
}

@end

@implementation QuestionnaireViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    answers = [NSMutableArray new];
    questions = @[@"First Question:", @"Second Question:", @"Third Question:", @"Fourth Question:"];
    counter = 0;
    
//    QuestionView *view1 = [[QuestionView alloc] initWithFrame:CGRectMake(30, 60, 260, 400)];
//    view1.questionLabel.text = [questions objectAtIndex:counter];
//    view1.backgroundColor = [UIColor blueColor];
//    onScreenFrame = view1.frame;
//    
//
//    QuestionView *view2 = [[QuestionView alloc] initWithFrame:CGRectMake(320, 60, 260, 400)];
//    view2.backgroundColor = [UIColor greenColor];
//    offScreenFrame = view2.frame;
//
//    
//    [self.view addSubview:view1];
//    [self.view addSubview:view2];
//    
//    onScreenView = view1;
//    nextView = view2;
    
    [self makeQuestionViews];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"Next View" forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(160, 500);

    
    [self.view addSubview:nextButton];
    
    [nextButton addTarget:self action:@selector(moveView) forControlEvents:UIControlEventTouchUpInside];


}

-(void)makeQuestionViews{
    
    questionsHolder = [[UIView alloc] initWithFrame:CGRectMake(30, 60, 320*[questions count], 400)];
    [self.view addSubview:questionsHolder];
    
    int spacing =290;
    
    for (int i = 0; i < [questions count]; i++){
        
        QuestionView *tempView = [[QuestionView alloc] initWithFrame:CGRectMake((i*spacing),0, 260, 400)];
        [questionsHolder addSubview:tempView];
    }
    
    
}


-(void)moveView{
    
    counter++;
    
    //tempView = onScreenView;
    nextView.questionLabel.text = [questions objectAtIndex:counter];

    
//    [UIView animateWithDuration:0.2 animations:^{
//        onScreenView.transform = CGAffineTransformMakeTranslation(20, 0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.8 animations:^{
//            onScreenView.transform = CGAffineTransformMakeTranslation(-500, 0);
//            nextView.transform = CGAffineTransformMakeTranslation(-290, 0);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }];
    
    [UIView animateWithDuration:0.1 animations:^{
       // questionsHolder.transform = CGAffineTransformMakeTranslation(20, 0);
        questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, 20, 0);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            //questionsHolder.transform = CGAffineTransformMakeTranslation(-290, 0);
            questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, -310, 0);
            
        }];
    }];
    
    
}




@end
