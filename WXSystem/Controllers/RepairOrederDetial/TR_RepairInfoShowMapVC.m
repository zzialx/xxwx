//
//  TR_RepairInfoShowMapVC.m
//  WXSystem
//
//  Created by admin on 2019/12/6.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairInfoShowMapVC.h"
#import "TR_CardMapView.h"
#import "TR_MapAddressView.h"
#import "LocationManager.h"
#import "TR_LocationModel.h"
@interface TR_RepairInfoShowMapVC ()<UITableViewDelegate,UITableViewDataSource,TR_CardMapViewDelegate>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)TR_CardMapView * mapHeadView;
@property(nonatomic,strong)TR_MapAddressView * footView;
@property(nonatomic,strong)UILabel * addressLab;
@property(nonatomic, strong)TR_LocationModel *locationModel;///<定位对象存储在

@end

@implementation TR_RepairInfoShowMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.navView setTitle:@"位置"];
    [self table];
      [[LocationManager shareInstance] addObserver:self forKeyPath:@"locationModel" options:NSKeyValueObservingOptionNew context:nil];
}
#pragma mark---------监听定位地址变化------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.locationModel = [change objectForKey:@"new"];
    NSLog(@"监听地址====%@",self.locationModel.addr);
}
- (void)setEqumentModel:(TR_EqumentModel *)equmentModel{
    [self.mapHeadView setMapLocationLongitude:equmentModel.longitude latitude:equmentModel.latitude level:equmentModel.level.integerValue];
    self.footView.addressLab.text = equmentModel.serviceAddr;
}
- (void)setInfo:(TR_RepairDetialModel *)info{
    [self.mapHeadView setMapLocationLongitude:info.latitude latitude:info.longitude level:info.level];
    self.footView.addressLab.text = info.serviceAddr;
}
#pragma mark------MapViewDeledate---
- (void)getMapMineCenter{
     [self.mapHeadView setMapLocationLongitude:self.locationModel.longitude latitude:self.locationModel.latitude level:10];
}

#pragma mark-----TableViewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_table];
        _table.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.navView, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, kSafeAreaBottomHeight);
        _table.delegate=self;
        _table.dataSource=self;
        _table.scrollEnabled=NO;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-102-KNAV_HEIGHT)];
        [headView addSubview:self.mapHeadView];
        _table.tableHeaderView=headView;
        _table.tableFooterView =[UIView new];
    }
    return _table;
}
- (TR_MapAddressView*)footView{
    if (IsNilOrNull(_footView)) {
        _footView = (TR_MapAddressView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_MapAddressView" owner:self options:nil]lastObject];
        [self.view addSubview:_footView];
        _footView.frame=CGRectMake(0, KScreenHeight-102, KScreenWidth, 102);
    }
    return _footView;
}
- (TR_CardMapView*)mapHeadView{
    if (IsNilOrNull(_mapHeadView)) {
        _mapHeadView = [[TR_CardMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-102-KNAV_HEIGHT) withCompanyList:nil];
        _mapHeadView.delegate=self;
    }
    return _mapHeadView;
}
- (void)dealloc{
    [[LocationManager shareInstance] removeObserver:self forKeyPath:@"locationModel" context:nil];
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
