//
//  TR_Cache.h
//  OASystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <YYCache/YYCache.h>

@interface TR_Cache : YYCache

+ (instancetype)BaseCacheClient;

- (void)deleteCache;

@end
