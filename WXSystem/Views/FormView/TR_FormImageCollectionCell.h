//
//  TR_FormImageCollectionCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TR_FormImageModel;

typedef void(^SWDeleteImageCompletion)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TR_FormImageCollectionCell : UICollectionViewCell
/**
 当前图片删除操作block
 */
@property (nonatomic, copy) SWDeleteImageCompletion deleteImageCompletion;

/**
 当前图片，支持UIImage、NSURL、NSString(图片URLString)类型
 */
@property (nonatomic, strong)  TR_FormImageModel *model;

@property (nonatomic, strong) UIImageView *currentImageView;

/**
 当前图片是否可编辑
 */
@property (nonatomic, assign) BOOL editable;
@end

NS_ASSUME_NONNULL_END
