//
//  NSString+MILO.h
//  MiloFoundation
//
//  Created by candylee on 2017/7/31.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@interface NSString   (MILO)


/**
 字典转字符串

 @param dict <#dict description#>
 @return <#return value description#>
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 *    @brief  转换系统版本号为整数，示例：CFBundleShortVersionString 3.2.0->320
 *
 *    @return 整型
 
 @since 3.2
 */
+ (NSInteger)yh_getAPPVersionNumber;

/**
 @brief  对字符串MD5加密
 
 @return 加密结果
 
 @since 3.1
 */
- (NSString *)yh_md5String;

/**
 @brief  根据配置对7牛的jpg的url进行webp处理
 
 @return 返回webp格式的url
 
 @since 3.8
 */
-(NSString *)yh_checkQiniuImageUrlAppendWebp;
/**
 @brief  判断字符串移除空白字符后是否为空
 
 @return 是否为空
 
 @since 3.1
 */
- (BOOL)yh_isEmptyAfterTrimmingWhitespaceAndNewlineCharacters;

/**
 @brief  去除字符串中包含的空白字符
 
 @return 不含空白字符的字符串
 
 @since 3.1
 */
- (NSString *)yh_stringByTrimmingWhitespaceAndNewlineCharacters;

/**
 @brief  将字符串进行urlencoding
 
 @return encoding之后的字符串
 
 @since 3.1
 */
- (NSString *)yh_URLEncodedString;

/**
 @brief  将形如￥123,456的价格标示转换为￥123456
 
 @return 不含逗号分隔符的价格字符串
 
 @since 3.1
 */
- (CGFloat)yh_priceValue;

/**
 @brief  检查字符串
 
 @return 检查字符串
 
 @since 3.1
 */

+ (NSString *)yh_CheckStringFormatter:(id)string;

/**
 @brief  判断字符串是否满足邮箱格式
 
 @return 是否是邮箱形式的字符串
 
 @since 3.1
 */
- (BOOL)yh_conformsToEmailFormat;

/**
 @brief  判断字符串是否是手机号码格式
 
 @return 是否是手机号码形式的字符串
 
 @since 3.1
 */
- (BOOL)yh_conformsToMobileFormat;

/**
 @brief  判断字符串长度时候满足在最大值和最小值之间
 
 @param minimum 字符串长度限制最小值
 @param maximum 字符串长度限制最大值
 
 @return 是否满足长度显示
 
 @since 3.1
 */
- (BOOL)yh_isLenghGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum;

/**
 @brief  获取字符串中的第一个URL子串的位置
 
 @return URL子串位置
 
 @since 3.1
 */
- (NSRange)yh_firstRangeOfURLSubstringi;

/**
 @brief  获取字符串中的第一个URL子串
 
 @return URL子串
 
 @since 3.1
 */
- (NSString *)yh_firstURLSubstring;

/**
 @brief  获取字符串中的URL子串
 
 @return URL子串集合
 
 @since 3.1
 */
- (NSArray *)yh_URLSubstrings;

/**
 @brief  获取字符串中第一段能头匹配正则表达的字符串
 
 @param regularExpression 匹配正则表达
 
 @return 第一段能匹配的字符串
 
 @since 3.1
 */
- (NSString *)yh_firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression;

/**
 @brief  获取字符串中第一段能头匹配正则表达的字符串
 
 @param regularExpressionPattern 匹配字符串模板
 
 @return 第一段能匹配的字符串
 
 @since 3.1
 */
- (NSString *)yh_firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;

/**
 @brief  判断字符串是否全部匹配目标字符串的正则表达
 
 @param regularExpressionPattern 匹配字符串模板
 
 @return 是否匹配
 
 @since 3.1
 */
- (BOOL)yh_matchesRegularExpressionPattern:(NSString *)regularExpressionPattern;

/**
 @brief  查找符合模板字符串正则表达的第一段字符串的rang
 
 @param regularExpressionPattern 匹配字符串模板
 
 @return 能匹配上的第一段字符串位置
 
 @since 3.1
 */
- (NSRange)yh_rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern;

/**
 @brief  将符合模板字符串正则表达的字符串统一替换为目标字符串
 
 @param regularExpressionPattern 匹配字符串模板
 @param templ                    替换字符串
 
 @return 完成替换后的字符串
 
 @since 3.1
 */
- (NSString *)yh_stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ;

/**
 @brief  将url请求的参数组织为字典形式
 
 @return 参数列表
 
 @since 3.1
 */
- (NSDictionary *)yh_URLParameters;
/**
 @brief  判断NSString是数值型
 
 @return 字符串是否是数值
 
 @since 3.1
 */
- (BOOL)yh_isPureDigital;

/**
 @brief  图片链接处理，自定义宽高和切图模式
 
 @param width  期望图片宽度
 @param height 期望图片高度
 @param mode   切图模式
 
 @return 图片url
 
 @since 3.1
 */
- (NSString *)yh_splitUrlWithWidth:(NSString *)width height:(NSString *)height mode:(NSString *)mode;


/**
 @brief  图片链接处理，自定义宽高，切图模式固定
 
 @param width  期望图片宽度
 @param height 期望图片高度
 
 @return 图片url
 
 @since 3.1
 */
- (NSString *)yh_splitUrlWithWidth:(NSString *)width height:(NSString *)height;

/**
 @brief  获取设置行间距的字符串
 
 @param lineSpacing 指定行间距
 @param breakMode   指定换行模式
 @param alignment   对齐方式
 
 @return 属性字符串
 
 @since 3.5
 */
- (NSMutableAttributedString *)yh_attributedStringWithLineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)breakMode textAlignment:(NSTextAlignment)alignment;
/**
 @brief  获取属性字符串
 
 @param font        字体
 @param lineSpacing 行间距
 @param breakMode   换行模式
 
 @return 属性字符串
 
 @since 3.1
 */
-(NSMutableAttributedString *)yh_attributedStringFromStingWithFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing withLineBreakMode:(NSLineBreakMode)breakMode;

/**
 @brief  获取属性字符串
 
 @param font        字体
 @param lineSpacing 行间距
 @param breakMode   换行模式
 @param alignment   对齐方式
 
 @return 属性字符串
 
 @since 3.1
 */
-(NSMutableAttributedString *)yh_attributedStringFromStingWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)breakMode alignment:(NSTextAlignment)alignment;
/**
 字符串变色
  */
- (NSMutableAttributedString *)getColorTime:(NSString *)color font:(CGFloat)font;
/**
 
 
 @brief  获取文字占据的尺寸
 
 @param size        文字显示区域大小
 @param font        字体
 @param lineSpacing 行间距
 @param breakMode   换行模式
 
 @return 字符区域大小
 
 @since 3.1
 */
-(CGSize)yh_boundingRectWithSize:(CGSize)size withTextFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing withLineBreakMode:(NSLineBreakMode)breakMode;

- (CGFloat)yh_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

// iOS7出了新的计算字符大小的方法，这里封装一下顺便少写一些参数,当然也只能算出一行的
- (CGFloat)yh_singleLineWidthWithFont:(UIFont *)font;
- (CGFloat)yh_singleLineHeightWithFont:(UIFont *)font;

//获取浮点字符串（20.00）
- (NSString *)yh_floatString;

//处理匿名姓名
-(NSString *)yh_anonymousName;

- (NSString *)yh_stringByRemoveRMBSymbol;

//处理匿名号码
- (NSString *)yh_anonymousMoblie;

//转化成万亿元
- (NSString *)yh_lastMoney;

- (NSString *)yh_lastPeople;

//替换字符串
-(NSString *)yh_replaceString;

//时间格式化
+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format;

//验证座机
- (BOOL)yh_conformsToLinePhone;

//多部门拼接
+ (NSString*)getOrgName:(NSArray*)orgNameArray;

+ (NSString*)getSumbitOrgName:(NSArray*)orgNameArray;

+ (NSString *)digitUppercase:(NSString *)numString;

/**
 字符串添加单位
 
 @param unit 单位
 */
- (NSString *)addUnit:(NSString *)unit;

/**
 获取字符串的Size大小
 
 @param fontSize 字体大小
 @param maxSize 最大显示Size
 */
- (CGSize)sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize;
/**
 比较两个日期的时间差
 */
+ (NSString *)compareStartDate:(NSString *)start endDate:(NSString *)end;


//比较两个日期的大小  日期格式为2016-08-14 08：46：20
+ (NSString *)compareDate:(NSString*)aDate withDate:(NSString*)bDate formatter:(NSString*)formatter;

//获取用户头像
+ (NSString*)getUserModelUserName:(NSString*)userName;
//文字生成图片
+ (UIImage *)zd_imageWithsize:(CGSize)size
                         text:(NSString *)text font:(NSInteger)font
                      circular:(BOOL)isCircular;

/**
 判断图片的方法
 */
+ (BOOL)isPicture:(NSString*)picName;

/**
 判断是否在考勤范围呢
 @param latitude 纬度
 @param longitude 经度
 @param companyLatitude 公司纬度
 @param companyLongitude 公司经度
 */
+ (BOOL)isOutWorkWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude companyLatitude:(CGFloat)companyLatitude companyLongitude:(CGFloat)companyLongitude cardDistance:(NSInteger)cardDistance;

/**
 比较wifi是否是公司wifi

 @param phoneWifiMac 本机wifi
 @param companyWifiList 公司wifi列表
 @return YES
 */
+(BOOL)isWifiCardWithPhoneWifiMac:(NSString*)phoneWifiMac companyWifiList:(NSString*)companyWifi;


/**
 获取wifimac地址

 @return return value description
 */
+ (NSString *)wifiMac;

/**
获取wifi名字
 */
+ (NSString *)wifiName;

/**
 获取当前时间

 */
+(NSString*)getCurrentTimeFromDate;
+(NSString*)getCurrentTimeFromDate1;
+(NSString*)getCurrentTimeFromDate2;
/**
 毫秒数转时分秒
 */
+ (NSString *)returndate:(NSNumber *)num;
+ (NSString *)returnserverdate:(NSNumber *)num;
/**
字符串转date
 */
+(NSDate*)dateFromString:(NSString*)string;

/**
转年月日时分秒
 */
+ (NSDate*)wortDateFromString:(NSString*)string;

/**
 时间转毫秒
 */
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;

/**
 获得打卡的状态
 */
+ (NSString*)getCardStateImgWithServerState:(NSString*)serverState;

/**
校验密码
 */
+ (BOOL)checkPassword:(NSString *) password;

/**
 校验是否开启定位
 */
+ (BOOL)openLocationService;

/**
 修改背景图片
  */
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

/**
 设置b高亮颜色
 */
+(NSAttributedString *)titleLabText:(NSString *)title keyWords:(NSString*)keyWords;

/**
 阿拉伯数字转汉字

 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;


@end
