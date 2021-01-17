//
//  TR_AddRepairProgressFootView.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^footAction)(NSInteger index);
@interface TR_AddRepairProgressFootView : UIView
@property(nonatomic,copy)footAction footAction;
@end

NS_ASSUME_NONNULL_END
