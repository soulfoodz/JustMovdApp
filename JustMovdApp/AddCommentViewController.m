//
//  AddCommentViewController.m
//  JustMovdApp
//
//  Created by MacBook Pro on 10/25/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "AddCommentViewController.h"
#import "ActivityFeedViewController.h"
#import "PFImageView+ImageHandler.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textField becomeFirstResponder];
    self.postButton.enabled = NO;
    
    PFUser *user = [PFUser currentUser];
    PFFile *imageFile = user[@"profilePictureSmall"];
    
    PFImageView *avatarThumbnail = [PFImageView new];
    avatarThumbnail.frame = CGRectMake(10, 70, 44, 44);
    avatarThumbnail.layer.cornerRadius = 22.0f;
    avatarThumbnail.clipsToBounds = YES;
    [self.view addSubview:avatarThumbnail];
    
    [avatarThumbnail setFile:imageFile forImageView:avatarThumbnail];
}


- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.postButton.enabled = YES;
}


- (IBAction)postPressed:(id)sender
{
    if (self.textField.text.length == 0)
    {
        [self displayNoTextAlert];
        return;
    }
    
    //Create the post
    PFObject *newPost = [PFObject objectWithClassName:@"Activity"];

    [newPost setObject:self.textField.text forKey:@"textContent"];
    [newPost setObject:[PFUser currentUser] forKey:@"user"];
    [newPost setObject:@"JMPost" forKey:@"type"];
    
    // Send newPost to activityFeed
    [self.delegate addNewlyCreatedPostToActivityFeed:newPost];
    [self dismissViewControllerAnimated:YES completion:nil];


    // Save the post
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) [self.delegate removePost:newPost fromActivityFeedWithError:error];
    }];
}


#pragma mark - AlertView 

- (void)displayNoTextAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where's the post?" message:@"You didn't mean to post nothing did you?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    [alert show];
}






@end
