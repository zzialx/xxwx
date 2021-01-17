//
//  TR_ServicePgrModel.h
//  WXSystem
//
//  Created by admin on 2019/12/3.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_ServicePgrModel : TR_Model
@property(nonatomic,copy)NSString * processId;
@property(nonatomic,copy)NSString * realName;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * avatarUrl;
@property(nonatomic,copy)NSString * hasInfo;
//@property(nonatomic,strong)TR_ServicePgrDetialModel * servicePgrDeiModel;///<进度详情

@end

NS_ASSUME_NONNULL_END
