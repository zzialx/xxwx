//
//  TR_MyViewModel.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ViewModel.h"
#import "TR_SystemInfo.h"
#import "TR_VersionModel.h"
#import "TR_SetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_MyViewModel : TR_ViewModel

@property (strong, nonatomic) NSMutableArray *titleArray;

@property (strong, nonatomic) NSMutableArray *settingArray;

@property (strong, nonatomic) NSMutableDictionary * sexDic;

@property (strong, nonatomic) NSArray *sectionTitleArray;

@property (strong, nonatomic) NSArray * infoHeadArray;

@property (strong, nonatomic) TR_UserModel * userModel;

@property (strong, nonatomic) NSArray * personArray;

@property (strong, nonatomic) TR_VersionModel  *versionModel;

@property (strong, nonatomic) TR_SetModel * setModel;

+ (instancetype)defaultMyVM;

- (void)settingWithBlock:(VoidBlock)block;//设置页面布局

- (void)getMyDataWithBlock:(BoolBlock)block; //我的信息

- (void)userMacLogin:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//用户扫描电脑端二维码登录
- (void)userMacScanLoginOut:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//用户扫描电脑端二维码登出

- (void)userScanLogin:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//用户扫描电脑端二维码成功发送接口

- (void)userLogin:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//用户登录

- (void)userLoginOut:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//用户登出

- (void)resetUserPassword:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//设置新密码

- (void)getMessageCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//更换手机号获取验证码

- (void)checkMessageCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//校验验证码

- (void)userVersion:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//查询APP最新版本信息接口

- (void)updateUserinfo:(NSDictionary*)parameters isHeadImg:(BOOL)isHeadImg completionBlock:(BoolBlock)block;//用户修改信息

- (void)modifyUserPassword:(NSDictionary *)parameter completionBlock:(BoolBlock)block; //用户修改密码

- (void)uploadImage:(NSArray *)array completionBlock:(DictionaryBlock)block;

- (void)getPersonInfoBlock:(BoolBlock)block;///<获取存储用户信息

- (void)updateUserinfoPhone:(NSDictionary*)parameters completionBlock:(BoolBlock)block;

/*获取验证码*/
- (void)getPhoneCode:(NSDictionary *)parameter completionBlock:(BoolBlock)block;//更换密码获取验证码

/*
 系统用户设置
 */
- (void)getAppSetMessageCompletionBlock:(BoolBlock)block;

/*修改系统设置*/
- (void)updateSetInfo:(NSDictionary*)parameter completionBlock:(BoolBlock)block;

/*获取文件服务器地址*/
- (void)getFileAddressUrl;
@end

NS_ASSUME_NONNULL_END
