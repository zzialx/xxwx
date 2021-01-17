//
//  TR_YYCache.m
//  WXSystem
//
//  Created by candy.chen on 2019/3/5.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_YYCache.h"
#import "YYCache.h"

@interface TR_YYCache ()

@property (strong, nonatomic) YYCache  *yyCache;

@end


@implementation TR_YYCache

+ (instancetype)shareCache
{
    static dispatch_once_t onceToken;
    static TR_YYCache * cache = nil;
    dispatch_once(&onceToken, ^{
        cache = [[TR_YYCache alloc] init];
    });
    return cache;
}

//根据key写入缓存value 异步方式
- (void)saveCacheKey:(NSString *)key cacheValue:(id)value
{
    [self.yyCache setObject:value forKey:key withBlock:^{
        NSLog(@"setObject sucess");
    }];
}

//判断缓存是否存在
- (BOOL)containsObjectForKey:(NSString *)key
{
    BOOL isContains = [self.yyCache containsObjectForKey:key];
    return isContains;
}

//根据key读取数据
- (id)getCacheValue:(NSString *)key
{
    //根据key读取数据
    id vuale = [self.yyCache objectForKey:key];
    return vuale;
}

//根据key移除缓存
- (void)removeCacheKey:(NSString *)key
{
    [self.yyCache removeObjectForKey:key withBlock:^(NSString * _Nonnull key) {
        NSLog(@"removeObjectForKey %@",key);
    }];
}

//移除所有缓存
- (void)removeAllCache
{
    [self.yyCache removeAllObjectsWithBlock:^{
        NSLog(@"removeAllObjects sucess");
    }];
}

//移除所有缓存带进度
- (void)removeAllCacheWithProgress
{
    [self.yyCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        NSLog(@"removeAllObjects removedCount :%d  totalCount : %d",removedCount,totalCount);
    } endBlock:^(BOOL error) {
        if(!error){
            NSLog(@"removeAllObjects sucess");
        }else{
            NSLog(@"removeAllObjects error");
        }
    }];
}

- (NSUInteger)getCacheCount
{
    NSUInteger diskbytes = self.yyCache.diskCache.totalCost;
    NSUInteger memorybytes = self.yyCache.memoryCache.totalCost;
    NSUInteger count = diskbytes + memorybytes;
    
    // /*获取缓存的大小 diskCache.totalCost*/
    return count;
}

//YYImageCache *cache = [YYWebImageManager sharedManager].cache;

- (YYCache *)yyCache
{
    if (IsNilOrNull(_yyCache)) {
      _yyCache = [YYCache cacheWithName:@"OACache"];
//      _yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    }
    return _yyCache;
}

@end
