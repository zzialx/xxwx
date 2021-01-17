//
//  TR_RepairDetialViewModel.m
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairDetialViewModel.h"
#import "TR_LesvelMsgModel.h"
#import "TR_ServicePgrModel.h"
#import "TR_LogModel.h"
#import "TR_RepairVisitModel.h"
#import "TR_AreaModel.h"
#import "TR_RepairServiceCell.h"
#import "TR_RepairProgressInfoCell.h"

@implementation TR_RepairDetialViewModel
- (void)getRepairOrderDetial:(NSString*)repairID completionBlock:(BoolBlock)block{
    WS(weakSelf);
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(repairID)};
    [TR_HttpClient postRequestUrlString:POST_DETIAL withDic:parameter success:^(id requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic)) {
            weakSelf.detialModel = [TR_RepairDetialModel yy_modelWithJSON:requestDic];
            BLOCK_EXEC(block,YES,@"");
        }else{
            BLOCK_EXEC(block,NO,msg);
        }
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)receiveReapairId:(NSString*)repairId completionBlock:(BoolBlock)block{
    NSDictionary * dic = @{@"orderId":MakeStringNotNil(repairId)};
    [TR_HttpClient postRequestUrlString:POST_DETIAL_RECEIVE withDic:dic success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)showEqumentId:(NSString*)equmentId completionBlock:(BoolBlock)block{
    NSDictionary * dic = @{@"equipmentId":MakeStringNotNil(equmentId)};
    [TR_HttpClient postRequestUrlString:POST_DETIAL_EUMENT withDic:dic success:^(id requestDic, NSString *msg) {
        self.equmentModel = [TR_EqumentModel yy_modelWithJSON:requestDic];
        self.equInfoList=[NSMutableArray arrayWithCapacity:0];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.equipmentName)];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.equipmentNum)];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.equipmentBrand)];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.equipmentModel)];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.serviceAddr)];
        [self.equInfoList addObject:MakeStringNotNil(self.equmentModel.addr)];
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)startServiceRepair:(NSDictionary*)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_DETIAL_SERVICE withDic:parameter success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)addEqumentInfo:(NSDictionary *)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_DETIAL_ADD_EQU withDic:parameter success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)addRepairLeavelMessage:(NSDictionary*)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_DETIAL_ADD_LEAMSG withDic:parameter success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)getRepairDetialLeavelMsg:(NSString*)repairId completionBlock:(BoolBlock)block{
    self.leavelMsgList = [NSMutableArray arrayWithCapacity:0];
    WS(weakSelf);
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(repairId)};
    [TR_HttpClient postRequestUrlString:POST_DETIAL_LSG_LIST withDic:parameter success:^(id requestDic, NSString *msg) {
        if (IsArrayClass(requestDic)) {
            weakSelf.leavelMsgList = [NSArray yy_modelArrayWithClass:[TR_LesvelMsgModel class] json:requestDic].mutableCopy;
        }
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getRepairLeavelMsgInfoWithMsgID:(NSString*)msgId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"messageId":MakeStringNotNil(msgId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_LSG_INFO withDic:parameter success:^(id requestDic, NSString *msg) {
        weakSelf.leavelMsgInfo = [TR_LesvelMsgModel yy_modelWithJSON:requestDic];
         BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);

    }];
}
- (void)saveServiceProgress:(NSDictionary*)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_DETIAL_SAVE_PGR withDic:parameter success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
        
    }];
}
- (void)showServiceProgressList:(NSString*)reapirId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(reapirId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_PGR_LIST withDic:parameter success:^(id requestDic, NSString *msg) {
        if (IsArrayClass(requestDic)) {
            weakSelf.servicePgrList = [NSArray yy_modelArrayWithClass:[TR_ServicePgrModel class] json:requestDic].mutableCopy;
        }
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
        
    }];
}
- (void)showServicePgrInfo:(NSString*)processId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"processId":MakeStringNotNil(processId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_PGR_INFO withDic:parameter success:^(id requestDic, NSString *msg) {
        weakSelf.servicePgrDeiModel = [TR_ServicePgrDetialModel yy_modelWithJSON:requestDic];
        CGFloat cellHeight = 0.0;
        if (weakSelf.servicePgrDeiModel.startAddr.length>0) {
            cellHeight += [TR_RepairServiceCell getCellHeight:weakSelf.servicePgrDeiModel.startAddr];
        }if (weakSelf.servicePgrDeiModel.beforeService.length>0) {
            //服务前和服务后的状态是成对出现的，单一不可能出现
            cellHeight += [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:weakSelf.servicePgrDeiModel.beforeService servicePic:weakSelf.servicePgrDeiModel.beforePicUrls];
            cellHeight += [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:weakSelf.servicePgrDeiModel.afterService servicePic:weakSelf.servicePgrDeiModel.afterPicUrls];
            cellHeight +=[TR_RepairServiceCell getCellHeight:weakSelf.servicePgrDeiModel.endAddr];
            cellHeight +=20.0;
        }
        weakSelf.servicePgrDeiModel.cellHeight = cellHeight;
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
        
    }];
}
- (void)showServicePgrDraftWithOrderId:(NSString*)orderId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(orderId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_PGR_DRAFT withDic:parameter success:^(id requestDic, NSString *msg) {
        weakSelf.servicePgrDeiModel = [TR_ServicePgrDetialModel yy_modelWithJSON:requestDic];
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)finishServicePgrParameter:(NSDictionary*)parameter completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_DETIAL_PGR_FINISH withDic:parameter success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getRepairLogListOrderId:(NSString*)orderId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(orderId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_LOG_LIST withDic:parameter success:^(id requestDic, NSString *msg) {
        weakSelf.logList = [NSArray yy_modelArrayWithClass:[TR_LogModel class] json:requestDic].mutableCopy;
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getRepairVisitRecordList:(NSString*)orderId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(orderId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_VISIT_LIST withDic:parameter success:^(id requestDic, NSString *msg) {
        TR_RepairVisitModel * model =[TR_RepairVisitModel yy_modelWithJSON:requestDic];
        weakSelf.visitRecordList=[NSMutableArray arrayWithCapacity:0];
        [weakSelf.visitRecordList  addObject:model];
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

- (void)getAreaList:(NSString*)areaCode completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"criCode":MakeStringNotNil(areaCode)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_AREA_LIST withDic:parameter success:^(id requestDic, NSString *msg) {
        weakSelf.areaList =[NSArray yy_modelArrayWithClass:[TR_AreaModel class] json:requestDic];
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}


- (void)getOrderCancleInfo:(NSString*)orderId completionBlock:(BoolBlock)block{
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(orderId)};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_DETIAL_CANCLE withDic:parameter success:^(id requestDic, NSString *msg) {
        if ([requestDic isKindOfClass:[NSString class]]) {
            weakSelf.cancleInfo = requestDic;
        }
        BLOCK_EXEC(block,YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}












@end
