//
//  ProgressManager.h
//  WXSystem
//
//  Created by admin on 2019/12/6.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressManager : NSObject
+ (id)shareInstance;

@property(nonatomic,strong)NSDictionary * progressCellHeightDic;///<存储服务进度的高度

@end

NS_ASSUME_NONNULL_END
