//
//  TR_RepairOrderRootVC.m
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairOrderRootVC.h"
#import "YNPageViewController.h"
#import "YNPageConfigration.h"
#import "BaseTableViewVC.h"
#import "TR_RepairOrderDetailHeadView.h"
#import "TR_RepairInfoVC.h"
#import "TR_RepairMessageVC.h"
#import "TR_RepairLogVC.h"
#import "TR_RepairFootView.h"
#import "TR_RepairServiceProcessVC.h"
#import "TR_RepairLeaveMsgVC.h"
#import "TR_RepairVisitRecordVC.h"
#import "TR_AddEquMapVC.h"
#import "TR_AddEquipmentInfoVC.h"
#import "TR_AddRepairProgressVC.h"
#import "TR_RepairCancleVC.h"
#import "TR_RepairDetialViewModel.h"
#import "LocationManager.h"
#import "TR_LocationModel.h"
#import "TR_RepairInfoShowMapVC.h"


#define FOOT_HEIGHT    60

@interface TR_RepairOrderRootVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>
@property(nonatomic,strong)TR_RepairFootView * footView;
@property(nonatomic,assign)BOOL isReceived;///<是否接收
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@property(nonatomic,strong)TR_RepairOrderDetailHeadView *headerView;///<头部信息
@property(nonatomic,strong)TR_RepairInfoVC * repairOrderInfoVC;
@property(nonatomic, strong) AMapLocationManager *locationManager;//定位管理器
@property (nonatomic, assign) CGFloat latitude;///<纬度
@property (nonatomic, assign) CGFloat longitude;///<经度
@property (nonatomic, copy)NSString * servieceAddress;///<服务地址
@property(nonatomic, strong)TR_LocationModel *locationModel;///<定位对象存储在
@property(nonatomic, strong)YNPageViewController *ynpage_vc;///<底部滚动
//全局的vc方便刷新页面
@property(nonatomic, strong)TR_RepairInfoVC * infoVC;
@property(nonatomic, strong)TR_RepairServiceProcessVC * progresVC;
@property(nonatomic, strong)TR_RepairMessageVC * msgVC;
@property(nonatomic, strong)TR_RepairLogVC * logVC;
@property(nonatomic, strong)TR_RepairVisitRecordVC * recordVC;

@end

@implementation TR_RepairOrderRootVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navView setTitle:@"工单详情"];
    self.isReceived = YES;
    self.locationModel=[[TR_LocationModel alloc]init];
    [self alwaysLoaction];
    [self suspendTopPageVC];
    [self.view bringSubviewToFront:self.navView];
    if (self.repairType!=RepairOD_Type_Finish) {
         [self footView];
    }
    [self getRepairDetialData];
}
#pragma mark----------工单详情接口-------
- (void)getRepairDetialData{
    WS(weakSelf);
    [self.viewModel getRepairOrderDetial:self.repairOrderId completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            weakSelf.headerView.detialModel = weakSelf.viewModel.detialModel;
            weakSelf.repairOrderInfoVC.detialInfoModel = weakSelf.viewModel.detialModel;
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (void)suspendTopPageVC {
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTop;
    configration.headerViewCouldScale = NO;
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
//    configration.pageScrollEnabled=NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.showBottomLine = NO;
    configration.selectedItemColor=UICOLOR_RGBA(24, 140, 255);
    configration.normalItemColor=COLOR_51;
    configration.itemFont=FONT_TEXT(15);
    configration.lineColor=UICOLOR_RGBA(24, 140, 255);
    
    
    NSArray * vcArray = [NSArray array];
    NSArray * titleArray = [NSArray array];
    if(self.repairType==RepairOD_Type_Wait_Receive||self.repairType==RepairOD_Type_Cancle){
        //3个vc
        vcArray = [self getThreeArrayVCs];
        titleArray = [self getThreeArrayTitles];
    }if(self.repairType==RepairOD_Type_Wait_Service||self.repairType==RepairOD_Type_In_Service
        ||self.repairType==RepairOD_Type_Wait_Visit){
        //4个vc
        vcArray=[self getFourArrayVCs];
        titleArray=[self getFourArrayTitles];
    } if(self.repairType==RepairOD_Type_Finish){
        //5个vc
        vcArray=[self getFiveArrayWithProgerssVCs];
        titleArray=[self getFiveArrayWithProgerssTitles];
    }
    
    if(self.repairType==RepairOD_Type_Finish){
        configration.itemMargin=12;
    }
   self.ynpage_vc= [YNPageViewController pageViewControllerWithControllers:vcArray
                                                                                titles:titleArray
                                                                                    config:configration];
    self.ynpage_vc.dataSource = self;
    self.ynpage_vc.delegate = self;
    self.headerView =[[TR_RepairOrderDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 422) initWithData:@""];
    self.ynpage_vc.headerView = self.headerView;
    WS(weakSelf);
    self.headerView.repairHeadAction = ^(RepairBtnType type) {
        if (type==RepairBtnType_Phone) {
            //打电话
            return ;
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",weakSelf.viewModel.detialModel.contactPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }if (type==RepairBtnType_Address) {
            TR_RepairInfoShowMapVC * vc = [[TR_RepairInfoShowMapVC alloc]init];
            vc.info = weakSelf.viewModel.detialModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    CGFloat vc_height = self.repairType==RepairOD_Type_Finish?0:FOOT_HEIGHT;
    self.ynpage_vc.view.frame = CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight-KNAV_HEIGHT-vc_height);
    [self.ynpage_vc addSelfToParentViewController:self];
}

#pragma mark --------------- 持续定位 ---------------
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
#pragma mark --------------- 定位2个代理方法 ---------------
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"我是个倒霉蛋，我不会被调用");
}
//若实现了下面的回调，将不会再回调amapLocationManager:didUpdateLocation:方法。
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
//    NSLog(@"位置信息====%@",location);
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    
    if (reGeocode)
    {
//        NSLog(@"reGeocode:%@", reGeocode);
        self.locationModel.addr =  reGeocode.formattedAddress;
        self.locationModel.longitude=[NSString stringWithFormat:@"%lf",self.longitude];
        self.locationModel.latitude=[NSString stringWithFormat:@"%lf",self.latitude];
        [[LocationManager shareInstance] setValue:self.locationModel forKey:@"locationModel"];
        self.servieceAddress = reGeocode.formattedAddress;
    }
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    if (index==0) {
        TR_RepairInfoVC * vc = pageViewController.controllersM[index];
        return [vc table];
    }
    if(self.repairType==RepairOD_Type_Wait_Receive||self.repairType==RepairOD_Type_Cancle){
        //3个vc
        if (index==1) {
            TR_RepairMessageVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }if(index==2){
            TR_RepairLogVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }
    }if(self.repairType==RepairOD_Type_Wait_Service||self.repairType==RepairOD_Type_In_Service
        ||self.repairType==RepairOD_Type_Wait_Visit){
        //4个vc
        if (index==1) {
            TR_RepairServiceProcessVC *vc = pageViewController.controllersM[index];
            return [vc table];
        }
        if (index==2) {
            TR_RepairMessageVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }if(index==3){
            TR_RepairLogVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }
    } if(self.repairType==RepairOD_Type_Finish){
        if (index==1) {
            TR_RepairServiceProcessVC *vc = pageViewController.controllersM[index];
            return [vc table];
        }
        if (index==2) {
            TR_RepairMessageVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }if(index==3){
            TR_RepairLogVC * vc = pageViewController.controllersM[index];
            return [vc table];
        }
    }
   
    TR_RepairVisitRecordVC* vc = pageViewController.controllersM[index];
    return [vc table];
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //        NSLog(@"--- contentOffset = %f,    progress = %f", contentOffset, progress);
}
- (TR_RepairFootView*)footView{
    if (IsNilOrNull(_footView)) {
        _footView = (TR_RepairFootView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_RepairFootView" owner:self options:nil]lastObject];
        [self.view addSubview:_footView];
        _footView.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(FOOT_HEIGHT)
        .bottomSpaceToView(self.view, kSafeAreaBottomHeight);
        _footView.detialType = self.repairType;
        WS(weakSelf);
        _footView.footAction = ^(Repair_Foot_Type actionType) {
            [weakSelf footActionWithType:actionType];
        };
    }
    return _footView;
}
#pragma mark--------Foot按钮事件-----
- (void)footActionWithType:(Repair_Foot_Type)actionType{
    WS(weakSelf);
    switch (actionType) {
        case Repair_Foot_Type_Leavel:{
            NSLog(@"添加留言");
            TR_RepairLeaveMsgVC * vc  = [[TR_RepairLeaveMsgVC alloc]init];
            vc.repairOrderID=self.repairOrderId;
            vc.reloadVC = ^{
                [weakSelf.msgVC reloadMessageLsit];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Repair_Foot_Type_Equ:{
            TR_AddEquipmentInfoVC * vc = [[TR_AddEquipmentInfoVC alloc]init];
            vc.orderId=self.repairOrderId;
            vc.reloadVC = ^{
                [weakSelf getRepairDetialData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Repair_Foot_Type_Pro:{
            TR_AddRepairProgressVC * vc = [[TR_AddRepairProgressVC alloc]init];
            vc.orderId = self.repairOrderId;
            vc.reloadVC = ^{
                //刷新详情页面的状态,从服务中状态变为待回访状态
                 weakSelf.repairType=RepairOD_Type_Wait_Visit;
                [self.ynpage_vc removeFromParentViewController];
                [weakSelf suspendTopPageVC];
                [weakSelf.view bringSubviewToFront:self.navView];
                [weakSelf getRepairDetialData];
                [weakSelf.footView removeFromSuperview];
                weakSelf.footView=nil;
                [weakSelf footView];
                BLOCK_EXEC(weakSelf.reloadOrderList);
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Repair_Foot_Type_Cancle:{
            TR_RepairCancleVC * vc = [[TR_RepairCancleVC alloc]init];
            vc.orderID = self.repairOrderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case Repair_Foot_Type_Recive:{
            NSLog(@"接收工单");
            [self receiveRepairOrder];
        }
            break;
        case Repair_Foot_Type_Start:{
            NSLog(@"开始服务");
            [self startSearvice];
        }
            break;
        default:
            break;
    }
}

#pragma mark-----接受工单---
- (void)receiveRepairOrder{
    WS(weakSelf);
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定接收工单" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[TR_LoadingHUD sharedHud]show];
        [self.viewModel receiveReapairId:self.repairOrderId completionBlock:^(BOOL flag, NSString *error) {
            [[TR_LoadingHUD sharedHud]dismiss];
            if (flag) {
                //刷新本页面
                NSLog(@"刷新页面");
                weakSelf.repairType=RepairOD_Type_Wait_Service;
                [self.ynpage_vc removeFromParentViewController];
                [weakSelf suspendTopPageVC];
                [weakSelf.view bringSubviewToFront:self.navView];
                [weakSelf getRepairDetialData];
                //底部按钮从开始接单状态变化为开始服务状态
                [weakSelf.footView removeFromSuperview];
                weakSelf.footView=nil;
                [weakSelf footView];
                BLOCK_EXEC(weakSelf.reloadOrderList);
            }else{
                [TRHUDUtil showMessageWithText:error];
            }
        }];
    }];
    UIAlertAction *alert2= [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:alert2];
    [alertC addAction:alert1];
    alertC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark----开始服务----
- (void)startSearvice{
    if (self.servieceAddress==nil) {
        [TRHUDUtil showMessageWithText:@"获取地理信息失败，稍后再试"];
        return;
    }
    WS(weakSelf);
    NSDictionary * parameter = @{@"orderId":self.repairOrderId,
                                 @"addr":MakeStringNotNil(self.servieceAddress),
                                 @"longitude":[NSString stringWithFormat:@"%lf",self.longitude],
                                 @"latitude":[NSString stringWithFormat:@"%lf",self.latitude]
                                 };
    [self.viewModel startServiceRepair:parameter completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            //底部按钮从开始服务状态更新为服务中
            weakSelf.repairType=RepairOD_Type_In_Service;
            [self.ynpage_vc removeFromParentViewController];
            [weakSelf suspendTopPageVC];
            [weakSelf.view bringSubviewToFront:self.navView];
            [weakSelf getRepairDetialData];
            //底部按钮从开始接单状态变化为开始服务状态
            [weakSelf.footView removeFromSuperview];
            weakSelf.footView=nil;
            [weakSelf footView];
            BLOCK_EXEC(weakSelf.reloadOrderList);
        }else{
             [TRHUDUtil showMessageWithText:error];
        }
    }];
}
#pragma mark----待接收工单--已取消工单
- (NSArray *)getThreeArrayVCs {
    TR_RepairInfoVC *vc_1 = [[TR_RepairInfoVC alloc] init];
    vc_1.repairType=self.repairType;
    self.repairOrderInfoVC = vc_1;
    self.infoVC = vc_1;
    TR_RepairMessageVC *vc_2 = [[TR_RepairMessageVC alloc] init];
    vc_2.repairId=self.repairOrderId;
    self.msgVC= vc_2;
    TR_RepairLogVC *vc_3 = [[TR_RepairLogVC alloc] init];
    vc_3.repairOrderID=self.repairOrderId;
    self.logVC = vc_3;
    return @[vc_1, vc_2, vc_3];
}
- (NSArray *)getThreeArrayTitles {
    return @[@"工单信息", @"工单留言", @"工单日志"];
}
#pragma mark----待服务工单--服务中工单----待回访工单

- (NSArray *)getFourArrayVCs {
    TR_RepairInfoVC *vc_1 = [[TR_RepairInfoVC alloc] init];
    vc_1.repairType=self.repairType;
    self.repairOrderInfoVC = vc_1;
    self.infoVC = vc_1;
    TR_RepairServiceProcessVC * vc_2 = [[TR_RepairServiceProcessVC alloc] init];
    vc_2.repairType=self.repairType;
    vc_2.repairId=self.repairOrderId;
    self.progresVC=vc_2;
    TR_RepairMessageVC *vc_3 = [[TR_RepairMessageVC alloc] init];
    vc_3.repairId=self.repairOrderId;
    self.msgVC= vc_3;
    TR_RepairLogVC *vc_4 = [[TR_RepairLogVC alloc] init];
    vc_4.repairOrderID=self.repairOrderId;
    self.logVC = vc_4;
    return @[vc_1, vc_2, vc_3,vc_4];
}
- (NSArray *)getFourArrayTitles {
    return @[@"工单信息",@"服务进度", @"工单留言", @"工单日志"];
}
#pragma mark --------------- 已经接收带进度工单 ---------------
- (NSArray *)getFiveArrayWithProgerssVCs {
    
    TR_RepairInfoVC *vc_1 = [[TR_RepairInfoVC alloc] init];
    vc_1.repairType=self.repairType;
    self.repairOrderInfoVC = vc_1;
    self.infoVC = vc_1;
    
    TR_RepairServiceProcessVC * vc_2 = [[TR_RepairServiceProcessVC alloc] init];
    vc_2.repairType=self.repairType;
    vc_2.repairId=self.repairOrderId;
    self.progresVC=vc_2;
    
    TR_RepairMessageVC *vc_3 = [[TR_RepairMessageVC alloc] init];
    vc_3.repairType=self.repairType;
    vc_3.repairId=self.repairOrderId;
    self.msgVC= vc_3;
    TR_RepairLogVC *vc_4 = [[TR_RepairLogVC alloc] init];
    vc_4.repairOrderID = self.repairOrderId;
    vc_4.repairType=self.repairType;
    self.logVC = vc_4;
    TR_RepairVisitRecordVC * vc_5 = [[TR_RepairVisitRecordVC alloc]init];
    vc_5.repairType=self.repairType;
    vc_5.repairOrderID = self.repairOrderId;
    self.recordVC=vc_5;
    return @[vc_1, vc_2, vc_3,vc_4,vc_5];
}

- (NSArray *)getFiveArrayWithProgerssTitles {
    return @[@"工单信息", @"服务进度",@"工单留言", @"工单日志",@"回访记录"];
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel=[[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}

@end
