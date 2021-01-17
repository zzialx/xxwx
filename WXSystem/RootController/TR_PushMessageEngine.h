//
//  TR_PushMessageEngine.h
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12/27.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TR_PushMessageEngineBlock)(TR_JumpType type, id data);

@interface TR_PushMessageEngine : NSObject

@property (copy,nonatomic) NSDictionary *messages;

@property (strong, nonatomic) TR_PushMessageEngineBlock engineblock;

+ (TR_PushMessageEngine *)sharedHandler;

- (void)handleReceivedMessage;

- (void)parsePushUrl:(NSString *)url;

- (void)parsePushUrlLocal:(NSString *)url;

@end
