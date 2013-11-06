//
//  FBLoginViewController.h
//  MVNote
//
//  Created by Kyle Mai on 10/26/13.
//
//

#import <UIKit/UIKit.h>
#import "Comms.h"

@interface FBLoginVC : UIViewController <CommsDelegate>

//Outlets
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


//Actions
- (IBAction)actionLogin:(id)sender;


//Unwind segue
- (IBAction)unwindFBLoginViewController:(UIStoryboardSegue *)unwindSegue;

@end
