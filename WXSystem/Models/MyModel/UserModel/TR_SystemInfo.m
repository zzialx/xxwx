//
//  TR_SystemInfo.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SystemInfo.h"

@implementation TR_SystemInfo

+(instancetype)mainSystem
{
    static TR_SystemInfo *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[self alloc] init];
    });
    return manage;
}

- (TR_UserModel *)userInfo
{
    if (!_userInfo) {
        NSData *data = [GVUserDefaults standardUserDefaults].userInfo;
        if (data) {
             _userInfo = (TR_UserModel*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _userInfo;
}

- (void)setLogin:(BOOL)login
{
    [GVUserDefaults standardUserDefaults].loginState = login;
}

- (BOOL)login
{
    return [GVUserDefaults standardUserDefaults].loginState;
}

- (void)saveUserInfo:(TR_UserModel *)userInfo
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [GVUserDefaults standardUserDefaults].userInfo = data;
    self.userInfo = userInfo;
}

- (void)removeUserInfo
{
    [GVUserDefaults standardUserDefaults].userInfo = nil;
}

- (void)clearApplicationConfigure{
    [GVUserDefaults standardUserDefaults].token = @"";
    //角标设置为0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //移除别名
    [UMessage removeAlias:[GVUserDefaults standardUserDefaults].deviceToken type:@"NLX_ALIAS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
    }];
}
@end
