//
//  TR_NoticeListTableViewCell.h
//  OASystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_NoticeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TR_NoticeListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblType;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblDepartment;
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) TR_NoticeListModel *model;
@end

NS_ASSUME_NONNULL_END
