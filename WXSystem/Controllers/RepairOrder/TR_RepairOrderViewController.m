//
//  TR_RepairOrderViewController.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_RepairOrderViewController.h"
#import "TR_RepairOrderCell.h"
#import "TR_RepairSearchVC.h"
#import "TR_RepairOrderRootVC.h"
#import "TR_RepairLeaveMsgVC.h"
#import "TR_AddRepairProgressVC.h"
#import "TR_AddEquipmentInfoVC.h"
#import "TR_RepairCancleVC.h"
#import "TR_HomeViewModel.h"
#import "TR_RepairListModel.h"

@interface TR_RepairOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TR_HomeViewModel * homeVM;
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,assign)OrderType repairOrderType;
@property(nonatomic,copy)NSString * repairType;
@end
static NSString * cell_order = @"cell_order";

@implementation TR_RepairOrderViewController
- (instancetype)initWithType:(OrderType)type{
    self = [super init];
    if(self){
        self.repairOrderType = type;
        [self setRequestType];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_245;
    [self.navView setTitle:[self titleWithType:self.repairOrderType]];
    self.navView.rightImg.image = [UIImage imageNamed:@"search"];
    [self.navView.rightImg addClickEvent:self action:@selector(goSearch)];
    [self table];
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self loadRefreshData];
   
}
- (void)loadRefreshData{
    self.homeVM.hasMoreContent = YES;
    [self fetchQuestionList:TR_DataLoadingTypeRefresh];
}
- (void)loadInfiniteData{
    [self fetchQuestionList:TR_DataLoadingTypeInfinite];
}
- (void)fetchQuestionList:(TR_DataLoadingType)type{
    WS(weakSelf);
    [self.homeVM getHomeList:type reparirType:self.repairType completionBlock:^(BOOL flag, NSString *error) {
        [weakSelf.table endRefreshing];
        if (flag) {
            if ([weakSelf.homeVM numberOfRowsCount] == 0) {
                weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NODATA];
            }else{
                weakSelf.table.tableFooterView = [UIView new];
            }
            [weakSelf.table reloadData];
            
            if ([weakSelf.homeVM hasMoreQuestion]) {
                [weakSelf.table resetNoMoreData];
            } else {
                [weakSelf.table endRefreshingWithNoMoreData];
            }
        }else{
            weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NODATA];
            [weakSelf.table reloadData];
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (void)goSearch{
    TR_RepairSearchVC * vc = [[TR_RepairSearchVC alloc]initWithType:self.repairOrderType];
    vc.type=[NSString stringWithFormat:@"%ld",(NSInteger)self.repairOrderType+1];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)leftBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homeVM.infoArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 167;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_order];
    if (cell==nil) {
        cell=[[TR_RepairOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_order];
    }
    cell.model = self.homeVM.infoArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairListModel * model = self.homeVM.infoArray[indexPath.section];
    TR_RepairOrderRootVC * vc = [[TR_RepairOrderRootVC alloc]init];
    vc.repairOrderId = model.orderId;
    if ([model.nowStatusName isEqualToString:@"待接单"]) {
        vc.repairType = RepairOD_Type_Wait_Receive;
    } if ([model.nowStatusName isEqualToString:@"待服务"]) {
        vc.repairType = RepairOD_Type_Wait_Service;
    } if ([model.nowStatusName isEqualToString:@"已完成"]) {
        vc.repairType = RepairOD_Type_Finish;
    }if ([model.nowStatusName isEqualToString:@"服务中"]) {
        vc.repairType = RepairOD_Type_In_Service;
    }if ([model.nowStatusName isEqualToString:@"已取消"]) {
        vc.repairType = RepairOD_Type_Cancle;
    }if ([model.nowStatusName isEqualToString:@"待回访"]) {
        vc.repairType = RepairOD_Type_Wait_Visit;
    }
    WS(weakSelf);
    vc.reloadOrderList = ^{
        [weakSelf loadRefreshData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
- (UITableView*)table{
    if (_table==nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(15, KNAV_HEIGHT, KScreenWidth-30, KScreenHeight-KNAV_HEIGHT) style:UITableViewStyleGrouped];
        [self.view addSubview:_table];
        _table.delegate=self;
        _table.dataSource=self;
        _table.estimatedRowHeight = 167;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairOrderCell" bundle:nil] forCellReuseIdentifier:cell_order];
        _table.backgroundColor=COLOR_245;
        WS(weakSelf);
        [_table addRefreshHeader:^(UIScrollView *scrollView) {
            [weakSelf loadRefreshData];
        }];
        [_table addRefreshFooter:^(UIScrollView *scrollView) {
            [weakSelf loadInfiniteData];
        }];
    }
    return _table;
}
- (NSString*)titleWithType:(OrderType)type{
    NSString * title= @"待我接单";
    if (type == OrderType_Receive) {
        title=@"待我接单";
    }else if (type == OrderType_Finish) {
        title=@"待我完成";
    }else if (type == OrderType_Service) {
        title=@"待我服务";
    }else if (type == OrderType_OutTime) {
        title=@"逾期工单";
    }
    return title;
}
- (void)setRequestType{
    if (self.repairOrderType==OrderType_Receive) {
        self.repairType = @"1";
    }if (self.repairOrderType==OrderType_Service) {
        self.repairType = @"2";
    }if (self.repairOrderType==OrderType_Finish) {
        self.repairType = @"3";
    }if (self.repairOrderType==OrderType_OutTime) {
        self.repairType = @"4";
    }
}
- (TR_HomeViewModel*)homeVM{
    if (IsNilOrNull(_homeVM)) {
        _homeVM=[[TR_HomeViewModel alloc]init];
    }
    return _homeVM;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
