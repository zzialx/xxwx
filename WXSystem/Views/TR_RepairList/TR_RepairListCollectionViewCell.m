//
//  TR_NoticeListCollectionViewCell.m
//  WXSystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_RepairListCollectionViewCell.h"
#import "TR_NoticeListTableViewCell.h"
#import "TR_RepairOrderCell.h"
#import "TR_RepairViewModel.h"
#import "TR_RepairListModel.h"
#import "TR_NODateView.h"
@interface TR_RepairListCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (copy, nonatomic) NSString *colCode;
@property (copy, nonatomic) NSString *readed;//阅读状态
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic)TR_RepairViewModel * viewModel;
@property (strong, nonatomic)TR_NODateView *noDataView;
@end

@implementation TR_RepairListCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.haveLoad = NO;
        self.readed = @"";
        self.colCode = @"";
        self.title = @"";
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 0, frame.size.width - 15*2, frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_245;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setHeightWithSystemVersion];
        [self.contentView addSubview:self.tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"TR_RepairOrderCell" bundle:nil] forCellReuseIdentifier:@"TR_RepairOrderCell"];
        WS(weakSelf);
        [_tableView addRefreshHeader:^(UIScrollView *scrollView) {
            [weakSelf loadRefreshData];
        }];
        [_tableView addRefreshFooter:^(UIScrollView *scrollView) {
            [weakSelf loadInfiniteData];
        }];
    }
    return self;
}

- (void)loadRefreshData
{
    self.viewModel.hasMoreContent=YES;
    [self fetchQuestionList:TR_DataLoadingTypeRefresh];
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(reloadHeadTitle)]) {
        [self.cellDelegate reloadHeadTitle];
    }
}

- (void)loadInfiniteData
{
    [self fetchQuestionList:TR_DataLoadingTypeInfinite];
}

- (void)fetchQuestionList:(TR_DataLoadingType)type{
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud] show];
    [self.viewModel getOrderList:type reparirType:self.colCode completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud]dismiss];
        [weakSelf.tableView endRefreshing];
        if (flag) {
            if ([weakSelf.viewModel numberOfRowsCount] == 0) {
                weakSelf.tableView.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NODATA];
            }else{
                weakSelf.tableView.tableFooterView = [UIView new];
            }
            [weakSelf.tableView reloadData];
            if ([weakSelf.viewModel hasMoreQuestion]) {
                [weakSelf.tableView resetNoMoreData];
            } else {
                [weakSelf.tableView endRefreshingWithNoMoreData];
            }
        }else{
            weakSelf.tableView.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NODATA];
            [weakSelf.tableView reloadData];
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}


-(void)loadWithColCode:(NSString *)colCode title:(nonnull NSString *)title{
    self.colCode = colCode;
    self.title = title;
    [self loadRefreshData];
}
-(void)loadReadedStatus:(NSString *)status{
    [self loadRefreshData];
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.infoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TR_RepairOrderCell" forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[TR_RepairOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TR_RepairOrderCell"];
    }
    cell.model=self.viewModel.infoArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    head.backgroundColor=COLOR_245;
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RepairOD_Type orderType = RepairOD_Type_Wait_Receive;
    TR_RepairListModel * model = self.viewModel.infoArray[indexPath.section];
    if ([model.nowStatusName isEqualToString:@"待接单"]) {
        orderType = RepairOD_Type_Wait_Receive;
    }if ([model.nowStatusName isEqualToString:@"待服务"]) {
        orderType = RepairOD_Type_Wait_Service;
    }if ([model.nowStatusName isEqualToString:@"服务中"]) {
        orderType = RepairOD_Type_In_Service;
    }if ([model.nowStatusName isEqualToString:@"已完成"]) {
        orderType = RepairOD_Type_Finish;
    }  if ([model.nowStatusName isEqualToString:@"待回访"]) {
        orderType = RepairOD_Type_Wait_Visit;
    }if ([model.nowStatusName isEqualToString:@"已取消"]) {
        orderType = RepairOD_Type_Cancle;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(didSelectRepairCell:orderType:)]) {
        [self.cellDelegate didSelectRepairCell:model.orderId orderType:orderType];
    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 167;
}
- (TR_RepairViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel=[[TR_RepairViewModel alloc]init];
    }
    return _viewModel;
}
- (TR_NODateView *)noDataView
{
    _noDataView = nil;
    if (!_noDataView) {
        _noDataView = [[TR_NODateView alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT)];
    }
    return _noDataView;
}
@end
