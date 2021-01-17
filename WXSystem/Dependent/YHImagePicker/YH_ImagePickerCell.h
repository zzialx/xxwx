//
//  YH_ImagePickerCell.h
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YH_ImagePickerCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *selectedView;

@property (strong, nonatomic) UIImageView *unselectedView;

- (void)showSelectedView:(BOOL)show;

@end
