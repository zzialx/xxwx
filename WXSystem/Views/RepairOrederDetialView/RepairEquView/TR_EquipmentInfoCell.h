//
//  TR_EquipmentInfoCell.h
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_RepairDetialModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^showEquipmentInfo)(NSString * equipmentID);
@interface TR_EquipmentInfoCell : UITableViewCell

@property(nonatomic,copy)showEquipmentInfo showEquipmentInfo;
@property(nonatomic,strong)UICollectionView * collectionView;

- (void)showCellEqumentModel:(TR_RepairDetialModel*)equmentModel;
@end

NS_ASSUME_NONNULL_END
