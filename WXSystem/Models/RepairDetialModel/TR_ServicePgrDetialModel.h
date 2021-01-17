//
//  TR_ServicePgrDetialModel.h
//  WXSystem
//
//  Created by admin on 2019/12/3.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_ServicePgrDetialModel : TR_Model

@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString *startAddr;
@property(nonatomic,copy)NSString *beforeService;
@property(nonatomic,copy)NSString *afterService;
@property(nonatomic,copy)NSArray *beforePicUrls;
@property(nonatomic,copy)NSArray*beforeMiniPicUrls;
@property(nonatomic,copy)NSArray*afterPicUrls;
@property(nonatomic,copy)NSArray*afterMiniPicUrls;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *endAddr;
@property(nonatomic,assign)CGFloat cellHeight;///<缓存g行高

@end

NS_ASSUME_NONNULL_END
