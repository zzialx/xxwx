//
//  TR_WriteDailyContentCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/10/23.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_WriteDailyContentCell : TR_FormBaseCell

@property (copy, nonatomic) StringBlock contentBlock;

- (void)updateContentItem:(NSString *)fieldString;

+ (CGFloat)heightWithItem;

@end

@interface UITableView (TR_WriteDailyContentCell)

- (TR_WriteDailyContentCell *)contentCellWithId:(NSString *)cellId;

@end

NS_ASSUME_NONNULL_END
