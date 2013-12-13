//
//  EditProfileDelegate.h
//  justmovdapp
//
//  Created by Kyle Mai on 12/9/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditProfileDelegate <NSObject>

- (void)updateAboutString:(NSString *)about andLocationString:(NSString *)location;

@end
