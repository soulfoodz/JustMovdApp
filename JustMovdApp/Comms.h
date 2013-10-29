//
//  Comms.h
//  JustMovdApp
//
//  Created by Kyle Mai on 10/26/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@protocol CommsDelegate <NSObject>

@optional

- (void) commsDidLogin:(BOOL)loggedIn;

@end


@interface Comms : NSObject

+ (void) login:(id<CommsDelegate>)delegate;

@end