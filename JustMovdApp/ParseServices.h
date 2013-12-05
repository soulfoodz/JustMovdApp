//
//  ParseServices.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PFQueryCompletionBlock)(NSArray *results, BOOL success);

@interface ParseServices : NSObject

+ (void)queryForBucketListNear:(PFGeoPoint *)coord completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForBucketsCompletedByUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock;

@end
