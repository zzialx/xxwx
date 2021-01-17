//
//  YH_PhotoPickerCell.h
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YH_PhotoPickerCell : UICollectionViewCell

@property (copy, nonatomic) ObjectBlock selectBlock;

- (void)updateWithImage:(UIImage *)image index:(NSUInteger)index;

- (void)updateCellSelection:(BOOL )isSelected index:(NSUInteger)index;

@end
