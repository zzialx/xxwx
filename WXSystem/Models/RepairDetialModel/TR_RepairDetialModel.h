//
//  TR_RepairDetialModel.h
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"
#import "TR_EqumentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairDetialModel : TR_Model
@property(nonatomic,copy)NSString *orderId;///<工单ID
@property(nonatomic,copy)NSString *orderNum;///<工单编号
@property(nonatomic,copy)NSString *orderTitle;///<工单标题
@property(nonatomic,copy)NSString *companyName;///<客户名称
@property(nonatomic,copy)NSString *contactName;///<联系人
@property(nonatomic,copy)NSString *contactPhone;///<联系电话
@property(nonatomic,copy)NSString *appointmentTime;///<预约时间
@property(nonatomic,copy)NSString *serviceAddr;///<服务地址
@property(nonatomic,copy)NSString *longitude;///<经度
@property(nonatomic,copy)NSString *latitude;///<纬度
@property(nonatomic,assign)NSInteger level;///<放大级别
@property(nonatomic,copy)NSString *addr;///<详细地址
@property(nonatomic,copy)NSString *nowStatus;///<当前状态类型
@property(nonatomic,copy)NSString *nowStatusName;///<当前状态
@property(nonatomic,copy)NSString *emergency;///<紧急情况（0：正常；1：紧急）
@property(nonatomic,copy)NSString *emergencyName;///<紧急情况
@property(nonatomic,copy)NSString *orderTag;///<工单标签 0：一般工单；1：复杂工单
@property(nonatomic,copy)NSString *orderTagName;///<工单标签
@property(nonatomic,copy)NSString *manyFlag;///<是否多次报修 0：否；1：是
@property(nonatomic,copy)NSString *manyFlagName;///<是否多次报修
@property(nonatomic,copy)NSString *guaranteeType;///<维保类型 0：保内；1：保外
@property(nonatomic,copy)NSString *guaranteeTypeName;///<维保类型
@property(nonatomic,copy)NSString *labelId;///<故障类型ID
@property(nonatomic,copy)NSString *labelName;///<故障类型
@property(nonatomic,copy)NSString *faultRemark;///<故障说明
@property(nonatomic,strong)NSArray *picUrls;///<图片地址
@property(nonatomic,strong)NSArray *miniPicUrls;///<缩略图地址
@property(nonatomic,strong)NSArray<TR_EqumentModel*> *equipmentList;///<工单设备列表

@end


NS_ASSUME_NONNULL_END
