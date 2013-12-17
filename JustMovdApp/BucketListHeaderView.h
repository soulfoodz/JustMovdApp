//
//  BucketListHeaderView.h
//  JustMovdApp
//
//  Created by MacBook Pro on 12/17/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

- (void)styleView;

@end
