//
//  CheckInLocation.m
//  JustMovdApp
//
//  Created by MacBook Pro on 11/14/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "CheckInLocation.h"

@implementation CheckInLocation

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSString *)title
{
    if (self.name)
        return self.name;
    else
        return @"unknown";
}


@end