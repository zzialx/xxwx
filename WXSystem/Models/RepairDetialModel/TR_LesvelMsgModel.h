//
//  TR_LesvelMsgModel.h
//  WXSystem
//
//  Created by admin on 2019/12/3.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_LesvelMsgModel : TR_Model
@property(nonatomic,copy)NSString * messageId;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * messageInfo;
@property(nonatomic,copy)NSString * messageTime;
@property(nonatomic,strong)NSArray * picUrls;
@property(nonatomic,strong)NSArray * miniPicUrls;///<说略图
@property(nonatomic,strong)NSArray * fileUrls;///<附件地址
@property(nonatomic,strong)NSArray * fileNames;///<附件名字

@end

NS_ASSUME_NONNULL_END
