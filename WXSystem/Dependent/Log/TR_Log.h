//
//  TR_Log.h
//  MiloFoundation
//
//  Created by candylee on 2017/7/31.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_FLAG_ERROR    (1 << 0)  // 0...0001
#define LOG_FLAG_WARN     (1 << 1)  // 0...0010
#define LOG_FLAG_INFO     (1 << 2)  // 0...0100

#define LOG_LEVEL_OFF     0
#define LOG_LEVEL_ERROR   (LOG_FLAG_ERROR)                                     // 0...0001
#define LOG_LEVEL_WARN    (LOG_FLAG_ERROR | LOG_FLAG_WARN)                    // 0...0011
#define LOG_LEVEL_INFO    (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO)  // 0...0111

#ifdef DEBUG
#define LOG_LEVEL     LOG_LEVEL_INFO
#else
#define LOG_LEVEL     LOG_LEVEL_ERROR
#endif

#define LogError(frmt, ...)   [TR_Log LogError:(frmt), ##__VA_ARGS__]
#define LogWarn(frmt, ...)    [TR_Log LogWarning:(frmt), ##__VA_ARGS__]
#define LogInfo(frmt, ...)    [TR_Log LogInfo:(frmt), ##__VA_ARGS__]

@interface TR_Log : NSObject

+ (void)LogError:(NSString *)format, ...;
+ (void)LogWarning:(NSString *)format, ...;
+ (void)LogInfo:(NSString *)format, ...;


@end
