//
//  TR_RepairMessageVC.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
/*
 工单留言模块
 */

#import "TR_RepairMessageVC.h"
#import "TR_RerpairMessageCell.h"
#import "TR_RepairMessageDetialVC.h"
#import "TR_LesvelMsgModel.h"
#import "TR_RepairDetialViewModel.h"

@interface TR_RepairMessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@end
static NSString  * cellID= @"cellID";

@implementation TR_RepairMessageVC
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=UIColor.whiteColor;
    [self table];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getMessageList];
}
#pragma mark-------刷新列表数据
- (void)reloadMessageLsit{
      [self getMessageList];
}
- (void)getMessageList{
    WS(weakSelf);
     [[TR_LoadingHUD sharedHud]show];
    [self.viewModel getRepairDetialLeavelMsg:self.repairId completionBlock:^(BOOL flag, NSString *error) {
         [[TR_LoadingHUD sharedHud]dismiss];
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.leavelMsgList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_LesvelMsgModel * model = self.viewModel.leavelMsgList[indexPath.section];
    return [TR_RerpairMessageCell getCellHeightWithModel:model];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    TR_RerpairMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if ( cell == nil) {
        cell = [[TR_RerpairMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    TR_LesvelMsgModel * msgModel = self.viewModel.leavelMsgList[indexPath.section];
    cell.msgModel = msgModel;
    cell.seeMessageInfo = ^(NSString * _Nonnull messageId) {
        TR_RepairMessageDetialVC * vc = [[TR_RepairMessageDetialVC alloc]init];
        vc.msgId = messageId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.showBigPic = ^(NSInteger index) {
        NSLog(@"查看大图");
        [weakSelf showBigPicturesWithList:msgModel.picUrls index:index];
    };
    cell.seeFileInfo = ^(NSString * _Nonnull filePath, NSString * _Nonnull fileName) {
        [weakSelf openFileContent:filePath fileName:fileName];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SECTION_HEIGHT;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, SECTION_HEIGHT)];
    head.backgroundColor=COLOR_245;
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
    foot.backgroundColor=UIColor.redColor;
    return foot;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_table];
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, self.repairType==RepairOD_Type_Finish?0:60+kSafeAreaBottomHeight);
        [_table registerClass:[TR_RerpairMessageCell class] forCellReuseIdentifier:cellID];
    }
    return _table;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
@end
