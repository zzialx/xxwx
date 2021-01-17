//
//  TR_RepairVisitRecordVC.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairVisitRecordVC.h"
#import "TR_RepairRecordHeadView.h"
#import "TR_RepairRecordCell.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_RepairVisitModel.h"
@interface TR_RepairVisitRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@end
static NSString * cellId = @"cellID";
@implementation TR_RepairVisitRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.viewModel getRepairVisitRecordList:self.repairOrderID completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.visitRecordList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[TR_RepairRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.indexPath=indexPath;
    cell.visitModel=self.viewModel.visitRecordList[indexPath.section];
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TR_RepairRecordHeadView * headView =(TR_RepairRecordHeadView*) [[[NSBundle mainBundle]loadNibNamed:@"TR_RepairRecordHeadView" owner:self options:nil] lastObject];
    headView.visitModel=self.viewModel.visitRecordList[section];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
    foot.backgroundColor=UIColor.redColor;
    return foot;
}
-(UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_table];
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 60;
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, self.repairType==RepairOD_Type_Finish?0:60+kSafeAreaBottomHeight);
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairRecordCell" bundle:nil] forCellReuseIdentifier:cellId];
    }
    return _table;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
