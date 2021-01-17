//
//  TR_RepairViewModel.m
//  WXSystem
//
//  Created by admin on 2019/12/2.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairViewModel.h"
#import "TR_RepairListModel.h"

@implementation TR_RepairViewModel
- (void)getOrderHeadNumberCompletionBlock:(BoolBlock)block{
    NSDictionary * dic = @{};
    WS(weakSelf);
    [TR_HttpClient postRequestUrlString:POST_ORDER_HEAD withDic:dic success:^(id requestDic, NSString *msg) {
        weakSelf.headModel=[TR_OrderHeadModel yy_modelWithJSON:requestDic];
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}
- (void)getOrderList:(TR_DataLoadingType)type reparirType:(NSString*)repairType completionBlock:(BoolBlock)block{
    WS(weakSelf);
    //设置标志位
    if (type == TR_DataLoadingTypeRefresh) {
        if (self.isRefreshing){
            return;
        } else {
            self.isRefreshing = YES;
        }
    } else {
        if (self.isLoadingMore) {
            return;
        } else {
            self.isLoadingMore = YES;
        }
    }
    NSInteger currentPage = [self lastPageString:type];
    NSDictionary * dictionary = @{kPageNum:@(currentPage),
                                  kPageSize:@(self.page.pageSize),
                                  @"type":MakeStringNotNil(repairType)
                                  };;
    
    [TR_HttpClient postRequestUrlString:POST_ORDER_LIST withDic:dictionary success:^(id requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic) && requestDic[@"records"]) {
            SS(strongSelf);
            NSArray *array = [NSArray yy_modelArrayWithClass:[TR_RepairListModel class] json:requestDic[@"records"]];
            if (IsArrayClass(array)) {
                //重置请求标志位
                if (type == TR_DataLoadingTypeRefresh) {
                    strongSelf.isRefreshing = NO;
                } else {
                    strongSelf.isLoadingMore = NO;
                }
                if (self.hasMoreContent == YES) {
                    if (currentPage == 1) {
                        [strongSelf.infoArray removeAllObjects];
                    }
                    [strongSelf.infoArray addObjectsFromArray:array];
                }
                // 更新更多内容标志位
                if (array.count == kpageOfSize) {
                    strongSelf.hasMoreContent = YES;
                } else {
                    strongSelf.hasMoreContent = NO;
                }
                BLOCK_EXEC(block,YES,msg);
            } else {
                weakSelf.isRefreshing = NO;
                BLOCK_EXEC(block, NO, @"");
            }
        }else{
            BLOCK_EXEC(block, NO, msg);
        }
    } failure:^(NSString *errorInfo) {
        self.isRefreshing = NO;
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

@end
