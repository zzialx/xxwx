//
//  TR_AddEquMapVC.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddEquMapVC.h"
#import "TR_CardMapView.h"
#import "TR_RepairAddressSeaResultVC.h"
#import "TR_ReapirAddressFootView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface TR_AddEquMapVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AMapLocationManagerDelegate,TR_CardMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)TR_CardMapView * mapHeadView;
@property(nonatomic, strong) AMapLocationManager *locationManager;//定位管理器
@property(nonatomic, assign) NSInteger count;//定位回调次数统计
@property(nonatomic,strong)TR_ReapirAddressFootView * footView;
@property (nonatomic,strong) AMapSearchAPI * search;///<周边搜索
@property (nonatomic, assign) CGFloat latitude;///<纬度
@property (nonatomic, assign) CGFloat longitude;///<经度
@property (nonatomic, copy) NSString * select_address;///<选择地址
@property (nonatomic, copy) NSString * select_longitude;
@property (nonatomic, copy) NSString * select_latitude;
@property (nonatomic, copy) NSString * poiSearchKey;
@property (nonatomic, strong)NSMutableArray * searchList;
@end

@implementation TR_AddEquMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavUI];
    [self table];
    self.count=0;
    [self alwaysLoaction];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.searchList=[NSMutableArray arrayWithCapacity:0];
}
- (void)setNavUI{
    [self.navView setTitle:@""];
    self.navView.lblLeft.hidden=YES;
  
    [self.navView.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.navView.rightBtn setTitleColor:UICOLOR_RGBA(25, 140, 255) forState:UIControlStateNormal];
    self.navView.rightBtn.titleLabel.font=FONT_TEXT(14);
    self.navView.rightBtn.frame=CGRectMake(KScreenWidth - 55, self.navView.rightBtn.origin.y, 40, self.navView.rightBtn.size.height);
    [self.navView.rightBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navView addSubview:searchBtn];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchBtn"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchBtn"] forState:UIControlStateHighlighted];
    searchBtn.sd_layout.leftSpaceToView(self.navView.leftImg, 0)
    .rightSpaceToView(self.navView.rightBtn, 0)
    .heightIs(32.5)
    .centerYEqualToView(self.navView.leftImg);
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)finishAction{
    BLOCK_EXEC(self.getAddress,self.select_address,self.select_longitude,self.select_latitude);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction{
    TR_RepairAddressSeaResultVC * vc  = [[TR_RepairAddressSeaResultVC alloc]init];
    vc.city=@"南京";
    vc.getSearchAddress = ^(NSString * _Nonnull address, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
        BLOCK_EXEC(self.getAddress,address,longitude,latitude)
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)leftBtnClicked:(UIButton *)sender{
    [self.locationManager stopUpdatingLocation];
    self.count=0;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
#pragma mark - 持续定位
-(void)alwaysLoaction{
    //初始化定位管理器
    self.locationManager = [[AMapLocationManager alloc]init];
    // 设置代理对象
    self.locationManager.delegate = self;
    // 设置反地理编码
    self.locationManager.locatingWithReGeocode = YES;
    //开启持续定位
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    [self.locationManager startUpdatingLocation];
    
}
#pragma mark------MapViewDeledate---
- (void)getMapMineCenter{
    [self.mapHeadView setMapLocationLongitude:[NSString stringWithFormat:@"%lf",self.longitude] latitude:[NSString stringWithFormat:@"%lf",self.latitude] level:10];
}
#pragma mark - 定位2个代理方法
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    NSLog(@"我是个倒霉蛋，我不会被调用");
    
}
//若实现了下面的回调，将不会再回调amapLocationManager:didUpdateLocation:方法。
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"位置信息====%@",location);
    if (self.count==1) {
        return;
    }
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
   
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
           [self getLocationPOISearch:reGeocode];
    }
    if (reGeocode.formattedAddress.length==0) {
        //获取地图的地理位置
        self.mapHeadView.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.mapHeadView.latitude, self.mapHeadView.longitude);
    }else{
        //设置中心点
        self.mapHeadView.mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    }
}
- (void)getLocationPOISearch:(AMapLocationReGeocode*)reGeocode{
    NSLog(@"搜索关键字====%@",reGeocode.POIName);
    //周边搜索
    self.poiSearchKey = reGeocode.POIName;
    [self getPOISearchWithKey:reGeocode.POIName page:1];
}
- (void)getPOISearchWithKey:(NSString*)key page:(NSInteger)page{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location  = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords  = key;
    /* 按照距离排序. */
    request.sortrule   = 0;
    request.page=page;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        return;
    }
     self.count++;
    [self.searchList addObjectsFromArray:response.pois];
    [self.footView reloadData:self.searchList];
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
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-285-KNAV_HEIGHT)];
        [headView addSubview:self.mapHeadView];
        _table.tableHeaderView=headView;
        _table.tableFooterView = self.footView;
        }
    return _table;
}

- (TR_CardMapView*)mapHeadView{
    if (IsNilOrNull(_mapHeadView)) {
        _mapHeadView = [[TR_CardMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-285-KNAV_HEIGHT) withCompanyList:@[@""]];
        _mapHeadView.delegate = self;
    }
    return _mapHeadView;
}
- (TR_ReapirAddressFootView*)footView{
    if (IsNilOrNull(_footView)) {
        _footView = [[TR_ReapirAddressFootView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 285)];
        WS(weakSelf);
        _footView.selectAddress = ^(NSString * _Nonnull address, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
            weakSelf.select_address = address;
            weakSelf.select_latitude=latitude;
            weakSelf.select_longitude=longitude;
        };
        _footView.loadMoreData = ^(NSInteger page) {
            NSLog(@"页面===%ld",page);
            [weakSelf getPOISearchWithKey:weakSelf.poiSearchKey page:page];
        };
    }
    return _footView;
}
- (void)updateCurrentAddress:(NSString*)currentAddress{
    NSLog(@"地址===%@",currentAddress);
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
