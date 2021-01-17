//
//  NSDictionary+MILO.h
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12/30.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MILO)

//字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 @brief  获取key对应的value对象
 
 @param path key值，可以为嵌套key
 
 @return 指定key对应的对象
 
 @since 3.1
 */
- (id)yh_objectForPath:(NSString *)path;

/**
 @brief  获取key对应的字符串对象,支持嵌套路径
 
 @param path 路径
 
 @return 对应字符串
 
 @since 3.1
 */
- (NSString *)yh_stringForPath:(NSString *) path;

/**
 @brief  获取key对应的字典对象
 
 @param key key值
 
 @return 对应字典
 
 @since 3.1
 */
- (NSDictionary *)yh_dictForKey:(id)key;

/**
 @brief  获取key对应的字典对象
 
 @param key key值
 
 @return 对应字典
 
 @since 3.1
 */
- (NSArray *)yh_arrayForKey:(id)key;

/**
 @brief  获取key对应的字符串对象
 
 @param key key值，可以为嵌套key
 
 @return key对应的字符串
 
 @since 3.1
 */
- (NSString *)yh_stringForKey:(id)key;

/**
 @brief  获取key对应的bool值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象bool值
 
 @since 3.1
 */
- (BOOL)yh_boolForKey:(NSString *)key;

/**
 @brief  获取key对应的整形值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象interger值
 
 @since 3.1
 */
- (NSInteger)yh_integerForKey:(NSString *)key;

/**
 @brief  获取key对应的long型值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象long值
 
 @since 3.1
 */
- (long)yh_longForKey:(NSString *)key;

/**
 @brief  获取key对应的longlong型值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象longlong值
 
 @since 3.1
 */
- (long long)yh_longlongForKey:(NSString *)key;

/**
 @brief  获取key对应的float值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象float值
 
 @since 3.1
 */
- (float)yh_floatForKey:(NSString *)key;

/**
 @brief  获取key对应的double型值
 
 @param key key值，可以为嵌套key
 
 @return key对应的对象double值
 
 @since 3.1
 */
- (double)yh_doubleForKey:(NSString *)key;

/**
 @brief  字典本身深拷贝
 
 @return 拷贝的字典
 
 @since 3.1
 */
- (NSMutableDictionary *)yh_mutableDeepCopy;

/**
 @brief  键值对已通过URLENcodeing形式拼装
 
 @return 拼装后的字符串
 
 @since 3.1
 */
- (NSString *)yh_stringRepresentationByURLEncoding;



/**
 @brief  将字段对象转换为json 字符串
 
 @return json字符串
 
 @since 3.1
 */
- (NSString *)yh_asJSONString;

@end
