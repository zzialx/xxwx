//
//  TR_CustomizeAlertView.h
//  WXSystem
//
//  Created by candy.chen on 2019/9/25.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^IndexBlock)(NSIndexPath *indexPath);

@interface TR_CustomizeAlertView : UIView

@property (nonatomic, copy) IndexBlock alertBlock;

- (void)showChannelChooseView:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
