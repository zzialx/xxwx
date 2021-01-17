//
//  TR_FormSelectDateView.h
//  OASystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_FormSelectDateView : UIView

@property (nonatomic, copy) StringBlock selectDateBlock;

- (void)showChannelChooseView:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
