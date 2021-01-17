//
//  TR_LocationModel.h
//  WXSystem
//
//  Created by admin on 2019/12/4.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_LocationModel : TR_Model
@property(nonatomic,copy)NSString * addr;
@property(nonatomic,copy)NSString * longitude;
@property(nonatomic,copy)NSString * latitude;
@end

NS_ASSUME_NONNULL_END
