//
//  ColorMacros.h
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#ifndef ColorMacros_h
#define ColorMacros_h

#define REDCOLOR     [UIColor tr_colorwithHexString:@"#FB363F"]
#define THREECOLOR   [UIColor tr_colorwithHexString:@"#333333"]
#define FOURCOLOR    [UIColor tr_colorwithHexString:@"#444444"]
#define SIXCOLOR     [UIColor tr_colorwithHexString:@"#666666"]
#define NICECOLOR    [UIColor tr_colorwithHexString:@"#999999"]
#define LINECOLOR    [UIColor tr_colorwithHexString:@"#F2F2F2"]
#define TABLECOLOR   [UIColor tr_colorwithHexString:@"#F7F7F7"]
#define PLACECOLOR   [UIColor tr_colorwithHexString:@"#B8B8B8"]
#define BLUECOLOR    [UIColor tr_colorwithHexString:@"#4C9FFF"]

#define COLOR_51                UICOLOR_RGBA(51, 51, 51)
#define COLOR_102              UICOLOR_RGBA(102, 102, 102)
#define COLOR_153              UICOLOR_RGBA(153, 153, 153)
#define COLOR_230              UICOLOR_RGBA(230, 230, 230)
#define COLOR_245              UICOLOR_RGBA(245, 245, 245)

#define KNAV_BGCOLOR     [UIColor colorWithRed:60/255.0 green:163/255.0 blue:91/255.0 alpha:1]

#define UICOLOR_RGBA(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define KSYS_BGCOLOR    [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

#define GRAY_BGCOLOR   UICOLOR_RGBA(249, 249, 249)

#define FONT_TEXT(size) [UIFont systemFontOfSize:size];

#define HEAD_COLOR  [UIColor tr_colorwithHexString:@"#5C9CF4"]

#define REPLACE_LINE_POINT(str)  [str stringByReplacingOccurrencesOfString:@"-" withString:@"."]
#define REPLACE_POINT_NULL(str)  [str stringByReplacingOccurrencesOfString:@"." withString:@""]
#define REPLACE_LINE_NULL(str)  [str stringByReplacingOccurrencesOfString:@"-" withString:@""]


#endif /* ColorMacros_h */
