//
//  AddNewPostToActivityFeedDelegate.h
//  JustMovdApp
//
//  Created by MacBook Pro on 10/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@protocol AddNewPostToActivityFeedDelegate <NSObject>

- (void)addNewlyCreatedPostToActivityFeed:(PFObject *)post;
- (void)removePost:(PFObject *)post fromActivityFeedWithError:(NSError *)error;

@end
