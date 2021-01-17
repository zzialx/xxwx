//
//  ProgressManager.m
//  WXSystem
//
//  Created by admin on 2019/12/6.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "ProgressManager.h"
static ProgressManager *__manager = nil;

@implementation ProgressManager
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__manager == nil) {
            __manager = [[self alloc]init];
        }
    });
    return __manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.progressCellHeightDic=[NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}
@end
