//
//  TR_FormUserInfoDetailCell.h
//  OASystem
//
//  Created by candy.chen on 2019/4/24.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormBaseDetailCell.h"
@class SWFormItem;
NS_ASSUME_NONNULL_BEGIN

@interface TR_FormUserInfoDetailCell : TR_FormBaseDetailCell

@property (copy, nonatomic) SWFormItem *item;

+ (CGFloat)heightWithItem:(SWFormItem *)item;

@end

NS_ASSUME_NONNULL_END
