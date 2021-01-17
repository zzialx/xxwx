//
//  TR_RepairLogCell.h
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_LogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairLogCell : UITableViewCell
- (void)showRepairlogCellWithData:(TR_LogModel*)logModel  isFirstRow:(BOOL)isFirstRow isLastRow:(BOOL)isLastRow index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
