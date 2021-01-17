//
//  TR_RepairViewModel.h
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_ViewModel.h"
#import "TR_OrderHeadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairViewModel : TR_ViewModel
@property(nonatomic,strong)TR_OrderHeadModel * headModel;
/*
 工单头部统计
 */
- (void)getOrderHeadNumberCompletionBlock:(BoolBlock)block;

/*
 工单列表
 */
- (void)getOrderList:(TR_DataLoadingType)type reparirType:(NSString*)repairType completionBlock:(BoolBlock)block;

@end

NS_ASSUME_NONNULL_END
