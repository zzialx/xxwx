//
//  LocationManager.h
//  WXSystem
//
//  Created by admin on 2019/12/4.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TR_LocationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject
@property(nonatomic,strong)TR_LocationModel * locationModel;
+ (id)shareInstance;

- (void)changeLocation:(TR_LocationModel *)location;

@end



NS_ASSUME_NONNULL_END
