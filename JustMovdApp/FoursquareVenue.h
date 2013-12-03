//
//  FoursquareVenue.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoursquareVenue : NSObject

@property (strong, nonatomic) NSString     *id;
@property (strong, nonatomic) NSString     *name;
@property (strong, nonatomic) NSString     *shortURL;
@property (strong, nonatomic) NSString     *category;
@property (strong, nonatomic) NSNumber     *stats;
@property (strong, nonatomic) NSDictionary *locationDict;
@property (strong, nonatomic) UIImage      *thumbnailImage;
@property (strong, nonatomic) UIImage      *fullImage;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@end
