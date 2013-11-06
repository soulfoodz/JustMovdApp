//
//  JMCache.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "JMCache.h"

@interface JMCache()

@property (strong, nonatomic) NSCache *cache;


@end


@implementation JMCache

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PAPCache

- (void)clear {
    [self.cache removeAllObjects];
}


- (void)incrementCommentCountForPost:(PFObject *)post
{
    NSString *key = [self keyForPost:post];
    NSNumber *count = [self.cache objectForKey:key];
    int newCount = [count intValue] + 1;
    NSNumber *newNum = [NSNumber numberWithInt:newCount];
    [self.cache setObject:newNum forKey:key];
}


- (void)decrementCommentCountForPost:(PFObject *)post
{
    NSString *key = [self keyForPost:post];
    NSNumber *count = [self.cache objectForKey:key];
    int newCount = [count intValue] - 1;
    NSNumber *newNum = [NSNumber numberWithInt:newCount];
    [self.cache setObject:newNum forKey:key];
}


- (NSNumber *)commentCountForPost:(PFObject *)post
{
    NSString *key = [self keyForPost:post];
    return [self.cache objectForKey:key];
}


- (void)addNewPost:(PFObject *)post
{
    NSString *key = [self keyForPost:post];
    NSNumber *commentCount = [NSNumber numberWithInt:0];
    [self.cache setObject:commentCount forKey:key];
}


- (void)removePost:(PFObject *)post
{
    NSString *key = [self keyForPost:post];
    [self.cache removeObjectForKey:key];
}


- (NSString *)keyForPost:(PFObject *)post
{
    return [NSString stringWithFormat:@"post_%@", [post objectId]];
}


@end
