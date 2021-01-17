//
//  TR_SettingCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_MyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_SettingCell : UITableViewCell

- (void)bindViewModel:(TR_MyViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
