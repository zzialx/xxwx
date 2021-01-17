//
//  TR_AddEquMapVC.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"
#import "TR_EqumentModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^getAddress)(NSString*address,NSString*longitude,NSString*latitude);
@interface TR_AddEquMapVC : TR_BaseViewController
@property(nonatomic,copy)getAddress getAddress;
@end

NS_ASSUME_NONNULL_END
