//
//  FBLoginViewController.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/26/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comms.h"

@interface FBLoginViewController : UIViewController <CommsDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


//Actions
- (IBAction)actionLogin:(id)sender;

@end
