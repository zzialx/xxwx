//
//  TR_RequestHeadKey.m
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12/7.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_RequestHeadKey.h"
#import "KeychainItemWrapper.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation TR_RequestHeadKey

+ (NSDictionary *)fixParameter{
        NSString *sign = [NSString stringWithFormat:@"%@%d%@",[self getCurrentTimes],(100000+arc4random()%900000),@"NLX@2008$888"];
       NSString *string = [NSString stringWithFormat:@"%@", MakeStringNotNil([GVUserDefaults standardUserDefaults].token)];
//    string = @"1aa9ee5b-10c0-4896-bcf3-329941abb613";
       NSLog(@"string:%@",string);
        return @{
                 @"imsi":[self UUID],                                      //手机imei号
                 @"mac_address":[self getMacAddress],                       //手机的mac地址
                 @"device_id":[self UUID],                                 //设备号
                 @"op_time": [self getCurrentTimes],                       //请求时间
                 @"version_name": [self versionCode],                      //应用版本号
                 @"sys_name":@"NCQ_SYS_PUBLIC",                                  //应用系统
                 @"platform": @"1",                                        //平台(就传1)
                 @"os_version":[[UIDevice currentDevice] systemVersion],   //操作系统版本号
                 @"network_type":[self networkType],                       //请求的网络类型
                 @"token":MakeStringNotNil(string),//登录用户的sessionId
                 @"brand":@"apple",                                        //手机品牌
                 @"model":[self getDeviceName],                            //手机型号
                 @"screen":@"",                                            //屏幕尺寸
                 @"channel_code":@"App Store",                             //发布渠道
                 @"nonce_str":[NSString stringWithFormat:@"%d",(100000+arc4random()%900000)],  //随机加密串(6位)
                 @"MD5_KEY":@"NLX@2008$888",                               //秘钥
                 @"sign":[sign yh_md5String],                                             //签名：MD5(op+time+nonce_str+requestBody+密钥)
                 };
}

+ (BOOL)isValidDictionary:(id)object {
    return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
}

+ (BOOL)isValidString:(id)object {
    return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

+ (NSString *)UUID {
    NSString *identifier = [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
    KeychainItemWrapper *keychain =
    [[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    NSString *uuid = [keychain objectForKey:(__bridge id)kSecValueData];
    
    if (![self isValidString:uuid]) {
        // 如果不存在则先生成再存到keychain中，下次读取。
        uuid = [NSUUID UUID].UUIDString;
        [keychain setObject:uuid forKey:(__bridge id)kSecValueData];
    }
    
    return uuid;
}


#pragma mark --获取手机的mac地址
+(NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
    // *(ptr+3), *(ptr+4), *(ptr+5)];
    
    // MAC地址不带冒号
    NSString *outstring = [NSString
                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

//获取当前的时间

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    //    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
}

+ (NSString *)versionCode {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //获取当前版本号
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    return currentVersion;
}

+ (NSString *)networkType {
    NSString *type;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
        case 2:{
            type = @"WiFi";
        }
            break;
        case 1:{
            type = [self currentWWANType];
        }
            break;
        case 0:{
            type = @"None";
        }
            break;
        default:
            type = @"Unknown";
            break;
    }
    return type;
}

+ (NSString *)currentWWANType {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    NSString *type = @"Unknown";
    
    if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
        [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
        [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        type = @"2G";
    } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
               [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
        type = @"3G";
    } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        type = @"4G";
    }
    
    return type;
}

+(NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([deviceString isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([deviceString isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([deviceString isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([deviceString isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([deviceString isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

#pragma mark 读取本地
+ (id)getData:(NSString *)key{
    
    NSUserDefaults *userDefault;
    userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault objectForKey:key];
    return [userDefault objectForKey:key];
}

//! 给参数加密和ut
+ (NSDictionary *)addUtAndMD5:(NSDictionary *)parameters {
    NSMutableDictionary *newMutDic=[NSMutableDictionary dictionaryWithDictionary:[self fixParameter]];
    NSString  *md5Str = [self hashToMD5Parameters:newMutDic];
    [newMutDic setObject:md5Str forKey:@"xsig"];
    return newMutDic;
}

+ (NSString *)hashToMD5Parameters:(NSDictionary *)dic {
    NSArray *sortedArray = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *mutableString=[NSMutableString string];
    
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([dic valueForKey:obj]) {
            [mutableString appendFormat:@"#%@=%@",obj,[dic valueForKey:obj]];
        }
    }];
    [mutableString deleteCharactersInRange:NSMakeRange(0, 1)];
    [mutableString appendFormat:@"%@",@"&cbfbd1e785e804c6c1456fd712c40ef0"]; // BaseKey
    
    return [mutableString lowercaseString];
}

//字典转json格式字符串：
+(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        LogInfo(@"%@",error);
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


@end
