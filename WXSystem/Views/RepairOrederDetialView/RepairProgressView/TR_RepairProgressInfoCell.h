//
//  TR_RepairProgressInfoCell.h
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_ServicePgrDetialModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface TR_RepairProgressInfoCell : UITableViewCell

+(CGFloat)getProgressCellHeightServiceContent:(NSString*)serviceContent servicePic:(NSArray*)servicePic;

@property(nonatomic,copy)showBigPic showBigPic;

- (void)showCellSection:(NSInteger)section serviceModel:(TR_ServicePgrDetialModel*)serviceModel;

@end

NS_ASSUME_NONNULL_END
