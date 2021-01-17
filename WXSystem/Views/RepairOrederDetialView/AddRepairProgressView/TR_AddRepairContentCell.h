//
//  TR_AddRepairContentCell.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_AddRepairContentCell : TR_FormBaseCell
@property (copy, nonatomic) StringBlock contentBlock;

- (void)updateContentItem:(NSString *)fieldString section:(NSInteger)section;

- (void)updateAddEquContentItem:(NSString *)fieldString;

+ (CGFloat)heightWithItem;
@end
@interface UITableView (TR_AddRepairContentCell)

- (TR_AddRepairContentCell *)contentProgressCellWithId:(NSString *)cellId;

@end
NS_ASSUME_NONNULL_END
