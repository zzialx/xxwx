//
//  TR_AddRepairImgCell.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_AddRepairImgCell : TR_FormBaseCell
@property (copy, nonatomic) ArrayBlock imageCompletion;

+ (CGFloat)heightWithItem:(NSMutableArray *)array;

- (void)updateImageArray:(NSMutableArray *)array section:(NSInteger)section;

- (void)updateAddEquImageArray:(NSMutableArray *)array;

@end
@interface UITableView (TR_AddRepairImgCell)

- (TR_AddRepairImgCell *)dailyImageCellWithId:(NSString *)cellId;

@end
NS_ASSUME_NONNULL_END
