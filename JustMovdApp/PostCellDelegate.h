//
//  PostCellDelegate.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/26/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class PostCell;

@protocol PostCellDelegate <NSObject>

- (void)avatarImageWasTappedInCell:(PostCell *)cell;
- (void)checkInMapImageWasTappedInCell:(PostCell *)cell;
- (void)flagPostInCell:(PostCell *)cell;

@end
