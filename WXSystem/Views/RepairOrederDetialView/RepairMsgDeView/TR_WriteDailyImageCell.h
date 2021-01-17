//
//  TR_WriteDailyImageCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/10/23.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_WriteDailyImageCell : TR_FormBaseCell

@property (copy, nonatomic) ArrayBlock imageCompletion;

+ (CGFloat)heightWithItem:(NSMutableArray *)array;

- (void)updateImageArray:(NSMutableArray *)array;

@end

@interface UITableView (TR_WriteDailyImageCell)

- (TR_WriteDailyImageCell *)leavelImageCellWithId:(NSString *)cellId;

@end

NS_ASSUME_NONNULL_END
