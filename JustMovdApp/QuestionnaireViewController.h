//
//  QuestionnaireViewController.h
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewDelegate.h"
#import "QuestionnaireVCDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface QuestionnaireViewController : UIViewController <QuestionViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) id <QuestionnaireVCDelegate> delegate;

@end
