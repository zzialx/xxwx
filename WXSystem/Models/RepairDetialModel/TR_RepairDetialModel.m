//
//  TR_RepairDetialModel.m
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairDetialModel.h"

@implementation TR_RepairDetialModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"equipmentList":[TR_EqumentModel class]};
}

@end
