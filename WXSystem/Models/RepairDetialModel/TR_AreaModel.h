//
//  TR_AreaModel.h
//  WXSystem
//
//  Created by admin on 2019/12/5.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_AreaModel : TR_Model
@property(nonatomic,copy)NSString * criCode;///<地区编码
@property(nonatomic,copy)NSString * criName;///<名称
@property(nonatomic,copy)NSString * criShortName;///<简称
@property(nonatomic,copy)NSString * criSuperiorCode;///<上级编码
@property(nonatomic,copy)NSString * criLng;///<经度
@property(nonatomic,copy)NSString * criLat;///<纬度
@end

NS_ASSUME_NONNULL_END
