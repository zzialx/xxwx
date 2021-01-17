//
//  CommonMacro.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h


#define SCREEN_MAX_LENGTH (MAX(KScreenWidth, KScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(KScreenWidth, KScreenHeight))

#define MarginFactor(x) floorf(KScreenWidth / 375.0f * x)

#define STATUS_BAR_HEIGHT  ((IS_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) ? 44.f : 20.f)        //状态栏高度
//屏幕 rect
#define KScreenRect    [UIScreen mainScreen].bounds
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define KNAV_HEIGHT     ([[UIApplication sharedApplication] statusBarFrame].size.height + NAVIGATION_BAR_HEIGHT)

#define KNAV_STATUS_HEIGHT     [[UIApplication sharedApplication] statusBarFrame].size.height

#define STATUS_TABBAT_HEIGHT  ((IS_iPhoneX || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) ? 83.f : 49.f)        //状态栏高度


#define MAP_KEY            @"6944a516bf00bc54add8482e44bf6737" //地图key
#define UM_KEY             @"5def4c263fc1956e8c000745" //友盟key

#define BACK_GRAY   @"back_gray"
#define BACK_WHITE   @"back_white"

#define NAVIGATION_BAR_HEIGHT 44 //NavBar高度

#define kSafeAreaTopHeight         (KScreenHeight >= 812.0 ? 24 : 0)
#define kSafeAreaBottomHeight       (KScreenHeight >= 812.0 ? 20 : 0)

#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT)) //状态栏 ＋ 导航栏 高度

#define LEFT_VIEW   16  //间距

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self
#define SS(strongSelf) __strong __typeof(&*weakSelf)strongSelf = weakSelf
//登录的手机号
#define LOGIN_PHONE    @"login_phone"
//通讯录版本号
#define ADDRESSBOOK_VERSION  @"addressBook_version"
//通讯录更新次数
#define ADDRESSBOOK_UPDATE_COUNT  @"addressBook_update_count"
//添加删除标志位
#define AddDelState(_ref)  [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:_ref];
//移除删除标志位
#define RemoveDelState(_ref)  [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:_ref];
//获取删除状态
#define IsDelState(_ref)   [[[NSUserDefaults standardUserDefaults] objectForKey:_ref] boolValue];
//空判断
#define IsNilOrNull(_ref)           (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define IsDictionaryClass(_ref)     (!IsNilOrNull(_ref) && ([(_ref) isKindOfClass:[NSDictionary class]]))

#define IsArrayClass(_ref)          (!IsNilOrNull(_ref) && ([(_ref) isKindOfClass:[NSArray class]]))

#define IsStrEmpty(_ref)            (IsNilOrNull(_ref) || (![(_ref) isKindOfClass:[NSString class]]) || ([(_ref) isEqualToString:@""]))

#define IsArrEmpty(_ref)            (IsNilOrNull(_ref) || (![(_ref) isKindOfClass:[NSArray class]]) || ([(_ref) count] == 0))

#define IsDictionaryClass(_ref)     (!IsNilOrNull(_ref) && ([(_ref) isKindOfClass:[NSDictionary class]]))

#define IsCodeSuccess(_ref)        (([(_ref) intValue] == 0))


#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define TR_USERINFO        [[TR_SystemInfo mainSystem] userInfo]
#define TR_LOGIN               [[TR_SystemInfo mainSystem] login]
#define kPageNum               @"pageNum"
#define kPageSize               @"pageSize"
#define kpageOfSize 20

#define System_0_5     1/[[UIScreen mainScreen] scale]

#define FIRST_LUNCHED(v) ([NSString stringWithFormat:@"YH_FirstLunched_%@", v])

//保护NSString不为空
#define MakeStringNotNil(str) ([NSString yh_CheckStringFormatter:str])

//版本信息
#define kBundleVersionString        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kVersionString              [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]
#define mlSystemVersion             [[UIDevice currentDevice] systemVersion]

#define kScreenPoint6Scale           CGRectGetWidth([[UIScreen mainScreen] bounds])/375.0f

#define FONT_SIZE       14
#define LOGIN_IMG_EdgeInset  5

#define SECTION_HEIGHT     10

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//大于等于7.0的ios版本
#define iOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

//大于等于9.0的ios版本
#define iOS9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

//大于等于10.0的ios版本
#define iOS10_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")

//大于等于11.0的ios版本
#define iOS11_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

//大于等于13.0的ios版本
#define iOS13_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 防止多次调用
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


#endif /* CommonMacro_h */
