//
//  TR_RepairListModel.h
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairListModel : TR_Model
@property(nonatomic,copy)NSString * orderId;///<工单ID
@property(nonatomic,copy)NSString * orderNum;///<工单编号
@property(nonatomic,copy)NSString * orderTitle;///<工单标题
@property(nonatomic,copy)NSString * addr;///<服务地址
@property(nonatomic,copy)NSString * nowStatus;///<当前状态类型
@property(nonatomic,copy)NSString * nowStatusName;///<当前状态
@property(nonatomic,copy)NSString * appointmentTime;///<预约时间
@property(nonatomic,copy)NSString * companyName;///<客户名称


@end

NS_ASSUME_NONNULL_END
