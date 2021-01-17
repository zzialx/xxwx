//
//  TR_ChangeSexCell.h
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectSex)(NSInteger btnTag);
@interface TR_ChangeSexCell : UITableViewCell

@property(nonatomic,copy)selectSex selectSex;

- (void)showCellSex:(NSString*)sex isSelect:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
