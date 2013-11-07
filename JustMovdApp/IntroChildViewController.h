//
//  IntroChildViewController.h
//  JustMovd
//
//  Created by Kabir Mahal on 10/19/13.
//  Copyright (c) 2013 Tyler Mikev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroChildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *backgroundImage;
@property (strong, nonatomic) NSString *backgroundView;


@end
