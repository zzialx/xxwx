//
//  TR_RepairVisitRecordVC.h
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairVisitRecordVC : TR_BaseViewController
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,assign)RepairOD_Type  repairType;
@property(nonatomic,copy)NSString * repairOrderID;

@end

NS_ASSUME_NONNULL_END
