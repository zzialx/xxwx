//
//  TR_RepairAddressSeaResultVC.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairAddressSeaResultVC.h"
#import "TR_SearchBar.h"
#import "TR_RepairAddressSeaCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "TR_AddEquMapVC.h"

@interface TR_RepairAddressSeaResultVC ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property(nonatomic,strong)TR_SearchBar * searchBar;
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSMutableArray * searchResultList;
@property(nonatomic,strong)NSString * searchKey;
@property(nonatomic,strong)AMapSearchAPI * search;
@property(nonatomic,assign)NSInteger page;
@end
static NSString * cell_searchID = @"cell_searchID";
@implementation TR_RepairAddressSeaResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=COLOR_245;;
    [self searchBar];
    [self.searchBar.searchTF becomeFirstResponder];
    [self table];
    self.searchResultList=[NSMutableArray arrayWithCapacity:0];
    self.page=1;
    //poi搜索
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}
- (void)getSeacrchData{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            =  self.searchKey;
    request.city                = self.city;
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    request.page=self.page;
    [self.search AMapPOIKeywordsSearch:request];

}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [self.searchResultList addObjectsFromArray:response.pois];
    [self.view endEditing:YES];
    //停止刷新
    self.table.tableFooterView = [UIView new];
    [self.table reloadData];
    [self.table endRefreshing];
    //解析response获取POI信息，具体解析见 Demo
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark---------TABLEDELEDATE-------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairAddressSeaCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_searchID];
    if (cell == nil) {
        cell = [[TR_RepairAddressSeaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_searchID];
    }
    AMapPOI * poiModel = self.searchResultList[indexPath.row];
    [cell showCellName:poiModel.name address:poiModel.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * vcList = self.navigationController.viewControllers;
    NSMutableArray * tempList = [NSMutableArray arrayWithArray:vcList];
    for (UIViewController * vc  in tempList) {
        if ([vc isKindOfClass: [TR_AddEquMapVC class]]) {
            [tempList removeObject:vc];
            break;
        }
    }
    AMapPOI * poiModel = self.searchResultList[indexPath.row];
    BLOCK_EXEC(self.getSearchAddress,poiModel.address,[NSString stringWithFormat:@"%f",poiModel.location.longitude],[NSString stringWithFormat:@"%f",poiModel.location.latitude]);
    self.navigationController.viewControllers = tempList;
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView*)table{
    if (_table==nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_table];
        _table.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.searchBar, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 60;
        _table.separatorColor=UICOLOR_RGBA(242, 242, 242);
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairAddressSeaCell" bundle:nil] forCellReuseIdentifier:cell_searchID];
        _table.backgroundColor=COLOR_245;
        WS(weakSelf);
        [_table addRefreshFooter:^(UIScrollView *scrollView) {
            weakSelf.page++;
            [weakSelf getSeacrchData];
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
            [weakSelf getSeacrchData];
        };
    }
    return _searchBar;
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
