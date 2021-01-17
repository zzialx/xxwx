//
//  TR_MyHeaderCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_SystemInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^showInfo)(void);

@interface TR_MyHeaderCell : UICollectionReusableView

@property(nonatomic,copy)showInfo showInfo;

- (void)updateMyHeader;

@end

NS_ASSUME_NONNULL_END
