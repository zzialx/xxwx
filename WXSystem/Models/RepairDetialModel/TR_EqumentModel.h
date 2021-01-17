//
//  TR_EqumentModel.h
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_EqumentModel : TR_Model
@property(nonatomic,copy)NSString * equipmentId;///<设备id
@property(nonatomic,copy)NSString * equipmentName;///<设备名字
@property(nonatomic,copy)NSString * addr;///<详细地址
@property(nonatomic,copy)NSString * addrType;///<地区类型：0-地图、1-下拉
@property(nonatomic,copy)NSString * companyName;///<所属客户
@property(nonatomic,copy)NSString * createdBy;///<创建人
@property(nonatomic,copy)NSString * createdTime;///<创建时间
@property(nonatomic,copy)NSString * criCode;///<地区编码
@property(nonatomic,copy)NSString * criInfo;///<地区详情
@property(nonatomic,copy)NSString * equipmentBrand;///<品牌
@property(nonatomic,copy)NSString * serviceAddr;///<位置
@property(nonatomic,copy)NSString * equipmentModel;///<设备型号
@property(nonatomic,copy)NSString * equipmentNum;///<设备编号
@property(nonatomic,copy)NSString * equipmentSituation;///<设备情况
@property(nonatomic,copy)NSString * latitude;///<纬度
@property(nonatomic,copy)NSString * level;///<放大级别
@property(nonatomic,copy)NSString * longitude;///<经度
@property(nonatomic,strong)NSArray * fileUrls;///<设备图片
@property(nonatomic,strong)NSArray * miniPicUrls;///<设备缩略图地址
@end

NS_ASSUME_NONNULL_END
