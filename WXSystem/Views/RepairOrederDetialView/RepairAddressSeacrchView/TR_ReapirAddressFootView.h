//
//  TR_ReapirAddressFootView.h
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectAddress)(NSString*address,NSString*longitude,NSString*latitude);
typedef void(^loadMoreData)(NSInteger page);
@interface TR_ReapirAddressFootView : UIView
@property(nonatomic,strong)UITableView * table;

@property(nonatomic,copy)selectAddress selectAddress;
@property(nonatomic,copy)loadMoreData loadMoreData;

- (void)reloadData:(NSArray*)addressList;

@end

NS_ASSUME_NONNULL_END
