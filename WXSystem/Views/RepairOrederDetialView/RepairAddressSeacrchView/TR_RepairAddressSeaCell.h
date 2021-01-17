//
//  TR_RepairAddressSeaCell.h
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairAddressSeaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;

- (void)showCellName:(NSString *)name address:(NSString*)address;
@end

NS_ASSUME_NONNULL_END
