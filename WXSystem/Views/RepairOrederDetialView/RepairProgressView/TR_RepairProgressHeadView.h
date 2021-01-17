//
//  TR_RepairProgressHeadView.h
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_ServicePgrModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^showServiceDetial)(NSString * serviceID,BOOL isShow);
@interface TR_RepairProgressHeadView : UIView
@property(nonatomic,copy)showServiceDetial  showServiceDetial;
@property(nonatomic,assign)BOOL isShowMore;
@property(nonatomic,strong)TR_ServicePgrModel * model;

@end

NS_ASSUME_NONNULL_END
