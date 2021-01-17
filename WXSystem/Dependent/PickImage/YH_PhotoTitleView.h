//
//  YH_PhotoTitleView.h
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 导航的Title
@interface YH_PhotoTitleView : UIButton

@property (copy, nonatomic) BoolBlock openBlock;

- (void)updateGroupName:(NSString *)groupName isSelect:(BOOL)flag;

@end
