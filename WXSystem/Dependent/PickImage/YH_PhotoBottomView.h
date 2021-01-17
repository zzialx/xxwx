//
//  YH_PhotoBottomView.h
//  WXSystem
//
//  Created by candy.chen on 2019/4/22.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YH_PhotoBottomView : UIView

@property (copy, nonatomic) VoidBlock updateBlock;

@property (copy, nonatomic) VoidBlock chooseBlock;

- (void)updateCountBtn:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
