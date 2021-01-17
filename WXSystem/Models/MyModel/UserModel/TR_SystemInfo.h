//
//  TR_SystemInfo.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"
#import "TR_UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_SystemInfo : TR_Model

@property(nonatomic,strong)TR_UserModel *userInfo;

@property(nonatomic,assign)BOOL login;

+(instancetype)mainSystem;

- (void)removeUserInfo;

- (void)saveUserInfo:(TR_UserModel *)userInfo;
//清楚应用缓存和设置
- (void)clearApplicationConfigure;

@end

NS_ASSUME_NONNULL_END
