//
//  UIColor+MILO.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "UIColor+MILO.h"

@implementation UIColor (MILO)

+ (UIColor *)tr_colorwithHexString:(NSString *)hexString
{
    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&hex];
    return [UIColor tr_colorWithHex:hex];
}

+ (id)tr_colorWithHex:(unsigned int)hex
{
    return [UIColor tr_colorWithHex:hex alpha:1];
}

+ (id)tr_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
    
}

+ (UIColor*)tr_randomColor{
    
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
}

+ (UIColor *)tr_colorTranslationFrom:(UIColor *)fromColor toColor:(UIColor *)toColor scale:(float)scale
{
    if (fromColor == nil || toColor == nil || scale < 0 || scale > 1) {
        return nil;
    }
    // 默认颜色空间是RGBA
    size_t numberF = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t numberT = CGColorGetNumberOfComponents(toColor.CGColor);
    
    const CGFloat *componentsF = CGColorGetComponents(fromColor.CGColor);
    const CGFloat *componentsT = CGColorGetComponents(toColor.CGColor);
    CGFloat *components = malloc(4 * sizeof(CGFloat));
    UIColor *transColor = nil;
    
    if (numberF == 2 && numberT == 2) {
        components[0] = componentsF[0] * (1-scale) + componentsT[0] * scale;
        components[1] = componentsF[0] * (1-scale) + componentsT[0] * scale;
        components[2] = componentsF[0] * (1-scale) + componentsT[0] * scale;
        components[3] = componentsF[1] * (1-scale) + componentsT[1] * scale;
        
    } else if (numberF == 4 && numberT == 4) {
        for (int i = 0; i < 4; i++) {
            components[i] = componentsF[i] * (1-scale) + componentsT[i] * scale;
        }
        
    } else if (numberF == 2 && numberT == 4) {
        components[0] = componentsF[0] * (1-scale) + componentsT[0] * scale;
        components[1] = componentsF[0] * (1-scale) + componentsT[1] * scale;
        components[2] = componentsF[0] * (1-scale) + componentsT[2] * scale;
        components[3] = componentsF[1] * (1-scale) + componentsT[3] * scale;
        
    } else if (numberF == 4 && numberT == 2) {
        components[0] = componentsF[0] * (1-scale) + componentsT[0] * scale;
        components[1] = componentsF[1] * (1-scale) + componentsT[0] * scale;
        components[2] = componentsF[2] * (1-scale) + componentsT[0] * scale;
        components[3] = componentsF[3] * (1-scale) + componentsT[1] * scale;
        
    } else {
        free(components);
        return nil;
    }
    
    transColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    //    NSLog(@"transColor:(%f,%f,%f,%f)", components[0], components[1], components[2], components[3]);
    free(components);
    return transColor;
}

@end
