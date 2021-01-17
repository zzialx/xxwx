//
//  TR_ProtocolWebViewController.h
//  HouseProperty
//
//  Created by candy.chen on 2019/2/23.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_BaseWebController.h"
#import "TR_WebViewController.h"

typedef void(^ChangeNoticeStatus)(void);

@interface TR_ProtocolWebViewController : TR_WebViewController
@property (copy,nonatomic)NSString * fileName;///<文件名字
@property (copy, nonatomic) ChangeNoticeStatus status;
- (instancetype)initWithProtocolType:(NSString *)url;

@end
