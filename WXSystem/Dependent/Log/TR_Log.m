//
//  TR_Log.m
//  MiloFoundation
//
//  Created by candylee on 2017/7/31.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import "TR_Log.h"

@implementation TR_Log
+ (void)LogError:(NSString *)format, ... {
    if (LOG_FLAG_ERROR & LOG_LEVEL) {
        format = [NSString stringWithFormat:@"[ERROR] %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

+ (void)LogWarning:(NSString *)format, ... {
    if (LOG_FLAG_WARN & LOG_LEVEL) {
        format = [NSString stringWithFormat:@"[WARNING] %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

+ (void)LogInfo:(NSString *)format, ... {
    if (LOG_FLAG_INFO & LOG_LEVEL) {
        format = [NSString stringWithFormat:@"[INFO] %@", format];
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
    }
}

@end
