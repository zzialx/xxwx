//
//  TR_Cache.m
//  OASystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Cache.h"

@implementation TR_Cache

+ (instancetype)BaseCacheClient {
    static TR_Cache *_cacheClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cacheClient = [[self alloc] initWithName:@"HttpsCache"];
        _cacheClient.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    });
    return _cacheClient;
}

-(void)deleteCache
{
    [[[YYCache alloc] initWithName:@"HttpsCache"] removeAllObjectsWithProgressBlock:nil endBlock:^(BOOL error) {
        if (!error) {
            NSLog(@"清除成功");
        }
    }];
}

@end
