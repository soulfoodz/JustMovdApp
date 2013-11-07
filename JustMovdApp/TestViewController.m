//
//  TestViewController.m
//  JustMovdApp
//
//  Created by Kabir Mahal on 10/30/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import "IntroParentViewController.h"
#import "SWRevealViewController.h"
#import "MatchTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UserProfileViewController.h"
#import "SpinnerViewController.h"



@interface TestViewController ()
{
    NSMutableArray *matches;
    NSMutableArray *profilePics;
    NSMutableArray *distances;
    NSMutableArray *sharedInterests;
    BOOL isReady;
    
    PFObject *currentUserInterests;
    PFObject *tempInterests;

    SpinnerViewController *spinner;
    
}

@end

@implementation TestViewController

@synthesize myTableView, sideBarButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    spinner = [[SpinnerViewController alloc] initWithDefaultSizeWithView:self.view];
    spinner.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner.view];
    
    
    isReady = NO;
    
    myTableView.delegate = self;
    myTableView.dataSource = self;
    matches = [[NSMutableArray alloc] init];
    profilePics = [[NSMutableArray alloc] init];
    distances = [[NSMutableArray alloc] init];
    sharedInterests = [[NSMutableArray alloc] init];
    
    sideBarButton.target = self.revealViewController;
    sideBarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self findUsersWithinMiles:20.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    


}



- (void)findUsersWithinMiles:(double)miles
{
    PFGeoPoint *currentUserLocation = [[PFUser currentUser] objectForKey:@"geoPoint"];
    PFQuery *usersQuery = [PFUser query];
    [usersQuery whereKey:@"geoPoint" nearGeoPoint:currentUserLocation withinMiles:miles];
    [usersQuery whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         matches = objects.mutableCopy;
         [self sortMatchesByDistance:matches];
         
         PFQuery *query = [PFQuery queryWithClassName:@"Interests"];
         [query whereKey:@"User" equalTo:[PFUser currentUser]];
         
         [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
             currentUserInterests = object;
             
             
             for (PFUser *temp in matches){
                 
                 
                 PFFile *imageFile = [temp objectForKey:@"profilePictureFile"];
                 [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                     
                     UIImage *tempImage = [UIImage imageWithData:data];
                     [profilePics addObject:tempImage];
                     
                     PFQuery *tempQuery = [PFQuery queryWithClassName:@"Interests"];
                     [tempQuery whereKey:@"User" equalTo:temp];
                                          
                     [tempQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                         tempInterests = object;
                         
                         
                         NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                         
                         if ([tempInterests[@"first"] isEqualToString:currentUserInterests[@"first"]]){
                             [tempArray addObject:[self getImageNameFromString:tempInterests[@"first"]]];
                         }
                         if ([tempInterests[@"second"] isEqualToString:currentUserInterests[@"second"]]){
                             [tempArray addObject:[self getImageNameFromString:tempInterests[@"second"]]];
                         }
                         if ([tempInterests[@"third"] isEqualToString:currentUserInterests[@"third"]]){
                             [tempArray addObject:[self getImageNameFromString:tempInterests[@"third"]]];
                         }
                         if ([tempInterests[@"fourth"] isEqualToString:currentUserInterests[@"fourth"]]){
                             [tempArray addObject:[self getImageNameFromString:tempInterests[@"fourth"]]];
                         }
                         [sharedInterests addObject:tempArray];
                         
                         if ([sharedInterests count] == [matches count]){
                             spinner.view = nil;
                             
                             isReady = YES;
                             [myTableView reloadData];
                         }
                         
                         
                     }];
                     
                     
                 }];
                 

             }
             
             
         }];
         
         
     }];
}

-(void)sortMatchesByDistance:(NSMutableArray*)array{
    
    PFUser *currentUser = [PFUser currentUser];
    PFGeoPoint *currentPoint = [currentUser objectForKey:@"geoPoint"];
    double lat1 = currentPoint.latitude;
    double long1 = currentPoint.longitude;
    
    for (PFUser *user in array){
        
        PFGeoPoint *tempPoint = [user objectForKey:@"geoPoint"];
        double lat2 = tempPoint.latitude;
        double long2 = tempPoint.longitude;
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        double distanceMiles = distance*0.000621371;
        
        [distances addObject:[NSNumber numberWithDouble:distanceMiles]];
    }
    
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isReady){
        return [profilePics count];
    } else {
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MatchTableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:@"blah"];
    
    if (!cell){
        cell = [[MatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blah"];
    }
 
    if (isReady){
        
        int row = [indexPath row];
        
       [cell.profilePicture setImage:[profilePics objectAtIndex:row]];
        
        PFUser *tempUser = [matches objectAtIndex:row];
        
        NSMutableArray *interestObject = [sharedInterests objectAtIndex:row];
        int len = [interestObject count];
        
        if (len == 0){
            
        } else if (len == 1){
            
            cell.firstInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:0]];
            
        } else if (len == 2){
            
            cell.firstInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:0]];
            cell.secondInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:1]];
            
        } else if (len == 3){
            
            cell.firstInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:0]];
            cell.secondInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:1]];
            cell.thirdInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:2]];
            
        } else if (len == 4){
            
            cell.firstInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:0]];
            cell.secondInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:1]];
            cell.thirdInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:2]];
            cell.fourthInterest.image = [UIImage imageNamed:[interestObject objectAtIndex:3]];
            
            
        }
        
        int age = [self calculateYearsFromDateStringWithFormatMMddyyyy:tempUser[@"birthday"]];
        
        NSString *gender;
        
        if ([tempUser[@"gender"] isEqualToString:@"male"]){
            gender = @"m";
        } else {
            gender = @"f";
        }
        
        //cell.ageLabel.text = [NSString stringWithFormat:@"%d/%@", age, gender];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@, %d/%@", tempUser[@"firstName"], age, gender];

        cell.distanceLabel.text = [NSString stringWithFormat:@"%.1fmi", [[distances objectAtIndex:row] floatValue] ];
        
        return cell;
        
    }
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat val = 250.0;
    
    return val;
    
}


- (NSInteger)calculateYearsFromDateStringWithFormatMMddyyyy:(NSString *)dateString
{
    //Convert age
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *birthday = [dateFormatter dateFromString:dateString];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    return [ageComponents year];
}


- (NSString *)getImageNameFromString:(NSString *)string
{
    if ([string isEqualToString:@"Drink Beer"]) {
        return @"beer_size@2x";
    }
    else if ([string isEqualToString:@"Lift Weights"]) {
        return @"weightlifting_circle";
    }
    else if ([string isEqualToString:@"Play Sports"]) {
        return @"sports_circle";
    }
    else if ([string isEqualToString:@"Do Yoga"]) {
        return @"yoga_circle";
    }
    else if ([string isEqualToString:@"Drink Coffee"]) {
        return @"coffee_circle";
    }
    else if ([string isEqualToString:@"Play Games"]) {
        return @"vidgame_circle";
    }
    else if ([string isEqualToString:@"Watch TV"]) {
        return @"tv";
    }
    else {
        return @"book";
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *messagesSB = [UIStoryboard storyboardWithName:@"KyleMai" bundle:nil];
    UserProfileViewController *profileVC = [messagesSB instantiateViewControllerWithIdentifier:@"profile"];
    
    profileVC.facebookUsername = ((PFUser*)[matches objectAtIndex:indexPath.row]).username;
    
    [self.navigationController pushViewController:profileVC animated:YES];
    
    
    
}




@end
