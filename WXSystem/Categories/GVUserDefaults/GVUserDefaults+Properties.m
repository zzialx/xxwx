//
//  GVUserDefaults+Properties.m
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "GVUserDefaults+Properties.h"

@implementation GVUserDefaults (Properties)

@dynamic token;
@dynamic loginState;
@dynamic userInfo;
@dynamic floatValue;
@dynamic noticeState;
@dynamic showNoticeState;
@dynamic soundState;
@dynamic vibrationState;
@dynamic addressBookVersion;
@dynamic macLogin;
@dynamic logoArray;

- (NSDictionary *)setupDefaults {
    return @{
             @"token":@"",
             @"loginState": @NO,
             @"userInfo": [[NSData alloc]init],
             @"floatValue": @12.3,
             @"noticeState":  @YES,
             @"showNoticeState": @YES,
             @"soundState":@YES,
             @"vibrationState":@YES,
             @"addressBookVersion":@"",
             @"macLogin":@"Y",
             @"logoArray":[[NSArray alloc]init],
             @"approveAmount":@"",
             @"isDelApprove":@NO,
             @"isDelNotice":@NO,
             @"badgeMesssage":@"",
             @"fileUrl":@""
             };
}

- (NSString *)transformKey:(NSString *)key {
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"NSUserDefault%@", key];
}

@end
