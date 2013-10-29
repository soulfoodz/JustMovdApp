//
//  PictureCell.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCell : UITableViewCell

//Outlets
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureBlur;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureOriginal;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTownLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;


//Actions, methods

@end
