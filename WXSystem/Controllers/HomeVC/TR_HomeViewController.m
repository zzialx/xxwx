//
//  TR_HomeViewController.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_HomeViewController.h"
#import "TR_HomeViewModel.h"
#import "TR_VersionModel.h"
#import "TR_VersionView.h"
#import "TR_HomeOrderCell.h"
#import "TR_HomeHeadLogoCell.h"
#import "TR_HomeHeadView.h"
#import "TR_RepairOrderViewController.h"

@interface TR_HomeViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property(nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) TR_HomeViewModel *homeViewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong,nonatomic) TR_VersionModel *versionModel;
@property (strong, nonatomic) TR_VersionView *versionView;
@property (nonatomic, copy) NSString * latitude;///<纬度
@property (nonatomic, copy) NSString * longitude;///<经度
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,copy)NSString * address;
@end
static NSString * cell_head = @"cell_head";
static NSString * cell_order = @"cell_order";
static NSString * cell_outtime = @"cell_outtime";

@implementation TR_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [GVUserDefaults standardUserDefaults].macLogin = @"Y";
//    NSString *string = [NSString stringWithFormat:@"%@?token=%@&platform=APP",SOCKET_URL,[GVUserDefaults standardUserDefaults].token];
//    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:[NSString stringWithFormat:@"%@",string]];//打开soket
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:@"kWebSocketDidOpenNote" object:nil];
    [self.navView setTitle:@""];
    self.count=0;
    //获取数据
    [self getAllSourceData];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0,*)) {
        //设置tableView置顶效果
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    //获取定位信息
    [self alwaysLoaction];
    //监测版本更新
    [self getVersionStatus];
}
- (void)appBecomeActive{
    if (TR_LOGIN) {
    
    }
}
-(void)alwaysLoaction{
    //初始化定位管理器
    self.locationManager = [[AMapLocationManager alloc]init];
    // 设置代理对象
    self.locationManager.delegate = self;
    // 设置反地理编码
    self.locationManager.locatingWithReGeocode = YES;
    //开启持续定位
    [self.locationManager startUpdatingLocation];
}
- (void)getVersionStatus
{
    NSDictionary *dic = @{@"versionCode":kBundleVersionString,@"systemType":@"2"};
    [self.homeViewModel getVersionStatus:dic completionBlock:^(TR_Model *model, NSString *error) {
        if (model) {
            self.versionModel = (TR_VersionModel *)model;
            if ([self.versionModel.versionRule isEqualToString:@"1"] || [self.versionModel.versionRule isEqualToString:@"2"]) {
                [self.versionView showChannelChooseView:self.versionModel];
            } else {
                [TRHUDUtil showMessageWithText:error];
            }
        }
    }];
}
- (void)uploadAreaLocation{
    NSDictionary * parameter = @{@"addr":MakeStringNotNil(self.address),
                                 @"longitude":MakeStringNotNil(self.longitude),
                                 @"latitude":MakeStringNotNil(self.latitude)
                                 };
    [self.homeViewModel upLoadLocation:parameter completionBlock:^(BOOL flag, NSString *error) {
        if (!flag) {
             [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (void)SRWebSocketDidOpen
{
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
}
-(void)getSocketStatus{
   
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.tabBarController.tabBar.hidden) {
        self.tabBarController.tabBar.hidden = NO;
    }
    if (TR_LOGIN) {
        [self getAllSourceData];
    }
}

- (void)getAllSourceData
{
    WS(weakSelf);
    [self.homeViewModel getHomeRepairNumberCompletionBlock:^(BOOL flag, NSString *error) {
        SS(strongSelf);
        [strongSelf.tableView endRefreshing];
        if (flag) {
            [strongSelf.tableView reloadData];
        } else {
            if (error) {
                [TRHUDUtil showMessageWithText:error];
            }
        }
    }];
}
#pragma mark----------LocationDeledate----
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    self.latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    if (reGeocode) {
        self.count++;
        if (self.count==1) {
            self.address = reGeocode.formattedAddress;
            [self uploadAreaLocation];
        }
    }
}
#pragma mark------TableDeleate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    WS(weakSelf);
    if (indexPath.section==0) {
        TR_HomeHeadLogoCell * logo_cell = [tableView dequeueReusableCellWithIdentifier:cell_head];
        if (logo_cell==nil) {
            logo_cell = [[TR_HomeHeadLogoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_head];
        }
        cell = logo_cell;
    }if (indexPath.section==1) {
        TR_HomeOrderCell * order_cell = [[TR_HomeOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_order type:@"1"];
        order_cell.clickHomeItem = ^(OrderType type) {
            [weakSelf pushRepairOrderList:type];
        };
        order_cell.homeModel=self.homeViewModel.homeModel;
        cell = order_cell;
    }if (indexPath.section==2) {
        TR_HomeOrderCell * time_cell = [[TR_HomeOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_order type:@"2"];
        time_cell.clickHomeItem = ^(OrderType type) {
              [weakSelf pushRepairOrderList:type];
        };
        time_cell.homeModel=self.homeViewModel.homeModel;
        cell = time_cell;
    }
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TR_HomeHeadView * headView =(TR_HomeHeadView*) [[[NSBundle mainBundle]loadNibNamed:@"TR_HomeHeadView" owner:self options:nil]lastObject];
    if (section==2) {
        headView.titleLab.text=@"功能导航";
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 211;
    }
    return 130.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 64.0;
}
- (void)pushRepairOrderList:(OrderType)type{
    TR_RepairOrderViewController * vc = [[TR_RepairOrderViewController alloc]initWithType:type];
    [self.navigationController pushViewController:vc animated:YES hideBottomTabBar:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-STATUS_TABBAT_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TR_HomeHeadLogoCell" bundle:nil] forCellReuseIdentifier:cell_head];
        [_tableView registerClass:[TR_HomeOrderCell class] forCellReuseIdentifier:cell_order];
        WS(weakSelf);
        [_tableView addRefreshHeader:^(UIScrollView *scrollView) {
            [weakSelf getAllSourceData];
        }];
    }
    return _tableView;
}

- (TR_VersionView *)versionView
{
    if(IsNilOrNull(_versionView)) {
        _versionView = [[TR_VersionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _versionView;
}
- (TR_HomeViewModel *)homeViewModel
{
    if (IsNilOrNull(_homeViewModel)) {
        _homeViewModel = [[TR_HomeViewModel alloc]init];
    }
    return _homeViewModel;
}
@end
