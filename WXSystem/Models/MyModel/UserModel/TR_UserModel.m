//
//  TR_UserModel.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_UserModel.h"

@implementation TR_UserModel



-(void)encodeWithCoder:(NSCoder *)aCoder {
    //在编码方法中，需要对对象的每一个属性进行编码。
    
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.label forKey:@"label"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
//    [aCoder encodeObject:self.monthServe forKey:@"monthServe"];
    [aCoder encodeObject:self.monthReturnDegree forKey:@"monthReturnDegree"];

}


-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    //如果父类也遵守NSCoding协议，那么需要写self = [super initWithCoder]
    self = [super init];
    if (self) {
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.label = [aDecoder decodeObjectForKey:@"label"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.monthReturnDegree = [aDecoder decodeObjectForKey:@"monthReturnDegree"];

    }
    return self;
}

@end
