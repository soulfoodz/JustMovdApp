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
    QuestionView *onScreenView;
    QuestionView *nextView;
    QuestionView *tempView;
    NSArray *questions;
    NSMutableArray *answers;
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
    
    QuestionView *view1 = [[QuestionView alloc] initWithFrame:CGRectMake(30, 60, 260, 400)];
    view1.questionLabel.text = [questions objectAtIndex:counter];
    view1.backgroundColor = [UIColor blueColor];
    onScreenFrame = view1.frame;
    

    QuestionView *view2 = [[QuestionView alloc] initWithFrame:CGRectMake(320, 60, 260, 400)];
    view2.backgroundColor = [UIColor greenColor];
    offScreenFrame = view2.frame;

    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    onScreenView = view1;
    nextView = view2;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setTitle:@"Next View" forState:UIControlStateNormal];
    [nextButton sizeToFit];
    nextButton.center = CGPointMake(160, 500);

    
    [self.view addSubview:nextButton];
    
    [nextButton addTarget:self action:@selector(moveView) forControlEvents:UIControlEventTouchUpInside];


}


-(void)moveView{
    
    counter++;
    
    tempView = onScreenView;
    nextView.questionLabel.text = [questions objectAtIndex:counter];

    
    [UIView animateWithDuration:0.2 animations:^{
        onScreenView.transform = CGAffineTransformMakeTranslation(20, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            onScreenView.transform = CGAffineTransformMakeTranslation(-500, 0);
            nextView.transform = CGAffineTransformMakeTranslation(-290, 0);
        } completion:^(BOOL finished) {
        
        }];
    }];
    

    
    
}




@end
