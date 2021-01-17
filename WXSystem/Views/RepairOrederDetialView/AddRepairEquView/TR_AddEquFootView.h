//
//  TR_AddEquFootView.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^commitEqumentInfo)(void);
@interface TR_AddEquFootView : UIView
@property(nonatomic,copy)commitEqumentInfo commitEqumentInfo;
@end

NS_ASSUME_NONNULL_END
