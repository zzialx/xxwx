//
//  NSDate+Extension.m
//  WXSystem
//
//  Created by isaac on 2019/2/28.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
-(NSString *)setTimeString:(NSString *)string{
     NSString *nowTime = [self getTimeStrWithString:string];
     return [self timeStringWithTimeInterval:nowTime];
}
-(NSString *)setDailyTimeString:(NSString *)string{
    NSString *nowTime = [self getTimeStrWithString:string];
    return [self timeShortStringWithTimeInterval:nowTime];
}
-(NSMutableArray *)setTimeArray:(NSMutableArray *)array{
    NSMutableArray *arrayTime = [[NSMutableArray alloc]init];
    if (array.count == 1) {
        [arrayTime addObject:array[0]];
    }else{
        for (int i = 0; i < array.count-1; i++) {
            if (i == 0) {
                [arrayTime addObject:array[0]];
            }
            if ([self validateWithStartTime:array[i] withExprireTime:array[i+1]]) {
                [arrayTime addObject:@""];
            }else{
                [arrayTime addObject:array[i+1]];
            }
        }
    }
   
    for (int i = 0; i < arrayTime.count; i ++) {
        if (![arrayTime[i] isEqualToString:@""]) {
            NSString *string = [self getTimeStrWithString:arrayTime[i]];
            arrayTime[i] = [self timeStringWithTimeInterval:string];
            NSLog(@"%@",arrayTime[i]);
        }
    }
    return arrayTime;
}
- (NSMutableArray *)setShortTimeArray:(NSMutableArray *)array{
    NSMutableArray *arrayTime = [[NSMutableArray alloc]init];
    if (array.count == 1) {
        [arrayTime addObject:array[0]];
    }else{
        for (int i = 0; i < array.count-1; i++) {
            if (i == 0) {
                [arrayTime addObject:array[0]];
            }
            if ([self validateWithStartTime:array[i] withExprireTime:array[i+1]]) {
                [arrayTime addObject:@""];
            }else{
                [arrayTime addObject:array[i+1]];
            }
        }
    }
    
    for (int i = 0; i < arrayTime.count; i ++) {
        if (![arrayTime[i] isEqualToString:@""]) {
            NSString *string = [self getTimeStrWithString:arrayTime[i]];
            arrayTime[i] = [self timeShortStringWithTimeInterval:string];
            NSLog(@"%@",arrayTime[i]);
        }
    }
    return arrayTime;
}

//判断俩时间是否超过五分钟
-(BOOL)validateWithStartTime:(NSString *)startTime withExprireTime:(NSString *)expireTime{
    NSString *nowTime = [self getTimeStrWithString:startTime];
    NSString *endTime = [self getTimeStrWithString:expireTime];
    NSInteger i = [endTime integerValue] - [nowTime integerValue];
    if (i < 300) {
        return YES;
    }
    return NO;
}
//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
//判断时间戳是否为当天,昨天,一周内,年月日
- (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval
{
    if ([timeInterval isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue]; //此处根据项目需求,选择是否除以1000 , 如果时间戳精确到秒则去掉1000
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //今天
    if ([date isToday]) {
        
        formatter.dateFormat = @"HH:mm";
        
        return [formatter stringFromDate:date];
    }else{
        
        //昨天
        if ([date isYesterday]) {
            
            formatter.dateFormat = @"昨天  HH:mm";
            return [formatter stringFromDate:date];
            
            //一周内 [date weekdayStringFromDate]
        }else if ([self isOneWeek:date]){
//            BOOL isSameWeek = [self isOneWeek:date];
//            NSLog(@"是否是同一周==%d",isSameWeek);
            formatter.dateFormat = [NSString stringWithFormat:@"%@  %@",[date weekdayStringFromDate],@"HH:mm"];
            return [formatter stringFromDate:date];
            
            //直接显示年月日
        }else{
            
            formatter.dateFormat = @"yyyy/MM/dd  HH:mm";
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}
//判断时间戳是否为当天,昨天,年月日
- (NSString *)timeShortStringWithTimeInterval:(NSString *)timeInterval
{
    if ([timeInterval isEqualToString:@""]) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue]; //此处根据项目需求,选择是否除以1000 , 如果时间戳精确到秒则去掉1000
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //今天
    if ([date isToday]) {
        
        formatter.dateFormat = @"HH:mm";
        
        return [formatter stringFromDate:date];
    }else{
        
        //昨天
        if ([date isYesterday]) {
            
            formatter.dateFormat = @"昨天  HH:mm";
            return [formatter stringFromDate:date];
            
            //一周内 [date weekdayStringFromDate]
        }else{
            
            formatter.dateFormat = @"yyyy/MM/dd HH:mm";
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}

//是否为今天
- (BOOL)isToday
{
    //now: 2015-09-05 11:23:00
    //self 调用这个方法的对象本身
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}



//是否为昨天
- (BOOL)isYesterday
{
    //2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    //2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}
//是否在一周之内
- (BOOL)isOneWeek:(NSDate*)date{
    BOOL isSame = NO;
    NSDate * nowDate = [NSDate date];
   NSTimeInterval time = nowDate.timeIntervalSince1970 - date.timeIntervalSince1970;
    //计算两个中间差值(秒)
//    NSTimeInterval time = [nowDate timeIntervalSinceDate:date];
    //开始时间和结束时间的中间相差的时间
    int days;
    days = ((int)time)/(3600*24);  //一天是24小时*3600秒
    if (days<7) {
        isSame=YES;
    }
    return isSame;
}

- (BOOL)isSameWeek
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSLog(@"时间self=====%@",self);
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}
- (BOOL) isNewSameWeek{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *sourceCmps = [calendar components:unit fromDate:self];
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:[NSDate date] toDate:self options:0];
    NSInteger subDay = labs(dateCom.day);
    NSInteger subMonth = labs(dateCom.month);
    NSInteger subYear = labs(dateCom.year);
    
    if (subYear == 0 && subMonth == 0) { //当相关的差值等于零的时候说明在一个年、月、日的时间范围内，不是按照零点到零点的时间算的
        if (subDay > 6) { //相差天数大于6肯定不在一周内
            return NO;
        } else { //相差的天数大于或等于后面的时间所对应的weekday则不在一周内
            if (dateCom.day >= 0 && dateCom.hour >=0 && dateCom.minute >= 0) { //比较的时间大于当前时间
                //西方一周的开始是从周日开始算的，周日是1，周一是2，而我们是从周一开始算新的一周
                NSInteger chinaWeekday = sourceCmps.weekday == 1 ? 7 : sourceCmps.weekday - 1;
                if (subDay >= chinaWeekday) {
                    return NO;
                } else {
                    return YES;
                }
            } else {
                NSInteger chinaWeekday = sourceCmps.weekday == 1 ? 7 : nowCmps.weekday - 1;
                if (subDay >= chinaWeekday) { //比较的时间比当前时间小，已经过去的时间
                    return NO;
                } else {
                    return YES;
                }
            }
        }
    } else { //时间范围差值超过了一年或一个月的时间范围肯定就不在一个周内了
        return NO;
    }
}

//根据日期求星期几
- (NSString *)weekdayStringFromDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//格式化
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
+ (NSString*)getCurrentNear{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    return dateStr;
}
+ (NSString*)getCurrentToday{
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    return dateStr;
}
+ (NSString*)getCurrentLastDay{
    NSDate * date = [NSDate date];//当前时间
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:lastDay];
    return dateStr;
}

/**
 当前周的日期范围
 
 @return 结果字符串
 */
 + (NSString *)currentScopeWeek {
//    return [self currentScopeWeek:[self getWeekDayFordate] dateFormat:@"YYYY-MM-dd"];
     return [self backToPassedTimeWithWeeksNumber:0];
}
/**
 当前周的日期范围

 @return 结果字符串
 */
+(NSString *)backToPassedTimeWithWeeksNumber:(NSInteger)number
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:- 7 * 24 * 3600 * number];
    //滚动后，算出当前日期所在的周（周一－周日）
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    gregorian.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    NSDateComponents *comp = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    //真机上要减1
    NSInteger day =[comp weekday] -1;
//    NSInteger dayLast = 7-day;
    NSInteger dayBehind = 7-day;

    NSDate *weekdaybegin=[date dateByAddingTimeInterval:-(day-1)*60*60*24];
    NSDate *weekdayend = [date dateByAddingTimeInterval:dayBehind*60*60*24];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdaybegin];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdayend];
    NSDate *startDate = [calendar dateFromComponents:components];//这个不能改
    
    NSDate *endDate1 = [calendar dateFromComponents:components1];
//    NSDate *endDate1 = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:endDate1 options:0];
    
    //获取今天0点到明天0点的时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *str1 = [formatter1 stringFromDate:startDate];

    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *str2 = [formatter2 stringFromDate:endDate1];
    
    NSString * str  = [NSString stringWithFormat:@"%@:%@",str1,str2];
    return str;
}
+ (NSString*)getLastWeekDate{
    return [self backToPassedTimeWithWeeksNumber:1];
}

+  (NSString*)getMonthBeginAndEnd{
    NSDate*  newDate = [NSDate date];
    double interval = 0;
    
    NSDate *beginDate = nil;
    
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];
    
    //设定周一为周首日
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate]; //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *s = [NSString stringWithFormat:@"%@:%@",beginString,endString];
    
    NSLog(@"%@",s);
    return s;
}
//获取当前周几
+ (NSInteger)getWeekDayFordate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *now = [NSDate date];
    
    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    return [comps weekday] - 1;
    
}
+ (NSInteger)getCurrentWeekDayFordateWithDate:(NSString*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
      NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
        [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
        //NSString转NSDate
    
        NSDate *now=[formatter dateFromString:date];
    
    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    return [comps weekday] - 1;
}

+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}
@end
