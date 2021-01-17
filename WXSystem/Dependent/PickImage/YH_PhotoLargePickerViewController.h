//
//  YH_PhotoLargePickerViewController.h
//  YH_Community
//
//  Created by candy.chen on 18/7/15.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YH_PhotoLargePickerViewController : UIViewController

- (instancetype)initWithSelectAssets:(NSMutableArray *)selectAssets maxSelectNum:(NSInteger)number currentIndex:(NSInteger)index;

@end
