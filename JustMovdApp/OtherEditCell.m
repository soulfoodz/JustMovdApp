//
//  OtherEditCell.m
//  JustMovdApp
//
//  Created by Kyle Mai on 10/27/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import "OtherEditCell.h"

@implementation OtherEditCell
{
    UIView *backgroundView;
}
@synthesize titleLabel;
@synthesize detailTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 70)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.cornerRadius = 3;
        
        self.backgroundColor = [UIColor clearColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 270, 30)];
        titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:16.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"From City";
        
        detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 270, 30)];
        detailTextField.font = [UIFont fontWithName:@"Roboto-Regular" size:13.0];
        detailTextField.backgroundColor = [UIColor clearColor];
        detailTextField.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [backgroundView addSubview:titleLabel];
    [backgroundView addSubview:detailTextField];
    [self addSubview:backgroundView];
}

@end
