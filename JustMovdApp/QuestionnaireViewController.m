//
//  QuestionnaireViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "QuestionView.h"
#import "SpinnerViewController.h"


@interface QuestionnaireViewController ()
{
    UIView *questionsHolder;

    NSArray *questions;
    NSMutableArray *answers;
    NSMutableArray *questionViewsArray;
    NSMutableArray *imagesArray;
    
    int counter;
    
    CLLocationManager *locationManager;
    
    UIImageView *firstImage;
    UIImageView *secondImage;
    UIImageView *thirdImage;
    UIImageView *fourthImage;
    NSMutableArray *bottomHolder;
    
    UIImageView *temp;
}

@end

@implementation QuestionnaireViewController

@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self getUserLocation];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"couple_blur"]];
    
    //self.view.backgroundColor = [UIColor colorWithRed:26/255.0 green:158/255.0 blue:151/255.0 alpha:1.0];
    
    answers = [NSMutableArray new];
    questionViewsArray = [NSMutableArray new];
    imagesArray = [NSMutableArray new];
    
    NSMutableDictionary *firstQuest = [[NSMutableDictionary alloc] init];
    [firstQuest setObject:@"Drink Coffee" forKey:@"first"];
    [firstQuest setObject:@"Drink Beer" forKey:@"second"];
   // [firstQuest setObject:@"Drink" forKey:@"third"];
    
    NSMutableDictionary *secondQuest = [[NSMutableDictionary alloc] init];
    [secondQuest setObject:@"Lift Weights" forKey:@"first"];
    [secondQuest setObject:@"Do Yoga" forKey:@"second"];
    //[secondQuest setObject:@"" forKey:@"third"];
    
    NSMutableDictionary *thirdQuest = [[NSMutableDictionary alloc] init];
    [thirdQuest setObject:@"Play Games" forKey:@"first"];
    [thirdQuest setObject:@"Play Sports" forKey:@"second"];
    //[thirdQuest setObject:@"Play" forKey:@"third"];

    
    NSMutableDictionary *fourthQuest = [[NSMutableDictionary alloc] init];
    [fourthQuest setObject:@"Read a Book" forKey:@"first"];
    [fourthQuest setObject:@"Watch TV" forKey:@"second"];
    
    
    questions = [[NSArray alloc] initWithObjects:firstQuest, secondQuest, thirdQuest, fourthQuest, nil];
    
    NSMutableDictionary *firstViewDict = [[NSMutableDictionary alloc] init];
    [firstViewDict setObject:@"coffee_circle" forKey:@"first"];
    [firstViewDict setObject:@"beer_size" forKey:@"second"];
    
    NSMutableDictionary *secondViewDict = [[NSMutableDictionary alloc] init];
    [secondViewDict setObject:@"weightlifting_circle" forKey:@"first"];
    [secondViewDict setObject:@"yoga_circle" forKey:@"second"];
    
    NSMutableDictionary *thirdViewDict = [[NSMutableDictionary alloc] init];
    [thirdViewDict setObject:@"vidgame_circle" forKey:@"first"];
    [thirdViewDict setObject:@"sports_circle" forKey:@"second"];
    
    NSMutableDictionary *fourthViewDict = [[NSMutableDictionary alloc] init];
    [fourthViewDict setObject:@"book" forKey:@"first"];
    [fourthViewDict setObject:@"tv" forKey:@"second"];
    
    [imagesArray addObject:firstViewDict];
    [imagesArray addObject:secondViewDict];
    [imagesArray addObject:thirdViewDict];
    [imagesArray addObject:fourthViewDict];
    
    
    counter = 0;
    
    [self makeQuestionViews];
    
    firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, self.view.frame.size.height, 40, 40)];
    secondImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, self.view.frame.size.height, 40, 40)];
    thirdImage = [[UIImageView alloc] initWithFrame:CGRectMake(180, self.view.frame.size.height, 40, 40)];
    fourthImage = [[UIImageView alloc] initWithFrame:CGRectMake(240, self.view.frame.size.height, 40, 40)];
    
    [self.view addSubview:firstImage];
    [self.view addSubview:secondImage];
    [self.view addSubview:thirdImage];
    [self.view addSubview:fourthImage];
    
    bottomHolder = [[NSMutableArray alloc] init];
    [bottomHolder addObject:firstImage];
    [bottomHolder addObject:secondImage];
    [bottomHolder addObject:thirdImage];
    [bottomHolder addObject:fourthImage];

}

-(void)getUserLocation{
    
        [locationManager startUpdatingLocation];
    
}

-(void)makeQuestionViews{
    
    questionsHolder = [[UIView alloc] initWithFrame:CGRectMake(30, 84, 320*([questions count]+1), 400)];
    [self.view addSubview:questionsHolder];
    
    int spacing = 320;
    
    QuestionView *introScreen = [[QuestionView alloc] initWithFrame:CGRectMake(0, 0, 260, 400)];
    introScreen.delegate = self;
    [questionsHolder addSubview:introScreen];
    
    for (int i = 0; i < [questions count]; i++){
        
        QuestionView *tempView = [[QuestionView alloc] initWithFrame:CGRectMake(((i*spacing)+spacing),0, 260, 400) andFirstImage:[[imagesArray objectAtIndex:i] objectForKey:@"first"] andSecondImage:[[imagesArray objectAtIndex:i] objectForKey:@"second"] andFirstQuestion:[[questions objectAtIndex:i] objectForKey:@"first"]  andSecondQuestion:[[questions objectAtIndex:i] objectForKey:@"second"]];
        
        tempView.delegate = self;

        [questionViewsArray addObject:tempView];
        [questionsHolder addSubview:tempView];
    }
    
    
}


-(void)moveView:(int)tag{
    
    temp = [bottomHolder objectAtIndex:counter];
    UIImage *image;
    
    if (tag == 0){
        image = [UIImage imageNamed:[[imagesArray objectAtIndex:counter] objectForKey:@"first"]];
    } else {
        image = [UIImage imageNamed:[[imagesArray objectAtIndex:counter] objectForKey:@"second"]];
    }
    [temp setImage:image];
    
    [UIView animateWithDuration:0.1 animations:^{
        questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, 20, 0);

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, -340, 0);
            temp.transform = CGAffineTransformMakeTranslation(0, -60);
            
        } completion:^(BOOL finished) {
            counter++;
            
            if (counter == [questions count]){
                
                SpinnerViewController *spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
                
                spinner.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
                
//                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//                activityIndicator.center = CGPointMake(self.view.frame.size.width/2, 200);
//                
                UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                coverView.backgroundColor = [UIColor grayColor];
                coverView.alpha = 0.1;
//                
                [self.view addSubview:coverView];
//                [self.view addSubview:activityIndicator];
                [self.view addSubview:spinner.view];

                
                PFObject *interests = [PFObject objectWithClassName:@"Interests"];
                interests[@"User"] = [PFUser currentUser];
                interests[@"first"] = [answers objectAtIndex:0];
                interests[@"second"] = [answers objectAtIndex:1];
                interests[@"third"] = [answers objectAtIndex:2];
                interests[@"fourth"] = [answers objectAtIndex:3];

                
                [interests saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded){
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            [delegate viewControllerDone:self];
                        }];
                        
                        spinner.view = nil;
                        
                    }
                }];
                

            }
        }];
    }];

    
}

-(void)startMove{
    
    [UIView animateWithDuration:0.1 animations:^{
        questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, 20, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            questionsHolder.transform = CGAffineTransformTranslate(questionsHolder.transform, -340, 0);
            
        }];
    }];
    
}

-(void)passBackQuestionView:(id)view withTag:(NSInteger)tag{
    
    if (tag == 0){
        [answers addObject:[[questions objectAtIndex:counter] objectForKey:@"first"]];
        //[self popupInterests:tag];
        [self moveView:tag];
    } else if(tag == 1){
        [answers addObject:[[questions objectAtIndex:counter] objectForKey:@"second"]];
        //[self popupInterests:tag];
        [self moveView:tag];
    } else if (tag == 3) {
        [self startMove];
        NSLog(@"test");
    }
    
}


-(void)popupInterests:(int)tag{
    
    UIImageView *tempView = [bottomHolder objectAtIndex:counter];
    UIImage *image;
    
    if (tag == 0){
        image = [UIImage imageNamed:[[imagesArray objectAtIndex:counter] objectForKey:@"first"]];
    } else {
        image = [UIImage imageNamed:[[imagesArray objectAtIndex:counter] objectForKey:@"second"]];
    }
    [tempView setImage:image];
    
    [UIView animateWithDuration:0.6 animations:^{
        tempView.transform = CGAffineTransformMakeTranslation(0, -40);

    }];

    
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        PFUser *user = [PFUser currentUser];
        
        PFGeoPoint *userLocation =
        [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                               longitude:currentLocation.coordinate.longitude];
        user[@"geoPoint"] = userLocation;
        
        [user saveInBackground];
        [locationManager stopUpdatingLocation];

        
    }
}



@end
