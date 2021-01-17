//
//  TR_RepairSearchVC.h
//  WXSystem
//
//  Created by admin on 2019/11/12.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairSearchVC : TR_BaseViewController
@property(nonatomic,copy)NSString * type;
- (instancetype)initWithType:(OrderType)type;
@end

NS_ASSUME_NONNULL_END
