//
//  TR_AccountCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_MyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_AccountCell : UICollectionViewCell

- (void)updateAccountModel:(TR_MyViewModel *)model atIndexPath:(NSIndexPath *)indexPath cellType:(NSString *)cellType;

- (void)updatePersonView:(NSString *)subtitle; 

@end

NS_ASSUME_NONNULL_END
