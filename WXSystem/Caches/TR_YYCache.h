//
//  TR_YYCache.h
//  WXSystem
//
//  Created by candy.chen on 2019/3/5.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_YYCache : TR_Model

+ (instancetype)shareCache;

//根据key写入缓存value 异步方式
- (void)saveCacheKey:(NSString *)key cacheValue:(id)value;

//判断缓存是否存在
- (BOOL)containsObjectForKey:(NSString *)key;

//根据key读取数据
- (id)getCacheValue:(NSString *)key;

//根据key移除缓存
- (void)removeCacheKey:(NSString *)key;

//移除所有缓存
- (void)removeAllCache;

//移除所有缓存带进度
- (void)removeAllCacheWithProgress;

//获取缓存数量
- (NSUInteger)getCacheCount;

@end

NS_ASSUME_NONNULL_END
