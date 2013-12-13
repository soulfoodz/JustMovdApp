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

+ (void)queryForPostsByUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *queryForAllPosts;
    
    queryForAllPosts = [PFQuery queryWithClassName:@"Activity"];
    [queryForAllPosts whereKey:@"type" equalTo:@"JMPost"];
    [queryForAllPosts whereKey:@"user" equalTo:user];
    [queryForAllPosts includeKey:@"checkIn"];
    queryForAllPosts.limit = 20;
    queryForAllPosts.cachePolicy = kPFCachePolicyNetworkOnly;
    [queryForAllPosts orderByDescending:@"createdAt"];
    [queryForAllPosts findObjectsInBackgroundWithBlock:^(NSArray *queryResults, NSError *error)
     {
         if (!error)
         {
             // Sort the array into descending order
             [queryResults.mutableCopy sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                 int dateOrder = [[obj2 createdAt] compare:[obj1 createdAt]];
                 return dateOrder;
             }];
             
             completionBlock(queryResults, YES);
         }
         else {
             NSLog(@"Error fetching posts : %@", error);
             completionBlock(nil, NO);
         }
     }];
}


+ (void)queryForFirstTimeChatBetweenCurrentUserWithUser:(PFUser *)user
{
    PFQuery *checkExistingConversationMeToOther = [PFQuery queryWithClassName:@"Conversation"];
    [checkExistingConversationMeToOther whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [checkExistingConversationMeToOther whereKey:@"toUser" equalTo:user];
    [checkExistingConversationMeToOther countObjectsInBackgroundWithBlock:^(int number, NSError *error)
     {
         if (number == 0)
         {
             PFObject *newMessage1 = [PFObject objectWithClassName:@"Conversation"];
             [newMessage1 setObject:[PFUser currentUser] forKey:@"fromUser"];
             [newMessage1 setObject:user forKey:@"toUser"];
             [newMessage1 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
             [newMessage1 saveInBackground];
         }
     }];
    
    PFQuery *checkExistingConversationOtherToMe = [PFQuery queryWithClassName:@"Conversation"];
    [checkExistingConversationOtherToMe whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [checkExistingConversationOtherToMe whereKey:@"fromUser" equalTo:user];
    [checkExistingConversationOtherToMe countObjectsInBackgroundWithBlock:^(int number, NSError *error)
     {
         if (number == 0)
         {
             PFObject *newMessage2 = [PFObject objectWithClassName:@"Conversation"];
             [newMessage2 setObject:[PFUser currentUser] forKey:@"toUser"];
             [newMessage2 setObject:user forKey:@"fromUser"];
             [newMessage2 setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
             [newMessage2 saveInBackground];
         }
     }];
}

+ (void)queryForProfilePictureOfUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFFile *currentUserImageFile = [user objectForKey:@"profilePictureFile"];
    [currentUserImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (error) {
            NSLog(@"Unable to retrieve profile picture");
            completionBlock(nil, NO);
        }
        else {
            UIImage *profilePicture = [UIImage imageWithData:data];
            completionBlock(@[profilePicture], YES);
        }
    }];
}

+ (void)queryForOpenConversationsByCurrentUserWithCompletionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationQuery includeKey:@"toUser"];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error) {
             NSLog(@"Error finding conversations");
             completionBlock(nil, NO);
         }
         else {
             completionBlock(objects, YES);
         }
     }];
}

+ (void)queryForLastMessageWithUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock
{
    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [messageOfCurrentUser whereKey:@"toUser" equalTo:user];
    
    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
    [messageOfUserObject whereKey:@"fromUser" equalTo:user];
    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
    
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
    [messageQuery orderByAscending:@"createdAt"];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error)
     {
         if (error) {
             NSLog(@"Error loading last message of each user");
             completionBlock(nil, NO);
         }
         else {
             completionBlock(messages, YES);
         }
         
     }];
}

+ (void)deleteConversationAndMessagesWithUser:(PFUser *)user
{
    //Query for all messages from
    PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
    [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [messageOfCurrentUser whereKey:@"toUser" equalTo:user];
    PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
    [messageOfUserObject whereKey:@"fromUser" equalTo:user];
    [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
    PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
    [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error)
     {
         [PFObject deleteAll:messages];
     }];
    
    PFQuery *conversationFromUserQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationFromUserQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationFromUserQuery whereKey:@"toUser" equalTo:user];
    PFQuery *conversationToUserQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationToUserQuery whereKey:@"fromUser" equalTo:user];
    [conversationToUserQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
    PFQuery *conversationQuery = [PFQuery orQueryWithSubqueries:@[conversationFromUserQuery, conversationToUserQuery]];
    [conversationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [PFObject deleteAll:objects];
    }];
}

+ (void)queryForMessagesWithUser:(PFUser *)user withLastFetchTime:(id)time completionBlock:(PFQueryCompletionBlock)completionBlock
{
    if (!time)
    {
        PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
        [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [messageOfCurrentUser whereKey:@"toUser" equalTo:user];
        
        PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
        [messageOfUserObject whereKey:@"fromUser" equalTo:user];
        [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
        
        PFQuery *messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:messageOfCurrentUser, messageOfUserObject, nil]];
        [messageQuery orderByAscending:@"createdAt"];
        [messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (objects.count > 0)
             {
                 if (error) {
                     NSLog(@"Error retrieve messages");
                     completionBlock(nil, NO);
                 }
                 else {
                     completionBlock(objects, YES);
                 }
             }
         }];
    }
    else
    {
        PFQuery *messageOfCurrentUser = [PFQuery queryWithClassName:@"Message"];
        [messageOfCurrentUser whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [messageOfCurrentUser whereKey:@"toUser" equalTo:user];
        
        PFQuery *messageOfUserObject = [PFQuery queryWithClassName:@"Message"];
        [messageOfUserObject whereKey:@"fromUser" equalTo:user];
        [messageOfUserObject whereKey:@"toUser" equalTo:[PFUser currentUser]];
        [messageOfUserObject orderByAscending:@"createdAt"];
        [messageOfUserObject whereKey:@"createdAt" greaterThan:time];
        [messageOfUserObject findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error) {
                 NSLog(@"Error retrieve messages");
                 completionBlock(nil, NO);
             }
             else {
                 completionBlock(objects, YES);
             }
         }];
    }
}

+ (void)saveNewMessage:(NSString *)message forUser:(PFUser *)user
{
    PFObject *messageObject = [PFObject objectWithClassName:@"Message"];
    [messageObject setObject:[PFUser currentUser] forKey:@"fromUser"];
    [messageObject setObject:user forKey:@"toUser"];
    [messageObject setObject:message forKey:@"contentText"];
    [messageObject saveInBackground];
}

+ (void)setBadgeForConversationWithUser:(PFUser *)user
{
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"fromUser" equalTo:user];
    [conversationQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [conversationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object setObject:[NSNumber numberWithInt:1] forKey:@"isShowBadge"];
        [object saveInBackground];
    }];
}

+ (void)sendPushNotificationToUsersOfPost:(PFObject *)post fromAuthor:(PFUser *)author
{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    if (![author.username isEqual:[PFUser currentUser].username]) {
        [userDict setObject:author forKey:author.username];
    }
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Activity"];
    [userQuery whereKey:@"type" equalTo:@"JMComment"];
    [userQuery whereKey:@"post" equalTo:post];
    [userQuery includeKey:@"user"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error) {
            NSLog(@"Error retriving users from post");
        }
        else {
            for (PFObject *comment in objects) {
                PFUser *user = comment[@"user"];
                if (![user.username isEqual:[PFUser currentUser].username]) {
                    [userDict setObject:user forKey:user.username];
                }
            }
            
            for (PFUser *user in [userDict allValues]) {
                NSDictionary *data;
                
                if ([user.username isEqual:author.username]) {
                    //Creating package to push
                    data = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@ commented on your post:\"%@\"", [[PFUser currentUser] objectForKey:@"firstName"], [post objectForKey:@"textContent"]], @"alert",
                            @"", @"sound",
                            @"Increment", @"badge",
                            nil];
                }
                else {
                    //Creating package to push
                    data = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@ commented on %@'s post: \"%@\"", [[PFUser currentUser] objectForKey:@"firstName"], [author objectForKey:@"firstName"], [post objectForKey:@"textContent"]], @"alert",
                            @"", @"sound",
                            @"Increment", @"badge",
                            nil];
                }
                
                //Query push to the right user
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"owner" equalTo:user];
                
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushQuery]; // Set our Installation query
                [push setData:data];
                [push sendPushInBackground];
                
                //NSLog(@"Push To: %@", user.username);
            }
        }
    }];
}

+ (void)sendPushNotificationToUser:(PFUser *)user
{
    //Creating package to push
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@ sent you a message", [[PFUser currentUser] objectForKey:@"firstName"]], @"alert",
                          @"", @"sound",
                          @"Increment", @"badge",
                          nil];
    
    //Query push to the right user
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"owner" equalTo:user];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setData:data];
    [push sendPushInBackground];
}


+ (void)removeBadgeForConversationWithUser:(PFUser *)user
{
    PFQuery *conversationQuery = [PFQuery queryWithClassName:@"Conversation"];
    [conversationQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [conversationQuery whereKey:@"toUser" equalTo:user];
    [conversationQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [object setObject:[NSNumber numberWithInt:0] forKey:@"isShowBadge"];
        [object saveInBackground];
    }];
}

@end
