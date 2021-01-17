//
//  TR_EqumentModel.m
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_EqumentModel.h"

@implementation TR_EqumentModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"fileUrls" : @[@"fileUrls",@"picUrls"]};
}
@end
