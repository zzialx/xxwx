//
//  YH_PhotoBottomActionView.h
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ALAsset;

// 底部动作条
@interface YH_PhotoBottomActionView : UIView

@property (assign, nonatomic) NSInteger imageMaxNum;

@property (copy, nonatomic) VoidBlock chooseBlock;

@property (copy, nonatomic) VoidBlock updateBlock;

- (void)updateWithAssets:(NSMutableArray *)assets;

@end


@interface YH_PhotoBottomImageCell : UICollectionViewCell

- (void)updateWithAsset:(ALAsset *)asset;

@end

@interface YH_PhotoBottomSpaceCell : UICollectionViewCell

@end
