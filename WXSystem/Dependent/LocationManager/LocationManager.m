//
//  LocationManager.m
//  WXSystem
//
//  Created by admin on 2019/12/4.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "LocationManager.h"
static LocationManager *__manager = nil;

@implementation LocationManager
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
- (void)changeLocation:(TR_LocationModel *)location{
    __manager.locationModel = location;
}

@end
