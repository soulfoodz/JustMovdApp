//
//  FoursquareServices.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VenueSearchCompletionBlock)(BOOL success, NSArray *results);

@interface FoursquareServices : NSObject

- (void)findVenuesNearLatitude:(double)latitude longitude:(double)longitude searchterm:(NSString *)searchterm completionBlock:(VenueSearchCompletionBlock)completionBlock;
- (NSURL *)URLForVenueID:(NSString *)venueID andMethod:(NSString *)method;


@end
