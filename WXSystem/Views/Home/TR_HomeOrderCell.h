//
//  TR_HomeOrderCell.h
//  WXSystem
//
//  Created by admin on 2019/11/11.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_HomeOrderCell : UITableViewCell

@property(nonatomic,copy)clickHomeItem clickHomeItem;
@property(nonatomic,strong)TR_HomeModel * homeModel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString*)type;


@end

NS_ASSUME_NONNULL_END
