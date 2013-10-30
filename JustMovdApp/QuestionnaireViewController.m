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

    NSArray *questions;
    NSMutableArray *answers;
    
    NSMutableArray *questionViewsArray;
    
    int counter;
    
    NSMutableArray *imagesArray;
}

@end

@implementation QuestionnaireViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3_size.png"]];
    
    answers = [NSMutableArray new];
    questionViewsArray = [NSMutableArray new];
    imagesArray = [NSMutableArray new];
    
    questions = @[@"Coffee Or Beer?", @"Lift Or Yoga?", @"Video Games or Sports?"];
    
    NSMutableDictionary *firstViewDict = [[NSMutableDictionary alloc] init];
    [firstViewDict setObject:@"coffee_circle" forKey:@"first"];
    [firstViewDict setObject:@"beer_size@2x" forKey:@"second"];
    
    NSMutableDictionary *secondViewDict = [[NSMutableDictionary alloc] init];
    [secondViewDict setObject:@"weightlifting_circle" forKey:@"first"];
    [secondViewDict setObject:@"yoga_circle" forKey:@"second"];
    
    NSMutableDictionary *thirdViewDict = [[NSMutableDictionary alloc] init];
    [thirdViewDict setObject:@"vidgame_circle" forKey:@"first"];
    [thirdViewDict setObject:@"sports_circle" forKey:@"second"];
    
    [imagesArray addObject:firstViewDict];
    [imagesArray addObject:secondViewDict];
    [imagesArray addObject:thirdViewDict];
    
    
    counter = 0;
    
    [self makeQuestionViews];
    
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [nextButton setTitle:@"Next View" forState:UIControlStateNormal];
//    [nextButton sizeToFit];
//    nextButton.center = CGPointMake(160, 500);
//
//    
//    [self.view addSubview:nextButton];
//    
//    [nextButton addTarget:self action:@selector(moveView) forControlEvents:UIControlEventTouchUpInside];


}

-(void)makeQuestionViews{
    
    questionsHolder = [[UIView alloc] initWithFrame:CGRectMake(30, 60, 320*[questions count], 400)];
    [self.view addSubview:questionsHolder];
    
    int spacing = 320;
    
    for (int i = 0; i < [questions count]; i++){
        
        QuestionView *tempView = [[QuestionView alloc] initWithFrame:CGRectMake((i*spacing),0, 260, 400) andFirstImage:[[imagesArray objectAtIndex:i] objectForKey:@"first"] andSecondImage:[[imagesArray objectAtIndex:i] objectForKey:@"second"] andQuestion:[questions objectAtIndex:i]];
        
        tempView.delegate = self;

        [questionViewsArray addObject:tempView];
        [questionsHolder addSubview:tempView];
    }
    
    
}


-(void)moveView{
    
    [UIView animateWithDuration:0.1 animations:^{
        questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, 20, 0);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, -340, 0);
            
        }];
    }];
    
    counter++;
    
    if (counter == [questions count]){
        
        PFObject *interests = [PFObject objectWithClassName:@"Interests"];
        interests[@"User"] = [PFUser currentUser];
        interests[@"first"] = [answers objectAtIndex:0];
        interests[@"second"] = [answers objectAtIndex:1];
        interests[@"third"] = [answers objectAtIndex:2];
        
        [interests save];

        
        [self performSegueWithIdentifier:@"done" sender:self];
    }

    
    
}

-(void)passBackQuestionView:(id)view withTag:(NSInteger)tag{
    
    if (tag == 0){
        [answers addObject:[[imagesArray objectAtIndex:counter] objectForKey:@"first"]];
    } else {
        [answers addObject:[[imagesArray objectAtIndex:counter] objectForKey:@"second"]];
    }
    
    [self moveView];
    
}




@end
