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
+ (void)queryForCommentsForPost:(PFObject *)post completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForInterestsForUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForPostsByUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForFirstTimeChatBetweenCurrentUserWithUser:(PFUser *)user;
+ (void)queryForProfilePictureOfUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForOpenConversationsByCurrentUserWithCompletionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForLastMessageWithUser:(PFUser *)user completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)queryForMessagesWithUser:(PFUser *)user withLastFetchTime:(id)time completionBlock:(PFQueryCompletionBlock)completionBlock;
+ (void)deleteConversationAndMessagesWithUser:(PFUser *)user;
+ (void)saveNewMessage:(NSString *)message forUser:(PFUser *)user;
+ (void)setBadgeForConversationWithUser:(PFUser *)user;
+ (void)sendPushNotificationToUser:(PFUser *)user;
+ (void)removeBadgeForConversationWithUser:(PFUser *)user;
+ (void)sendPushNotificationToUsersOfPost:(PFObject *)post fromAuthor:(PFUser *)user;

@end
