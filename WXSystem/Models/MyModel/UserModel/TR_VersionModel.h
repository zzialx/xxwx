//
//  TR_VersionModel.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/19.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_VersionModel : TR_Model

@property (copy, nonatomic) NSString *versionCode;//版本号

@property (copy, nonatomic) NSString *fileUrl;//升级链接

@property (copy, nonatomic) NSString *versionRule;/**0：无需更新 1：自选升级 2：强制更新*/

@property (copy, nonatomic) NSString *updateInfo;/**版本更新的内容*/


@end

NS_ASSUME_NONNULL_END
