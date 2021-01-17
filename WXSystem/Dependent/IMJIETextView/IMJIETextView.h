//
//  IMJIETextView.h
//  TDS
//
//  Created by zzialx on 16/6/16.
//  Copyright © 2016年 sixgui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMJIETextView : UITextView<UITextViewDelegate>

/** 占位文字 */
@property (nonatomic, retain) NSString *placeholder;

/** 占位颜色 */
@property (nonatomic, retain) UIColor *placeholderColor;

@end
