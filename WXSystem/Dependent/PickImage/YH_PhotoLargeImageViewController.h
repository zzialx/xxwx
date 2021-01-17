//
//  YH_PhotoLargeImageViewController.h
//  WXSystem
//
//  Created by candy.chen on 2019/4/23.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YH_PhotoLargeImageViewController : UIViewController

@property (copy, nonatomic) VoidBlock imageBlock;

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets;

@end

NS_ASSUME_NONNULL_END
