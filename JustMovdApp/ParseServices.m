//
//  ParseServices.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/29/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "ParseServices.h"
#import <Parse/Parse.h>

@interface ParseServices()

@end

@implementation ParseServices


+ (void)queryForBucketListNear:(PFGeoPoint *)coord completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *queryForBucketList;
    
    queryForBucketList = [PFQuery queryWithClassName:@"BucketListActivity"];
    [queryForBucketList includeKey:@"creator"];
    //[queryForBucketList whereKey:@"location" nearGeoPoint:coord withinMiles:50.0];
    [queryForBucketList findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error && objects.count > 0)
            completionBlock(objects, YES);
        if (!error && objects.count == 0){
            completionBlock(objects, NO);
            NSLog(@"No objects near");
        }
        if (error){
            completionBlock(objects, NO);
            NSLog(@"Error querying for BucketList %@", error);
        }
    }];
}

+ (void)queryForBucketsCompletedByUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *queryForCompletedBuckets;
    
    queryForCompletedBuckets = [PFUser query];
    [queryForCompletedBuckets whereKey:@"username" equalTo:user.username];
    //[queryForCompletedBuckets whereKey:@"objectId" equalTo:user[@"objectId"]];
    [queryForCompletedBuckets includeKey:@"buckets"];
    [queryForCompletedBuckets findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                                                                {
                                                                    if (!error)
                                                                    {
                                                                        NSArray *buckets = objects[0][@"buckets"];
                                                                        completionBlock(buckets, YES);
                                                                    }
                                                                }];
}



@end
