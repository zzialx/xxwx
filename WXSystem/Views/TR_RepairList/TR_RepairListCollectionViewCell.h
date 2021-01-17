//
//  TR_NoticeListCollectionViewCell.h
//  WXSystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RepairCellSelectDeledate<NSObject>

-(void)didSelectRepairCell:(NSString*)repairId orderType:(RepairOD_Type)orderType;


- (void)reloadHeadTitle;
@end

@interface TR_RepairListCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) id cellDelegate;
@property (nonatomic, assign) BOOL haveLoad;
-(void)loadWithColCode:(NSString *)colCode title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
