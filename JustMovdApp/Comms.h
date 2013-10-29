//
//  Comms.h
//  MVNote
//
//  Created by Kyle Mai on 10/26/13.
//
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