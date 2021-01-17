//
//  TR_EquipmentFailureCell.h
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_EquipmentFailureCell : UITableViewCell
+ (CGFloat)getHeightCell:(NSString*)failureStr;
@property (weak, nonatomic) IBOutlet UILabel *failureLab;


@end

NS_ASSUME_NONNULL_END
