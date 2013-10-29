//
//  ActivityFeedCellDelegate.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/26/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol ActivityFeedCellDelegate <NSObject>

- (void)avatarImageWasTappedForUser:(PFUser *)user;

@end
