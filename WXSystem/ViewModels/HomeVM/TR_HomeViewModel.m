//
//  TR_HomeViewModel.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_HomeViewModel.h"
#import "TR_HttpClient.h"
#import "TR_HomeModel.h"
#import "TR_RepairListModel.h"
@implementation TR_HomeViewModel

#pragma mark --检查token登录情况
-(void)checkLoginStatus:(NSDictionary *)parameters completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:CHECK_TOKENSTATUS withDic:parameters success:^(id requestDic, NSString *msg) {
        NSLog(@"%@",requestDic);
        BLOCK_EXEC(block,YES,nil);
       
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block, NO, errorInfo);
    }];
}

#pragma mark --获取首页子页面统计列表
- (void)getHomeList:(TR_DataLoadingType)type reparirType:(NSString*)repairType completionBlock:(BoolBlock)block{
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
   
    [TR_HttpClient postRequestUrlString:POST_HOME_LIST withDic:dictionary success:^(id requestDic, NSString *msg) {
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
- (void)getHomeSearchRepairList:(TR_DataLoadingType)type orderType:(NSString*)orderType searchKey:(NSString*)searchKey completionBlock:(BoolBlock)block{
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
                                  @"title":MakeStringNotNil(searchKey),
                                  @"type":MakeStringNotNil(orderType)
                                  };
    [TR_HttpClient postRequestUrlString:POST_HOME_LIST_SEARCH withDic:dictionary success:^(id requestDic, NSString *msg) {
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
- (void)getOrderSearchRepairList:(TR_DataLoadingType)type searchKey:(NSString*)searchKey completionBlock:(BoolBlock)block{
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
                                  @"title":MakeStringNotNil(searchKey)
                                  };
    [TR_HttpClient postRequestUrlString:POST_ORDER_LIST_SEARCH withDic:dictionary success:^(id requestDic, NSString *msg) {
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

- (void)getHomeRepairNumberCompletionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_HOME_COUNT withDic:@{} success:^(id requestDic, NSString *msg) {
        self.homeModel = [TR_HomeModel yy_modelWithJSON:requestDic];
         BLOCK_EXEC(block, YES,@"");
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block, nil, errorInfo);
    }];
}


-(void)getVersionStatus:(NSDictionary *)parameters completionBlock:(ModelBlock)block{
    [TR_HttpClient postRequestUrlString:POST_VERSION withDic:parameters success:^(id requestDic, NSString *msg) {
        if (IsDictionaryClass(requestDic)) {
            TR_VersionModel *versionModel = [TR_VersionModel yy_modelWithDictionary:requestDic];
            if (versionModel){
                BLOCK_EXEC(block,versionModel,nil);
            } else {
                BLOCK_EXEC(block,nil,nil);
            }
        }else {
            BLOCK_EXEC(block,nil,nil);
        }
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block, nil, errorInfo);
    }];
}
- (void)upLoadLocation:(NSDictionary*)parameters completionBlock:(BoolBlock)block{
    [TR_HttpClient postRequestUrlString:POST_UPLOAD_AREA withDic:parameters success:^(id requestDic, NSString *msg) {
        BLOCK_EXEC(block,YES,nil);
    } failure:^(NSString *errorInfo) {
        BLOCK_EXEC(block,NO,errorInfo);
    }];
}

@end
