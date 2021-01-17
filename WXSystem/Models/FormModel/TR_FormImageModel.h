//
//  TR_FormImageModel.h
//  WXSystem
//
//  Created by candy.chen on 2019/4/28.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_FormImageModel : TR_Model
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *base;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *miniurl;///<缩略图

@end

NS_ASSUME_NONNULL_END
