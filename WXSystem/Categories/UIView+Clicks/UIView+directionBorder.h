//
//  UIView+directionBorder.h
//  WXSystem
//
//  Created by zzialx on 2019/5/28.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (directionBorder)
- (void)setDirectionBorderWithTop:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
