//
//  TR_RepairInfoVC.h
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"
#import "TR_RepairDetialModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairInfoVC : TR_BaseViewController
@property(strong, nonatomic)UITableView * table;
@property(nonatomic,assign)RepairOD_Type  repairType;
@property(strong, nonatomic)TR_RepairDetialModel * detialInfoModel;
@end

NS_ASSUME_NONNULL_END
