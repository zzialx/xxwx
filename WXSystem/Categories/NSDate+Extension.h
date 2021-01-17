//
//  NSDate+Extension.h
//  WXSystem
//
//  Created by isaac on 2019/2/28.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

//年月日时间数组处理(一周之内显示星期一、星期二，超过一周就显示年月日)
-(NSMutableArray *)setTimeArray:(NSMutableArray *)array;
//年月日时间数组处理（超过昨天就显示年月日）
- (NSMutableArray *)setShortTimeArray:(NSMutableArray *)array;
//年月日时间字符串单个处理
-(NSString *)setTimeString:(NSString *)string;
//获取日报时间格式
-(NSString *)setDailyTimeString:(NSString *)string;
//处理时间显示当天昨天时间
- (NSString *)timeShortStringWithTimeInterval:(NSString *)timeInterval;
//获取当前年
+ (NSString*)getCurrentNear;
//获取当天日期
+ (NSString*)getCurrentToday;
//获取昨天日期
+ (NSString*)getCurrentLastDay;
//获取本周的开始和结束时间
+ (NSString *)currentScopeWeek;
//获取上周开始时间和结束时间
+ (NSString *)getLastWeekDate;
//获取本月的开始和结束时间
+  (NSString*)getMonthBeginAndEnd;
//获取当前周几
+ (NSInteger)getWeekDayFordate;

+ (NSInteger)getCurrentWeekDayFordateWithDate:(NSString*)date;

//比较时间大小
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
@end

NS_ASSUME_NONNULL_END
