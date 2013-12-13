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
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createKeyboardToolbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [editProfileTableView setScrollEnabled:YES];
    [editProfileTableView setUserInteractionEnabled:YES];
    [editProfileTableView setBounces:YES];
}

- (void)createKeyboardToolbar
{
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    [keyboardToolbar setItems:@[cancelButton, spaceButton, saveButton]];
    [keyboardToolbar setTintColor:[UIColor orangeColor]];
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
    
    [delegate updateAboutString:aboutTextView.text andLocationString:locationTextField.text];
    
    [[PFUser currentUser] setObject:aboutTextView.text forKey:@"about"];
    [[PFUser currentUser] setObject:locationTextField.text forKey:@"location"];
    [[PFUser currentUser] saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    static NSString *aboutEditCellID = @"aboutCell";
    static NSString *otherEditCellID = @"otherCell";
    
    AboutEditCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:aboutEditCellID];
    if (!aboutCell) {
        aboutCell = [[AboutEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aboutEditCellID];
    }
    
    OtherEditCell *otherCell = [tableView dequeueReusableCellWithIdentifier:otherEditCellID];
    if (!otherCell) {
        otherCell = [[OtherEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherEditCellID];
    }
    
    UITableViewCell *cell;
    
    switch (indexPath.row)
    {
        case 0:
            aboutCell.detailTextView.text = [PFUser currentUser][@"about"];
            aboutTextView = aboutCell.detailTextView;
            aboutTextView.delegate = self;
            cell = aboutCell;
            break;
        case 1:
            otherCell.detailTextField.text = [PFUser currentUser][@"location"];
            locationTextField = otherCell.detailTextField;
            locationTextField.delegate = self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveButtonPressed];
    return YES;
}




@end
