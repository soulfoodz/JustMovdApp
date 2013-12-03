//
//  FoursquareServices.m
//  JustMovdApp
//
//  Created by MacBook Pro on 12/2/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "FoursquareServices.h"
#import "FoursquareVenue.h"

#define clientID         @"A0AKK13MEKX0CZSQRSBWYH0VJNX14Z5PDPBLEANV3C3UOJJD"
#define clientSecret     @"VRSNGK3DX5AQCZ4XGN3RCEUXFHCGJFSMX1LW0TAWCE45O4MR"
#define fsVenuesURL      @"https://api.foursquare.com/v2/venues/"
#define fsApiVersion     @"20131016"
#define venueLimit       10
#define thumbnailSize    @"100x100"
#define fullImageSize    @"500x500"

@implementation FoursquareServices


// Get a URL request for venues with location, limit, and query params
- (NSURLRequest *)foursquareURLRequestForVenuesNearLatitude:(double)latitude longitude:(double)longitude limit:(int)limit searchTerm:(NSString *)searchTerm
{
    NSString        *urlString;
    NSURL           *searchURL;
    NSURLRequest    *urlRequest;
    NSString        *method;
    
    method     = @"search?";
    urlString  = [NSString stringWithFormat:@"%@%@ll=%f%f&limit=%d&query=%@&client_id=%@&client_secret=%@&v=%@", fsVenuesURL, method, latitude, longitude, limit, searchTerm, clientID, clientSecret, fsApiVersion];
    searchURL  = [NSURL URLWithString:urlString];
    urlRequest = [NSURLRequest requestWithURL:searchURL];
    
    return urlRequest;
}


- (NSURL *)getURLForVenueWithID:(NSString *)venueID
{
    NSString     *urlString;
    NSURL        *URL;
    
    urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?&client_id=%@&client_secret=%@&v=%@", venueID, clientID, clientSecret, fsApiVersion];
    URL       = [NSURL URLWithString:urlString];
    
    return URL;
}


- (void)getInfoForVenueWithID:(NSString *)venueID completionBlock:(VenueSearchCompletionBlock)completionBlock;
{
    NSURL        *url;
    NSURLRequest *urlRequest;
    
    url        = [self getURLForVenueWithID:venueID];
    urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSDictionary    *dataDict;
                               NSDictionary    *venueDict;
                               FoursquareVenue *newVenue;
                               NSString        *latString;
                               NSString        *lngString;
                               NSArray         *venue;
                               
                               dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&connectionError];
                               
                               // If there's an error, send back the completion block with the error
                               // Else, pull out the data
                               if (connectionError) completionBlock(NO, nil);
                               
                               // Get the dict containing all the venues info
                               venueDict = dataDict[@"response"][@"venue"];
                               newVenue  = [FoursquareVenue new];
                            
                               // Pull out simple values
                               newVenue.id          = venueDict[@"id"];
                               newVenue.name        = venueDict[@"name"];
                               newVenue.address     = venueDict[@"location"][@"address"];
                               newVenue.city        = venueDict[@"location"][@"city"];
                               newVenue.postalCode  = venueDict[@"location"][@"postalCode"];
                               newVenue.category    = venueDict[@"categories"][0][@"name"];
                               newVenue.phone       = venueDict[@"contact"][@"formattedPhone"];
                               newVenue.url         = venueDict[@"url"];
                               
                               // Pull out the longitude and latitude values
                               lngString            = (NSString *)venueDict[@"location"][@"lng"];
                               newVenue.lng         = lngString.floatValue;
                               
                               latString            = (NSString *)venueDict[@"location"][@"lat"];
                               newVenue.lng         = latString.floatValue;
                               
                               venue = @[newVenue];
                               
                               completionBlock(YES, venue);
                        }];
}


- (void)findVenuesNearLatitude:(double)latitude longitude:(double)longitude searchterm:(NSString *)searchterm completionBlock:(VenueSearchCompletionBlock)completionBlock
{
    NSURLRequest *urlRequest;
    
    urlRequest = [self foursquareURLRequestForVenuesNearLatitude:latitude
                                                       longitude:longitude
                                                           limit:venueLimit
                                                      searchTerm:searchterm];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSDictionary   *dataDict;
                               NSArray        *venuesArray;
                               NSMutableArray *venues;
                               
                               dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&connectionError];
                               
                               // If there's an error, send back the completion block with the error
                               // Else, pull out the data
                               if (connectionError) completionBlock(NO, nil);
                               
                               venuesArray = dataDict[@"response"][@"venues"];
                               venues      = [NSMutableArray new];
                               
                               // for each venue in the array, create a FoursquareVenue object
                               for (id venue in venuesArray)
                               {
                                   FoursquareVenue *newVenue;
                                   
                                   newVenue              = [FoursquareVenue new];
                                   newVenue.id           = venue[@"id"];
                                   newVenue.name         = venue[@"name"];
                                   newVenue.url          = venue[@"shortURL"];
                                   newVenue.category     = venue[@"categories"][@"shortName"];
                                   //newVenue.latitude = venue[@"location"][@"lat"];
                                   //newVenue.longitude = venue[@"location"][@"lng"];
                                   
                                   [venues addObject:newVenue];
                                }
                               
                               completionBlock(YES, venues);
                           }];
    
}


- (NSURL *)photoSourceURLForVenueID:(NSString *)venueID
{
    NSURL    *photoURL;
    NSString *urlString;
    
    urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?&client_id=%@&client_secret=%@&v=%@", venueID,clientID, clientSecret, fsApiVersion];
    photoURL  = [NSURL URLWithString:urlString];
    
    return photoURL;
}

- (void)getImagesForVenue:(NSString *)venueID withSize:(NSString *)imageSize completionBlock:(VenueSearchCompletionBlock)completionBlock
{
    NSURL        *photoURL;
    NSURLRequest *urlRequest;
    
    photoURL   = [self photoSourceURLForVenueID:venueID];
    urlRequest = [NSURLRequest requestWithURL:photoURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               NSDictionary   *dataDict;
                               NSArray        *photosArray;
                               NSMutableArray *photos;
                               
                               dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&connectionError];
                               
                               // If there's an error, send back the completion block with the error
                               // Else, pull out the data
                               if (connectionError) completionBlock(NO, nil);
                               
                               photosArray = dataDict[@"response"][@"photos"][@"items"];
                               photos      = [NSMutableArray arrayWithCapacity:5];
                            
                               for (id photo in photosArray)
                               {
                                   NSString *urlString;
                                   NSURL    *imageURL;
                                   NSData   *imageData;
                                   
                                   // Find a photo taken with instagram
                                   if (![photo[@"source"][@"name"] isEqualToString:@"Instagram"]) continue;
                                   
                                   // See below about this URL setup
                                   urlString = [NSString stringWithFormat:@"%@%@%@", photo[@"prefix"], imageSize, photo[@"suffix"]];
                                   imageURL  = [NSURL URLWithString:urlString];
                                   imageData = [NSData dataWithContentsOfURL:imageURL];
                                   
                                   if (photos.count < 5)
                                       [photos addObject:imageData];
                                   else
                                       break;
                                }
                               
                               completionBlock(YES, photos);
                        }];
    /*
     To avoid having to resize, we're just going to grab photos whose [@"source"][@"name"] == @"Instagram"
     
     To assemble a resolvable photo URL, take prefix + size + suffix, e.g. https://irs0.4sqi.net/img/general/300x500/2341723_vt1Kr-SfmRmdge-M7b4KNgX2_PHElyVbYL65pMnxEQw.jpg.
     
     size can be one of the following, where XX or YY is one of 36, 100, 300, or 500.
     XXxYY
     original: the original photo's size
     capXX: cap the photo with a width or height of XX (whichever is larger). Scales the other, smaller dimension proportionally
     widthXX: forces the width to be XX and scales the height proportionally
     heightYY: forces the height to be YY and scales the width proportionally
     
     To get the image url, we need the [@"prefix"] and [@"width"] x [@"height"] and [@"suffix"];
     
     */
}


@end
