//
//  TR_RepairSearchVC.m
//  WXSystem
//
//  Created by admin on 2019/11/12.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairSearchVC.h"
#import "TR_SearchBar.h"
#import "TR_RepairOrderCell.h"
#import "TR_HomeViewModel.h"
#import "TR_RepairListModel.h"

@interface TR_RepairSearchVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TR_SearchBar * searchBar;
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSArray * testArray;
@property(nonatomic,strong)NSString * searchKey;
@property(nonatomic,assign)OrderType repairOrderType;
@property(nonatomic,strong)TR_HomeViewModel * viewModel;
@end
static NSString * cell_order = @"cell_order";

@implementation TR_RepairSearchVC
- (instancetype)initWithType:(OrderType)type{
    self = [super init];
    if(self){
        self.repairOrderType = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=COLOR_245;;
    [self searchBar];
    [self.searchBar.searchTF becomeFirstResponder];
    [self table];
}
#pragma mark-----搜索
- (void)getAddressBookSearchList{
    [self loadRefreshData];
}
- (void)loadRefreshData{
    self.viewModel.hasMoreContent = YES;
    [self fetchQuestionList:TR_DataLoadingTypeRefresh];
}
- (void)loadInfiniteData{
    [self fetchQuestionList:TR_DataLoadingTypeInfinite];
}
- (void)fetchQuestionList:(TR_DataLoadingType)type{
    WS(weakSelf);
    if(self.type.length>0){
        //首页搜索
        [self.viewModel getHomeSearchRepairList:type orderType:self.type searchKey:self.searchKey completionBlock:^(BOOL flag, NSString *error) {
            [weakSelf.table endRefreshing];
            if (flag) {
                if ([weakSelf.viewModel numberOfRowsCount] == 0) {
                    weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NOSEARCH];
                }else{
                    weakSelf.table.tableFooterView = [UIView new];
                }
                [weakSelf.table reloadData];
                if ([weakSelf.viewModel hasMoreQuestion]) {
                    [weakSelf.table resetNoMoreData];
                } else {
                    [weakSelf.table endRefreshingWithNoMoreData];
                }
            
            }else{
                weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NOSEARCH];
                [weakSelf.table reloadData];
                if(self.searchKey.length==0&&[error isEqualToString:@"请输入您要搜索的内容！"]){
                    
                }else{
                    [TRHUDUtil showMessageWithText:error];
                }
                
            }
        }];
    }else{
        [self.viewModel getOrderSearchRepairList:type searchKey:self.searchKey completionBlock:^(BOOL flag, NSString *error) {
            [weakSelf.table endRefreshing];
            if (flag) {
                if ([weakSelf.viewModel numberOfRowsCount] == 0) {
                    weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NOSEARCH];
                }else{
                    weakSelf.table.tableFooterView = [UIView new];
                }
                [weakSelf.table reloadData];
                if ([weakSelf.viewModel hasMoreQuestion]) {
                    [weakSelf.table resetNoMoreData];
                } else {
                    [weakSelf.table endRefreshingWithNoMoreData];
                }
            }else{
                weakSelf.table.tableFooterView = [self.noDataView setNoDataType:NO_DATATYPE_NOSEARCH];
                [weakSelf.table reloadData];
                if(self.searchKey.length==0&&[error isEqualToString:@"请输入您要搜索的内容！"]){
                    
                }else{
                    [TRHUDUtil showMessageWithText:error];
                }
            }
        }];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



#pragma mark---------TABLEDELEDATE-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.infoArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_order];
    if (cell == nil) {
        cell = [[TR_RepairOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_order];
    }
    cell.model = self.viewModel.infoArray[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 167;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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

- (UITableView*)table{
    if (_table==nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_table];
        _table.sd_layout.leftSpaceToView(self.view, 15).topSpaceToView(self.searchBar, 0).rightSpaceToView(self.view, 15).bottomSpaceToView(self.view, 0);
        _table.delegate=self;
        _table.dataSource=self;
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
- (TR_SearchBar*)searchBar{
    if (_searchBar==nil) {
        _searchBar =(TR_SearchBar*) [[[NSBundle mainBundle]loadNibNamed:@"TR_SearchBar" owner:nil options:nil]lastObject];
        [self.view addSubview:_searchBar];
        _searchBar.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view,STATUS_BAR_HEIGHT).rightSpaceToView(self.view, 0).heightIs(50);
        WS(weakSelf);
        _searchBar.back = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _searchBar.searchPerson = ^(NSString * _Nonnull serchText) {
            //搜索内容
            weakSelf.searchKey = serchText;
//            if (weakSelf.searchKey.length>0) {
            [weakSelf getAddressBookSearchList];
//            }
        };
    }
    return _searchBar;
}
- (TR_HomeViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel =[[TR_HomeViewModel alloc]init];
    }
    return _viewModel;
}
- (UILabel*)showNoSearchView{
    UILabel * nulllab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,300)];
    nulllab.backgroundColor=UIColor.whiteColor;
    nulllab.textAlignment=NSTextAlignmentCenter;
    nulllab.font=FONT_TEXT(22);
    nulllab.textColor=UICOLOR_RGBA(160, 160, 160);
    nulllab.text=@"无搜索结果";
    return nulllab;
}

@end
