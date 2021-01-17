//
//  TR_UserModel.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_UserModel : TR_Model<NSCoding>

@property (copy, nonatomic) NSString *realName;//用户名字
@property (copy, nonatomic) NSString *label;//用户维修级别
@property (copy, nonatomic) NSString *mobile;//用户手机号
@property (copy, nonatomic) NSString *avatarUrl;//用户图像
@property (assign, nonatomic)NSInteger monthServer;///<服务单数
@property (copy, nonatomic)NSString *  monthReturnDegree;///<服务满意度


- (NSString *)userLogo;

@end

NS_ASSUME_NONNULL_END
