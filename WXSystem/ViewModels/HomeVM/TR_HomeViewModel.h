//
//  TR_HomeViewModel.h
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ViewModel.h"
@class TR_HomeModel;

@interface TR_HomeViewModel : TR_ViewModel

@property (strong,nonatomic) TR_HomeModel *homeModel;

-(void)checkLoginStatus:(NSDictionary *)parameters completionBlock:(BoolBlock)block;

//获取首页统计数据
- (void)getHomeRepairNumberCompletionBlock:(BoolBlock)block;

//获取统计列表
- (void)getHomeList:(TR_DataLoadingType)type reparirType:(NSString*)repairType completionBlock:(BoolBlock)block;
//首页统计工单搜索列表
- (void)getHomeSearchRepairList:(TR_DataLoadingType)type orderType:(NSString*)orderType searchKey:(NSString*)searchKey completionBlock:(BoolBlock)block;

//工单模块搜索列表
- (void)getOrderSearchRepairList:(TR_DataLoadingType)type searchKey:(NSString*)searchKey completionBlock:(BoolBlock)block;
//版本监测
-(void)getVersionStatus:(NSDictionary *)parameters completionBlock:(ModelBlock)block;
//上传经纬度
- (void)upLoadLocation:(NSDictionary*)parameters completionBlock:(BoolBlock)block;

@end
