//
//  TR_RepairRecordCell.h
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_RepairVisitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairRecordCell : UITableViewCell
@property(nonatomic,strong)TR_RepairVisitModel * visitModel;
@property(nonatomic,strong)NSIndexPath * indexPath;
@end

NS_ASSUME_NONNULL_END
