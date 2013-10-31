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

@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background3_size.png"]];
    
    answers = [NSMutableArray new];
    questionViewsArray = [NSMutableArray new];
    imagesArray = [NSMutableArray new];
    
    NSMutableDictionary *firstQuest = [[NSMutableDictionary alloc] init];
    [firstQuest setObject:@"Coffee" forKey:@"first"];
    [firstQuest setObject:@"Beer" forKey:@"second"];
    
    NSMutableDictionary *secondQuest = [[NSMutableDictionary alloc] init];
    [secondQuest setObject:@"Lift" forKey:@"first"];
    [secondQuest setObject:@"Yoga" forKey:@"second"];
    
    NSMutableDictionary *thirdQuest = [[NSMutableDictionary alloc] init];
    [thirdQuest setObject:@"Video Games" forKey:@"first"];
    [thirdQuest setObject:@"Sports" forKey:@"second"];
    
    questions = [[NSArray alloc] initWithObjects:firstQuest, secondQuest, thirdQuest, nil];
    
    
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


}

-(void)makeQuestionViews{
    
    questionsHolder = [[UIView alloc] initWithFrame:CGRectMake(30, 60, 320*[questions count], 400)];
    [self.view addSubview:questionsHolder];
    
    int spacing = 320;
    
    for (int i = 0; i < [questions count]; i++){
        
        QuestionView *tempView = [[QuestionView alloc] initWithFrame:CGRectMake((i*spacing),0, 260, 400) andFirstImage:[[imagesArray objectAtIndex:i] objectForKey:@"first"] andSecondImage:[[imagesArray objectAtIndex:i] objectForKey:@"second"] andFirstQuestion:[[questions objectAtIndex:i] objectForKey:@"first"]  andSecondQuestion:[[questions objectAtIndex:i] objectForKey:@"second"]];
        
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

        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [delegate viewControllerDone:self];
        }];
    }

    
    
}

-(void)passBackQuestionView:(id)view withTag:(NSInteger)tag{
    
    if (tag == 0){
        [answers addObject:[[questions objectAtIndex:counter] objectForKey:@"first"]];
    } else {
        [answers addObject:[[questions objectAtIndex:counter] objectForKey:@"second"]];
    }
    
    [self moveView];
    
}




@end
