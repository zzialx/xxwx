//
//  GVUserDefaults+Properties.h
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "GVUserDefaults.h"
NS_ASSUME_NONNULL_BEGIN

//-------------------------------------------------------------------
//声明的 object 类型的 property，请使用 weak；非 object 类型，请使用 assign
//-------------------------------------------------------------------

@interface GVUserDefaults (Properties)

@property (assign, nonatomic) BOOL loginState;//登录状态

@property (weak, nonatomic) NSString * token;

@property (weak, nonatomic) NSData *userInfo;//我的信息

@property (nonatomic) float floatValue;

@property (assign, nonatomic) BOOL noticeState;//新消息通知

@property (assign, nonatomic) BOOL showNoticeState;//通知显示消息

@property (assign, nonatomic) BOOL soundState;//声音

@property (assign, nonatomic) BOOL vibrationState;//震动

@property (assign, nonatomic) NSString * addressBookVersion;//通讯录版本

@property (assign, nonatomic) NSString *macLogin;//电脑端登录状态

@property (weak, nonatomic) NSArray * logoArray;

@property (copy, nonatomic) NSString * approveAmount;//待我审批的申请数量

@property (copy, nonatomic)NSString * updateVersionCount;///<多选通讯录版本更新次数

@property (copy, nonatomic)NSString * addressBookUpdateCount;///<通讯录版本

@property (copy, nonatomic) NSString * sginCardGroupId;///<考勤组id

@property (copy, nonatomic) NSString * badgeMesssage;//未读消息数量

@property (copy, nonatomic) NSString * fileUrl;//文件服务器地址

@property (copy, nonatomic) NSString *deviceToken;///<设备id
@end

NS_ASSUME_NONNULL_END
