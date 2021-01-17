//
//  TR_RepairAddressSeaResultVC.h
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^getSearchAddress)(NSString*address,NSString*longitude,NSString*latitude);

@interface TR_RepairAddressSeaResultVC : TR_BaseViewController
@property(nonatomic,copy)NSString * city;
@property(nonatomic,copy)getSearchAddress getSearchAddress;
@end

NS_ASSUME_NONNULL_END
