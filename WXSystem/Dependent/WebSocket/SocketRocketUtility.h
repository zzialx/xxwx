//
//  SocketRocketUtility.h
//  SUN
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 SUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;


/**握手协议*/

/**
 * 用户 * 消息体：资产信息
 * */

#define USER_COMEIN @"5001"


/**
* 用户token失效（可能是密码发生变化，也有可能是在其他手机终端上登录了）
* 消息体：失效原因
* */
#define USER_GETOUT @"5002"


@interface SocketRocketUtility : NSObject

// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;
@property (nonatomic, copy) NSString *urlStirng;
+ (SocketRocketUtility *)instance;

-(void)SRWebSocketOpenWithURLString:(NSString *)string;//开启连接
-(void)SRWebSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据

@end
