//
//  TR_FormImageModel.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/28.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormImageModel.h"

@implementation TR_FormImageModel

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.base forKey:@"base"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    //如果父类也遵守NSCoding协议，那么需要写self = [super initWithCoder]
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.base = [aDecoder decodeObjectForKey:@"base"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}


@end
