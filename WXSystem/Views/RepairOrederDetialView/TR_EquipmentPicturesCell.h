//
//  TR_EquipmentPicturesCell.h
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_RepairDetialModel.h"
#import "TR_EqumentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_EquipmentPicturesCell : UITableViewCell
@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic)showBigPic showPic;
@property (strong, nonatomic)NSArray * picArray;

@end

NS_ASSUME_NONNULL_END
