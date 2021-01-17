//
//  TR_RepairFootView.h
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^footAction)(Repair_Foot_Type actionType);
@interface TR_RepairFootView : UIView

@property(copy,nonatomic)footAction footAction;
@property(assign,nonatomic)RepairOD_Type detialType;
@end

NS_ASSUME_NONNULL_END
