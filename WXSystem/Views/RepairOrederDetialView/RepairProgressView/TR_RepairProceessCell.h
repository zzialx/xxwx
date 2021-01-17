//
//  TR_RepairProceessCell.h
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_ServicePgrModel.h"
#import "TR_ServicePgrDetialModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^seeBigPic)(NSInteger index,NSArray * picArray);
@interface TR_RepairProceessCell : UITableViewCell
@property(nonatomic, strong)TR_ServicePgrModel * model;
@property(nonatomic, strong)TR_ServicePgrDetialModel * detailModel;

@property(nonatomic, strong)seeBigPic seeBigPic;
+ (CGFloat)getCellHeightWithProgressModel:(TR_ServicePgrModel*)progressModel;

/*
 获取进度详情
 */
//- (void)getOpenServiceInfo;
@end

NS_ASSUME_NONNULL_END
