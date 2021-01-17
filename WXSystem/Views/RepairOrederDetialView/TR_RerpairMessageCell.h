//
//  TR_RerpairMessageCell.h
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_LesvelMsgModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^seeMessageInfo)(NSString * messageId);
typedef void(^seeFileInfo)(NSString * filePath,NSString*fileName);

@interface TR_RerpairMessageCell : UITableViewCell

+ (CGFloat)getCellHeightWithModel:(TR_LesvelMsgModel*)model;

@property(strong, nonatomic)TR_LesvelMsgModel * msgModel;
@property(copy, nonatomic)showBigPic showBigPic;
@property(copy, nonatomic)seeMessageInfo  seeMessageInfo;
@property(copy, nonatomic)seeFileInfo seeFileInfo;

@end

NS_ASSUME_NONNULL_END
