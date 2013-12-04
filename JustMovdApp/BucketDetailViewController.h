//
//  BucketDetailViewController.h
//  JustMovdApp
//
//  Created by MacBook Pro on 11/13/13.
//  Copyright (c) 2013 Kabir Mahal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BucketDetailCell.h"

@interface BucketDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,BucketItemCheckButtonDataSource>

@property (strong, nonatomic) PFObject       *bucket;
@property (strong, nonatomic) NSMutableArray *photosArray;
@property (nonatomic) BOOL isChecked;

@end
