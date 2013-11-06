//
//  JMCache.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMCache : NSObject

+ (id)sharedCache;

- (void)incrementCommentCountForPost:(PFObject *)post;
- (void)decrementCommentCountForPost:(PFObject *)post;
- (NSNumber *)commentCountForPost:(PFObject *)post;
- (NSString *)keyForPost:(PFObject *)post;
- (void)removePost:(PFObject *)post;
- (void)addNewPost:(PFObject *)post;

@end
