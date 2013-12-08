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


+ (void)queryForCommentsForPost:(PFObject *)post completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *queryForPostComments;
    
    queryForPostComments = [PFQuery queryWithClassName:@"Activity"];
    [queryForPostComments whereKey:@"type" equalTo:@"JMComment"];
    [queryForPostComments whereKey:@"post" equalTo:post];
    [queryForPostComments includeKey:@"user"];
    [queryForPostComments orderByAscending:@"createdAt"];
    
    queryForPostComments.limit = 30;
    queryForPostComments.cachePolicy = kPFCachePolicyNetworkOnly;
    
    [queryForPostComments findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         if (!error)
         {
             completionBlock(comments, YES);
         }
         else
         {
             NSLog(@"Error fetching posts : %@", error);
             completionBlock(comments, NO);
         }
     }];
}


+ (void)queryForInterestsForUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *interestQuery;
    
    interestQuery = [PFQuery queryWithClassName:@"Interests"];
    [interestQuery includeKey:@"User"];
    [interestQuery whereKey:@"User" equalTo:user];
    [interestQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                                                        {
                                                            if (!error)
                                                            {
                                                                NSMutableArray *interests;
            
                                                                interests = [NSMutableArray new];
                                                                [interests addObject:object[@"first"]];
                                                                [interests addObject:object[@"second"]];
                                                                [interests addObject:object[@"third"]];
                                                                [interests addObject:object[@"fourth"]];
                                                                
                                                                completionBlock(interests, YES);
                                                            }
                                                         
                                                             if (error)
                                                             {
                                                                 NSLog(@"There was an error fetching interests: %@", error);
                                                                 completionBlock(nil, NO);
                                                             }
                                                        }];
}




@end
