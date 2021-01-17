//
//  TR_SelectImageModel.h
//  OASystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_SelectImageModel : TR_Model

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) BOOL editable;

@end

NS_ASSUME_NONNULL_END
