//
//  UITableView+Extension.m
//  HouseProperty
//
//  Created by isaac on 2019/2/12/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)
-(void)setHeightWithSystemVersion{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
    }
}
@end
