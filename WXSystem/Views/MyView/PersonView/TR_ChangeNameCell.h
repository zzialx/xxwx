//
//  TR_ChangeNameCell.h
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_ChangeNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inputTF;

- (void)showCellName:(NSString*)name placeHold:(NSString*)placeHold;

@end

NS_ASSUME_NONNULL_END
