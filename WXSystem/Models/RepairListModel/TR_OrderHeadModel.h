//
//  TR_OrderHeadModel.h
//  WXSystem
//
//  Created by admin on 2019/12/5.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_OrderHeadModel : TR_Model
@property(nonatomic,copy)NSString * all;///<所有
@property(nonatomic,copy)NSString * waitMeReceipt;///<待我接单
@property(nonatomic,copy)NSString * waitMeService;///<w待我服务
@property(nonatomic,copy)NSString * waitMeComplete;///<待我完成
@property(nonatomic,copy)NSString * completed;///<完成
@property(nonatomic,copy)NSString * returnVisit;///<回访
@property(nonatomic,copy)NSString * canceled;///<已取消

@end

NS_ASSUME_NONNULL_END
