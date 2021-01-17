//
//  TR_RepairServiceCell.h
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_ServicePgrDetialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairServiceCell : UITableViewCell

+ (CGFloat)getCellHeight:(NSString*)address;

- (void)showCellSectionIndex:(NSInteger)sectionIndex serviceModel:(TR_ServicePgrDetialModel*)serviceModel;

@end

NS_ASSUME_NONNULL_END
