//
//  TR_RepairVisitModel.h
//  WXSystem
//
//  Created by admin on 2019/12/4.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairVisitModel : TR_Model
@property(nonatomic,copy)NSString * degree;///<满意；1：一般；2：不满意
@property(nonatomic,copy)NSString * degreeStr;///<满意；1：一般；2：不满意
@property(nonatomic,copy)NSString * solution;///<0：未解决；1：已解决
@property(nonatomic,copy)NSString * solutionStr;///< 0：未解决；1：已解决
@property(nonatomic,copy)NSString * evaluation;///<客户评价
@property(nonatomic,copy)NSString * visitRemark;///<回访备注

@end

NS_ASSUME_NONNULL_END
