//
//  EditProfileViewController.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/27/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AboutEditCell.h"
#import "OtherEditCell.h"

@interface EditProfileViewController ()
{
    UIToolbar *keyboardToolbar;
    __strong UITextView *aboutTextView;
    __strong UITextField *locationTextField;
}

@end

@implementation EditProfileViewController
@synthesize passInUserInfoDictionary;
@synthesize editProfileTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createKeyboardToolbar];
}

- (void)createKeyboardToolbar
{
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    [keyboardToolbar setItems:@[cancelButton, spaceButton, saveButton]];
}

- (void)cancelButtonPressed
{
    [aboutTextView resignFirstResponder];
    [locationTextField resignFirstResponder];
    [editProfileTableView reloadData];
}

- (void)saveButtonPressed
{
    [aboutTextView resignFirstResponder];
    [locationTextField resignFirstResponder];
    
    [[PFUser currentUser] setObject:aboutTextView.text forKey:@"about"];
    [[PFUser currentUser] setObject:locationTextField.text forKey:@"location"];
    [[PFUser currentUser] saveInBackground];
}


#pragma mark Table View Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 160.0;
    }
    else {
        return 75.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *aboutEditCellID = @"aboutEditCell";
    static NSString *otherEditCellID = @"otherEditCell";
    
    AboutEditCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:aboutEditCellID];
    aboutCell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    aboutCell.detailTextView.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    
    OtherEditCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherEditCellID];
    otherCell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    otherCell.detailTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
    
    UITableViewCell *cell;
    
    switch (indexPath.row)
    {
        case 0:
            aboutCell.titleLabel.text = @"About";
            aboutCell.detailTextView.text = passInUserInfoDictionary[@"about"];
            aboutTextView = aboutCell.detailTextView;
            cell = aboutCell;
            break;
        case 1:
            otherCell.titleLabel.text = @"From City";
            otherCell.detailTextField.text = passInUserInfoDictionary[@"location"];
            locationTextField = otherCell.detailTextField;
            cell = otherCell;
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = keyboardToolbar;
    [textField setReturnKeyType:UIReturnKeyDone];
    
    CGRect tableViewFrame = editProfileTableView.frame;
    tableViewFrame.size.height -= 260;
    [editProfileTableView setFrame:tableViewFrame];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect tableViewFrame = editProfileTableView.frame;
    tableViewFrame.size.height += 260;
    [editProfileTableView setFrame:tableViewFrame];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView scrollRangeToVisible:NSMakeRange([textView.text length]-1, 1)];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.inputAccessoryView = keyboardToolbar;
    CGRect tableViewFrame = editProfileTableView.frame;
    tableViewFrame.size.height -= 260;
    [editProfileTableView setFrame:tableViewFrame];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect tableViewFrame = editProfileTableView.frame;
    tableViewFrame.size.height += 260;
    [editProfileTableView setFrame:tableViewFrame];
}




@end
