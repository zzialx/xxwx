//
//  NSDictionary+MILO.m
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12/30.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "NSDictionary+MILO.h"

@implementation NSDictionary (MILO)
+(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
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
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (id)yh_object:(id)options key:(NSString *)key
{
    NSArray *keys = [key componentsSeparatedByString:@"."];
    for (NSString *_key in keys) {
        if ([options isKindOfClass:[NSArray class]]) {
            int _intKey = [_key intValue];
            if ([(NSArray *)options count] <= _intKey) {
                return nil;
            }
            options = [(NSArray *) options objectAtIndex:_intKey];
            
        }else if ([options isKindOfClass:[NSDictionary class]]) {
            options = [(NSDictionary *)options objectForKey:_key];
            if (options != nil && [options isKindOfClass:[NSNull class]]) {
                options = nil;
            }
        }
    }
    return options;
}

- (id)yh_objectForPath:(NSString *)path
{
    return [self yh_object:self key:path];
}

- (NSString *)yh_stringForPath:(NSString *) path
{
    id o = [self yh_objectForPath:path];
    if (o == nil) {
        return @"";
    }
    if ([o isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString *s = [NSString stringWithFormat:@"%@", o];
    if ([s isEqualToString:@"<null>"]) {
        s = @"";
    }
    return s;
}

- (NSDictionary *)yh_dictForKey:(id)key
{
    id object = [self objectForKey:key];
    if ((object == nil)||[object isEqual:[NSNull null]]) {
        object = @{};
    }
    if (![object isKindOfClass:[NSDictionary class]]) {
        LogWarn(@"Error format With Expect Dictionary,But %@",NSStringFromClass([object class]));
        object = @{};
    }
    return object;
}

- (NSArray *)yh_arrayForKey:(id)key
{
    id object = [self objectForKey:key];
    if ((object == nil)||[object isEqual:[NSNull null]]) {
        object = @[];
    }
    if (![object isKindOfClass:[NSArray class]]) {
        LogWarn(@"Error format With Expect Array,But %@",NSStringFromClass([object class]));
        object = @[];
    }
    return object;
}

- (NSString *)yh_stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if ((object == nil) ||[object isEqual:[NSNull null]]) {
        return @"";
    }
    if (![object isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    return object;
}


- (BOOL)yh_boolForKey:(NSString *)key
{
    id object = self[key];
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object boolValue];
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)yh_integerForKey:(NSString *)key
{
    NSString *string = [self yh_objectForPath:key];
    if ([string respondsToSelector:@selector(integerValue)]) {
        return [string integerValue];
    }
    return 0;
}

- (long)yh_longForKey:(NSString *)key
{
    NSNumber *number = [self yh_objectForPath:key];
    return [number longValue];
}

- (long long)yh_longlongForKey:(NSString *)key
{
    NSNumber *number = [self yh_objectForPath:key];
    return [number longLongValue];
}

- (float)yh_floatForKey:(NSString *)key
{
    NSString *string = [self yh_objectForPath:key];
    return [string floatValue];
}

- (double)yh_doubleForKey:(NSString *)key
{
    NSString *string = [self yh_objectForPath:key];
    return [string doubleValue];
}

- (NSMutableDictionary *)yh_mutableDeepCopy
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for (id key in keys){
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(yh_mutableDeepCopy)]){
            oneCopy = [oneValue yh_mutableDeepCopy];
        }else if ([oneValue respondsToSelector:@selector(mutableCopy)]){
            oneCopy = [oneValue mutableCopy];
        }
        if (oneCopy == nil){
            oneCopy = [oneValue copy];
        }
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}

- (NSString *)yh_stringRepresentationByURLEncoding
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self allKeys])
    {
        id object = [self objectForKey:key];
        if (![object isKindOfClass:[NSString class]]) {
            continue;
        }
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [object yh_URLEncodedString]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

- (NSString *)yh_asJSONString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
