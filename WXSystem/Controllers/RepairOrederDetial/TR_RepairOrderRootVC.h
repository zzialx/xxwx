//
//  TR_RepairOrderRootVC.h
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^reloadOrderList)(void);

@interface TR_RepairOrderRootVC : TR_BaseViewController
@property(nonatomic,assign)RepairOD_Type  repairType;
@property(nonatomic,copy)NSString * repairOrderId;
@property(nonatomic,copy)reloadOrderList reloadOrderList;
@end

NS_ASSUME_NONNULL_END
