//
//  UIColor+MILO.h
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MILO)
// hexString - @"#9c9c9c"
+ (UIColor *)tr_colorwithHexString:(NSString *)hexString;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @return The `UIColor` object.
 */
+ (UIColor *)tr_colorWithHex:(unsigned int)hex;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @param alpha The opacity of the color.
 @return The `UIColor` object.
 */
+ (UIColor *)tr_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/** Creates and returns a color object with a random color value. The alpha property is 1.0.
 @return The `UIColor` object.
 */
+ (UIColor *)tr_randomColor;

/**
 @brief 计算两种颜色的过渡色
 
 @param fromColor 开始颜色
 @param toColor   终止颜色
 @param scale     过渡比例
 
 @return 过渡色
 
 @since 4.6
 */
+ (UIColor *)tr_colorTranslationFrom:(UIColor *)fromColor toColor:(UIColor *)toColor scale:(float)scale;
@end
