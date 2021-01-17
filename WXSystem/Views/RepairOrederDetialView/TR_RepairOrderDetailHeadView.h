//
//  TR_RepairOrderDetailHeadView.h
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_RepairDetialModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^RepairHeadAction)(RepairBtnType type);
@interface TR_RepairOrderDetailHeadView : UIView
@property(nonatomic,strong)TR_RepairDetialModel * detialModel;
@property(nonatomic,copy)RepairHeadAction repairHeadAction;

- (instancetype)initWithFrame:(CGRect)frame initWithData:(NSString*)data;
@end

NS_ASSUME_NONNULL_END
