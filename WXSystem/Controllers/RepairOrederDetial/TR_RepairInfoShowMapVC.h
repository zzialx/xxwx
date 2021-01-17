//
//  TR_RepairInfoShowMapVC.h
//  WXSystem
//
//  Created by admin on 2019/12/6.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"
#import "TR_RepairDetialModel.h"
#import "TR_EqumentModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface TR_RepairInfoShowMapVC : TR_BaseViewController
@property(nonatomic,strong)TR_RepairDetialModel * info;
@property(nonatomic,strong)TR_EqumentModel * equmentModel;
@end

NS_ASSUME_NONNULL_END
