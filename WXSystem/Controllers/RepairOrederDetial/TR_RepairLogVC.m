//
//  TR_RepairLogVC.m
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairLogVC.h"
#import "TR_RepairLogCell.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_LogModel.h"

@interface TR_RepairLogVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@end
static NSString * cellId = @"cellID";

@implementation TR_RepairLogVC
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=UIColor.whiteColor;
    [self table];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getLogList];
}
- (void)getLogList{
    WS(weakSelf);
     [[TR_LoadingHUD sharedHud]show];
    [self.viewModel getRepairLogListOrderId:self.repairOrderID completionBlock:^(BOOL flag, NSString *error) {
         [[TR_LoadingHUD sharedHud]dismiss];
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.logList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairLogCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[TR_RepairLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell showRepairlogCellWithData:self.viewModel.logList[indexPath.row] isFirstRow:indexPath.row==0?YES:NO isLastRow:indexPath.row==(self.viewModel.logList.count-1)?YES:NO index:indexPath.row];
    return cell;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        
        [self.view addSubview:_table];
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 30;
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, self.repairType==RepairOD_Type_Finish?0:60+kSafeAreaBottomHeight);
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairLogCell" bundle:nil] forCellReuseIdentifier:cellId];
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
