//
//  UsersViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/23/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "UserProfileViewController.h"
#import "PictureCell.h"
#import "InfoCell.h"
#import "PostsByUserCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EditProfileViewController.h"
#import "TTTTimeIntervalFormatter.h"
#import <Accelerate/Accelerate.h>
#import "UIImage+StackBlur.h"
#import <Parse/Parse.h>

@interface UserProfileViewController ()
{
    UIBarButtonItem *spacerButton;
    UIBarButtonItem *doneButton;
    UIImage *profilePicture;
    UIImage *profilePictureBlur;
    NSMutableDictionary *userInfoDictionary;
    CGRect aboutCellHeight;
    CGRect postCellHeight;
    TTTTimeIntervalFormatter *timeFormatter;
    PFObject *selectedUserObject;
    NSMutableArray *commentCount;
    int index;
}

@end

@implementation UserProfileViewController
@synthesize userInfosArray;
@synthesize userProfileTableView;
@synthesize facebookUsername;
@synthesize editButton;

- (void)viewDidLoad
{
    facebookUsername = @"daviddeleon";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self intializeNeededStuff];
    [self retrieveUserInfoFromParse];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)intializeNeededStuff
{
    //Initialize stuff
    commentCount = [[NSMutableArray alloc] init];
    userInfoDictionary = [[NSMutableDictionary alloc] init];
    userInfoDictionary[@"name"]     = @"";
    userInfoDictionary[@"gender"]   = @"";
    userInfoDictionary[@"email"]    = @"";
    userInfoDictionary[@"about"]    = @"";
    userInfoDictionary[@"location"] = @"";
    userInfoDictionary[@"age"]      = @"";
    userInfosArray = [[NSMutableArray alloc] init];
    
    timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    
    //Move table view cell down 200 point
    //[userProfileTableView setContentInset:UIEdgeInsetsMake(220.0, 0, 0, 0)];
}

///////////////////////

- (void)retrieveUserInfoFromParse
{
    if (!facebookUsername)
    {
        [self showEditButton:YES];
        
        PFFile *imageFile = [[PFUser currentUser] objectForKey:@"profilePictureFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            profilePicture = [UIImage imageWithData:data];
            profilePictureBlur = [profilePicture stackBlur:10];
            [userProfileTableView reloadData];
        }];
        
        userInfoDictionary[@"name"]     = [[PFUser currentUser] objectForKey:@"name"];
        userInfoDictionary[@"gender"]   = [[PFUser currentUser] objectForKey:@"gender"];
        userInfoDictionary[@"email"]    = [[PFUser currentUser] objectForKey:@"email"];
        userInfoDictionary[@"about"]    = [[PFUser currentUser] objectForKey:@"about"];
        userInfoDictionary[@"location"] = [[PFUser currentUser] objectForKey:@"location"];
        
        //Convert age
        NSInteger age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[[PFUser currentUser] objectForKey:@"birthday"]];
        //////////////
        userInfoDictionary[@"age"] = [NSString stringWithFormat:@"%li", (long)age];
        
        [self retriveUserPostsAndCommentsCount];
        
        [userProfileTableView reloadData];
    }
    else
    {
        [self showEditButton:NO];
        
        PFQuery *selectedUser = [PFUser query];
        [selectedUser whereKey:@"FBUsername" equalTo:facebookUsername];
        [selectedUser getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            selectedUserObject = object;
            selectedUser.cachePolicy = kPFCachePolicyCacheThenNetwork;
            PFFile *imageFile = [object objectForKey:@"profilePictureFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                profilePicture = [UIImage imageWithData:data];
                profilePictureBlur = [profilePicture stackBlur:10];
                [userProfileTableView reloadData];
            }];
            
            userInfoDictionary[@"name"]     = [object objectForKey:@"name"];
            userInfoDictionary[@"gender"]   = [object objectForKey:@"gender"];
            userInfoDictionary[@"email"]    = [object objectForKey:@"email"];
            userInfoDictionary[@"about"]    = [object objectForKey:@"about"];
            userInfoDictionary[@"location"] = [object objectForKey:@"location"];
            
            //Convert age
            NSInteger age = [self calculateYearsFromDateStringWithFormatMMddyyyy:[object objectForKey:@"birthday"]];
            //////////////
            
            userInfoDictionary[@"age"] = [NSString stringWithFormat:@"%li", (long)age];
            
            [self retriveUserPostsAndCommentsCount];
            
            [userProfileTableView reloadData];
        }];
    }
}

- (void)retriveUserPostsAndCommentsCount
{
    if (!facebookUsername)
    {
        PFQuery *postsQuery = [PFQuery queryWithClassName:@"Activity"];
        [postsQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [postsQuery whereKey:@"type" equalTo:@"JMPost"];
        [postsQuery orderByDescending:@"createdAt"];
        [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error)
        {
            [userInfoDictionary setObject:posts forKey:@"posts"];
            
            for (int i = 0; i < [posts count]; i++)
            {
                [commentCount addObject:@"0"];
                [self retrieveCommentsForPost:i];
            }
            
            [userProfileTableView reloadData];
        }];
    }
    else
    {
        PFQuery *postsQuery = [PFQuery queryWithClassName:@"Activity"];
        [postsQuery whereKey:@"user" equalTo:selectedUserObject];
        [postsQuery whereKey:@"type" equalTo:@"JMPost"];
        [postsQuery orderByDescending:@"createdAt"];
        [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error)
        {
            [userInfoDictionary setObject:posts forKey:@"posts"];
            
            for (int i = 0; i < [posts count]; i++)
            {
                [commentCount addObject:@"0"];
                [self retrieveCommentsForPost:i];
            }
            
            [userProfileTableView reloadData];
        }];
    }
}

- (void)retrieveCommentsForPost:(int)postIndex
{
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Activity"];
    [commentQuery whereKey:@"post" equalTo:[userInfoDictionary[@"posts"] objectAtIndex:postIndex]];
    [commentQuery whereKey:@"type" equalTo:@"JMComment"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error)
     {
         [commentCount insertObject:[NSString stringWithFormat:@"%i", comments.count] atIndex:postIndex];
         [userInfoDictionary setObject:commentCount forKey:@"commentsCount"];
         [userProfileTableView reloadData];
     }];
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

- (void)showEditButton:(BOOL)state
{
    if (state) {
        [editButton setTitle:@"Edit"];
        [editButton setEnabled:state];
    }
    else {
        [editButton setTitle:@""];
        [editButton setEnabled:state];
    }
}


- (IBAction)logOutFacebook:(id)sender
{
    [PFUser logOut];
    
    // then take user back to FBLoginViewController
    [self performSegueWithIdentifier:@"FBLoginVC" sender:self];
}
///////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editProfileSegue"]) {
        EditProfileViewController *editProfileVC = segue.destinationViewController;
        editProfileVC.passInUserInfoDictionary = userInfoDictionary;
    }
}


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else
        return [userInfoDictionary[@"posts"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            return 320;
        }
        else if (indexPath.row == 1)
        {
            aboutCellHeight = [userInfoDictionary[@"about"] boundingRectWithSize:CGSizeMake(212.0, 0)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:14.0]} context:nil];
            return (aboutCellHeight.size.height < 30) ? 45.0 : (aboutCellHeight.size.height + 30);
        }
        else
        {
            return 45.0;
        }
    }
    else
    {
        NSString *textString =[userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
        
        postCellHeight = [textString boundingRectWithSize:CGSizeMake(200.0, 0)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Light" size:14.0]}
                                                         context:nil];
        
        return (postCellHeight.size.height < 30) ? 150.0 : (postCellHeight.size.height + 110);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *pictureCellID = @"pictureCell";
    static NSString *infoCellID = @"infoCell";
    static NSString *postCellID = @"postCell";
    
    PictureCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:pictureCellID];
    pictureCell.messageButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:18.0];
    pictureCell.usernameLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:20.0];
    pictureCell.fromTownLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15.0];
    [pictureCell.profilePictureBlur setContentMode:UIViewContentModeTopLeft];
    pictureCell.profilePictureBlur.layer.masksToBounds = YES;
    [pictureCell.profilePictureOriginal setContentMode:UIViewContentModeTopLeft];
    pictureCell.profilePictureOriginal.layer.masksToBounds = YES;
    [pictureCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID];
    if (!infoCell) {
        infoCell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellID];
        infoCell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
        infoCell.descriptionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14.0];
        [infoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    infoCell.descriptionLabel.numberOfLines = 0;
    infoCell.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    PostsByUserCell *postCell = [tableView dequeueReusableCellWithIdentifier:postCellID];
    if (!postCell) {
        postCell = [[PostsByUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postCellID];
        [postCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        switch (indexPath.row)
        {
            case 0:
                pictureCell.profilePictureBlur.image = profilePictureBlur ;
                pictureCell.profilePictureOriginal.image = profilePicture;
                pictureCell.usernameLabel.text = userInfoDictionary[@"name"];
                pictureCell.fromTownLabel.text = [NSString stringWithFormat:@"via %@", userInfoDictionary[@"location"]];
                cell = pictureCell;
                break;
            case 1:
                infoCell.titleLabel.text = @"About:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"about"];
                cell = infoCell;
                break;
            case 2:
                infoCell.titleLabel.text = @"Gender:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"gender"];
                cell = infoCell;
                break;
            case 3:
                infoCell.titleLabel.text = @"Age:";
                infoCell.descriptionLabel.text = userInfoDictionary[@"age"];
                cell = infoCell;
                break;
        }
    }
    else
    {
        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[userInfoDictionary[@"posts"][indexPath.row] createdAt]];
        
        postCell.profilePicture.image = profilePicture;
        postCell.nameLabel.text = userInfoDictionary[@"name"];
        postCell.timeLabel.text = timeString;
        postCell.detailLabel.text = [userInfoDictionary[@"posts"][indexPath.row] objectForKey:@"textContent"];
        if (userInfoDictionary[@"commentsCount"][indexPath.row] == nil) {
            postCell.commentCountLabel.text = @"Updating...";
        }
        else
            postCell.commentCountLabel.text = [NSString stringWithFormat:@"%@ Comments", userInfoDictionary[@"commentsCount"][indexPath.row]];
        cell = postCell;
    }
    
    return cell;
}

- (void)viewDidDisappear:(BOOL)animated
{
    facebookUsername = nil;
}




@end
