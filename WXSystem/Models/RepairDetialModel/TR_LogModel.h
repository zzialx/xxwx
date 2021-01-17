//
//  TR_LogModel.h
//  WXSystem
//
//  Created by admin on 2019/12/4.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_LogModel : TR_Model
@property(nonatomic,copy)NSString *logType;
@property(nonatomic,copy)NSString *logTypeName;
@property(nonatomic,copy)NSString *logInfo;
@property(nonatomic,copy)NSString *logTime;
@end

NS_ASSUME_NONNULL_END
