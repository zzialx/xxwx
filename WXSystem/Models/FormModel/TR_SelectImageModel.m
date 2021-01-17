//
//  TR_SelectImageModel.m
//  OASystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SelectImageModel.h"

@implementation TR_SelectImageModel

- (instancetype)init{
    if ((self = [super init])) {
        _editable = NO;
        _image = [UIImage imageNamed:@"add_sign"];
    }
    return self;
}

@end
