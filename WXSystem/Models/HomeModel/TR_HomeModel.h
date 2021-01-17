//
//  TR_HomeModel.h
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

@interface TR_HomeModel : TR_Model
@property (copy, nonatomic) NSString *waitMeReceipt;///<待我接单
@property (copy, nonatomic) NSString *waitMeService;///<待我服务
@property (copy, nonatomic) NSString *waitMeComplete;///<待我完成
@property (copy, nonatomic) NSString *overdue;///<逾期

@end
