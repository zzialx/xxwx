//
//  TR_RepairDetialViewModel.h
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_ViewModel.h"
#import "TR_RepairDetialModel.h"
#import "TR_EqumentModel.h"
#import "TR_LesvelMsgModel.h"
#import "TR_ServicePgrDetialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_RepairDetialViewModel : TR_ViewModel

@property(nonatomic,strong)TR_RepairDetialModel * detialModel;
@property(nonatomic,strong)TR_EqumentModel * equmentModel;
@property(nonatomic,strong)TR_LesvelMsgModel * leavelMsgInfo;///<留言详情
@property(nonatomic,strong)TR_ServicePgrDetialModel * servicePgrDeiModel;///<进度详情
@property(nonatomic,strong)NSMutableArray * equInfoList;///<设备列表
@property(nonatomic,strong)NSMutableArray * leavelMsgList;///<留言列表
@property(nonatomic,strong)NSMutableArray * servicePgrList;///<服务进度列表
@property(nonatomic,strong)NSMutableArray * logList;///<日志列表
@property(nonatomic,strong)NSMutableArray * visitRecordList;///<回访记录列表
@property(nonatomic,strong)NSArray * areaList;///<地区
@property(nonatomic,copy)NSString * cancleInfo;///<取消原因

/*
 工单详情
 */
- (void)getRepairOrderDetial:(NSString*)repairID completionBlock:(BoolBlock)block;
/*
 接受工单
 */
- (void)receiveReapairId:(NSString*)repairId completionBlock:(BoolBlock)block;

/*
 查看设备详情
 */
- (void)showEqumentId:(NSString*)equmentId completionBlock:(BoolBlock)block;
/*
 开始服务
 */
- (void)startServiceRepair:(NSDictionary*)parameter completionBlock:(BoolBlock)block;

/*
 添加设备
 */
- (void)addEqumentInfo:(NSDictionary*)parameter completionBlock:(BoolBlock)block;
/*
 添加留言
 */
- (void)addRepairLeavelMessage:(NSDictionary*)parameter completionBlock:(BoolBlock)block;

/*
 留言列表
 */
- (void)getRepairDetialLeavelMsg:(NSString*)repairId completionBlock:(BoolBlock)block;

/*
 留言详情
 */
- (void)getRepairLeavelMsgInfoWithMsgID:(NSString*)msgId completionBlock:(BoolBlock)block;


/*
 保存进度
 */
- (void)saveServiceProgress:(NSDictionary*)parameter completionBlock:(BoolBlock)block;

/*
 查看服务进度列表
 */
- (void)showServiceProgressList:(NSString*)reapirId completionBlock:(BoolBlock)block;

/*
查看进度详情
 */
- (void)showServicePgrInfo:(NSString*)processId completionBlock:(BoolBlock)block;

/*
 查看保存的进度草稿
 */
- (void)showServicePgrDraftWithOrderId:(NSString*)orderId completionBlock:(BoolBlock)block;

/*
 完成服务
 */
- (void)finishServicePgrParameter:(NSDictionary*)parameter completionBlock:(BoolBlock)block;

/*
 工单日志列表
 */
- (void)getRepairLogListOrderId:(NSString*)orderId completionBlock:(BoolBlock)block;

/*
回访记录
 */
- (void)getRepairVisitRecordList:(NSString*)orderId completionBlock:(BoolBlock)block;

/*
 获取地区信息
 */
- (void)getAreaList:(NSString*)areaCode completionBlock:(BoolBlock)block;

/*
 取消工单详情
 */
- (void)getOrderCancleInfo:(NSString*)orderId completionBlock:(BoolBlock)block;

@end

NS_ASSUME_NONNULL_END
