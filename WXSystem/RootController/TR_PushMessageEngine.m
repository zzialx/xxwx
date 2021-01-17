//
//  TR_PushMessageEngine.m
//  HouseProperty
//
//  Created by candy.chen on 2019/2/12/27.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TR_PushMessageEngine.h"
#import "TR_TabBarViewController.h"
#import "TR_ProtocolWebViewController.h"

@implementation TR_PushMessageEngine

+ (TR_PushMessageEngine *)sharedHandler{
    static TR_PushMessageEngine *sharedPushMsgHandler = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedPushMsgHandler = [[TR_PushMessageEngine alloc] init];
    });
    return sharedPushMsgHandler;
}


- (void)parsePushUrlLocal:(NSString *)url
{
    if (url.length<=0) {
        return;
    }
    if (url.length>0) {
        url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    BLOCK_EXEC(self.engineblock,TR_JumpTypeH5,url);
    return;
}

- (void)parsePushUrl:(NSString *)url
{
    if (url.length<=0) {
        return;
    }
    if (url.length>0) {
        url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    NSURL * messageUrl = [NSURL URLWithString:url];
    NSString *path = messageUrl.path;
//   NSArray *pathComponents = messageUrl.pathComponents;
//   NSString *pathExtension = messageUrl.pathExtension;
//   NSString *parameterString = messageUrl.parameterString;
   NSString *query = messageUrl.query;
   NSArray *queryComponents = [query componentsSeparatedByString:@"&"];
    NSMutableArray *keyArray = [NSMutableArray array];
    for (NSString *param in queryComponents) {
        NSArray *array = [param componentsSeparatedByString:@"="];
        [keyArray addObject:MakeStringNotNil(array[1])];
    }
    NSLog(@"keyArray:%@",keyArray);
}

- (void)handleReceivedMessage
{
    if (!self.messages) {
        return;
    }
    NSDictionary *resultDict = self.messages;
    NSString *dataStr = [self.messages yh_stringForKey:@"data"];
    if ([dataStr length] > 0) {
        NSError *error = nil;
        resultDict = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    }
    
    if (!resultDict || ![resultDict isKindOfClass:[NSDictionary class]]){
        //消息不合法，不往下执行
        self.messages = nil;
        return;
    }
    
    [self handleMessagesWithDictionary:resultDict];
}

- (void)handleMessagesWithDictionary:(NSDictionary *)resultDict{
    //角标个数处理
    NSString * badgeNum = resultDict[@"aps"][@"badge"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum.integerValue];
    //处理消息数据
    TR_JumpType type = [[resultDict yh_stringForKey:@"pushType"] integerValue];
    NSString *pushUrl = [resultDict yh_stringForKey:@"pushUrl"];
    NSString *pushId = [resultDict yh_stringForKey:@"pushId"];
    
    if (type == TR_JumpTypeH5) {
        NSString *url = [NSString stringWithFormat:@"%@detail.html?id=%@",WEB_URL, pushId];
        TR_ProtocolWebViewController *webVC = [[TR_ProtocolWebViewController alloc]initWithProtocolType:url];
        [[TR_TabBarViewController defaultTabBar].selectedNavi pushViewController:webVC animated:YES hideBottomTabBar:YES];
    } else if (type == TR_JumpTypeNotice) {
        NSString *url = [NSString stringWithFormat:@"%@detail.html?id=%@",WEB_URL, pushId];
        TR_ProtocolWebViewController *webVC = [[TR_ProtocolWebViewController alloc]initWithProtocolType:url];
        [[TR_TabBarViewController defaultTabBar].selectedNavi pushViewController:webVC animated:YES hideBottomTabBar:YES];
    } 
}

- (TR_APPROVELIST_TYPE)getApproveListType:(NSString*)approveState{
    if ([approveState isEqualToString:@"0"]||[approveState isEqualToString:@"4"]||[approveState isEqualToString:@"5"]) {
        return  TR_APPROVELIST_TYPE_WIAT;
    }if ([approveState isEqualToString:@"1"]||[approveState isEqualToString:@"2"]) {
        return TR_APPROVELIST_TYPE_APPROVED;
    }if ([approveState isEqualToString:@"3"]) {
        return TR_APPROVELIST_TYPE_CC;
    }
    return TR_APPROVELIST_TYPE_APPROVED;
}
@end
