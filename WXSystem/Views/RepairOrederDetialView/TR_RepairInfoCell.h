//
//  TR_RepairInfoCell.h
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^showBtnAction)(RepairBtnType type);

@interface TR_RepairInfoCell : UITableViewCell
@property(nonatomic,copy)showBtnAction showBtnAction;

//首页cell显示
- (void)showCellInfoTitle:(NSString *)title content:(NSString*)content index:(NSInteger)index;
//设备信息页面显示
- (void)showEquimentInfoTitle:(NSString *)title content:(NSString*)content index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
