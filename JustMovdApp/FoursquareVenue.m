//
//  FoursquareVenue.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "FoursquareVenue.h"

@implementation FoursquareVenue

+ (FoursquareVenue *)newVenueFromBucket:(PFObject *)bucket
{
    FoursquareVenue *newVenue;
    PFGeoPoint      *geopoint;
    
    geopoint = bucket[@"location"];
    
    newVenue = [FoursquareVenue new];
    
    newVenue.id         = bucket[@"FSVenueID"];
    newVenue.name       = bucket[@"title"];
    newVenue.category   = bucket[@"category"];
    newVenue.url        = bucket[@"website"];
    newVenue.address    = bucket[@"streetAddress"];
    newVenue.city       = bucket[@"city"];
    newVenue.state      = bucket[@"state"];
    newVenue.postalCode = bucket[@"postalCode"];
    newVenue.phone      = bucket[@"phone"];
    newVenue.fullImage  = bucket[@"image"];
    newVenue.coordinate = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude);
    
    return newVenue;
}


- (NSString *)title
{
    if (self.name)
        return self.name;
    else
        return @"unknown";
}




@end
