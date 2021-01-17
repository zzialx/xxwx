//
//  TR_RepairServiceProcessVC.m
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//  工单进度页面

#import "TR_RepairServiceProcessVC.h"
#import "TR_RepairProgressHeadView.h"
#import "TR_RepairProceessCell.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_ServicePgrModel.h"
#import "TR_ServicePgrDetialModel.h"
#import "ProgressManager.h"


@interface TR_RepairServiceProcessVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray * cellShowArray;
@property(strong, nonatomic)TR_RepairDetialViewModel * viewModel;
@property(strong, nonatomic)NSMutableDictionary * progressDetialDic;

@end
static NSString * cellID = @"cellID";

@implementation TR_RepairServiceProcessVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_245;
    self.cellShowArray=[NSMutableArray arrayWithCapacity:0];
    self.progressDetialDic=[NSMutableDictionary dictionaryWithCapacity:0];
    self.cellShowArray=@[@"0",@"0",@"0"].mutableCopy;
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getServiceProgressList];
}
- (void)reloadProgressList{
    [self getServiceProgressList];
}

- (void)getServiceProgressList{
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud]show];
    [self.viewModel showServiceProgressList:self.repairId completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud]dismiss];
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.servicePgrList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.cellShowArray[section] integerValue] == 1) {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_ServicePgrModel * model = self.viewModel.servicePgrList[indexPath.section];
    if ([self.progressDetialDic.allKeys containsObject:model.processId]) {
        TR_ServicePgrDetialModel * detailModel = self.progressDetialDic[model.processId];
        return detailModel.cellHeight;
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    TR_RepairProceessCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld",cellID,(long)indexPath.row]];
    if (cell==nil) {
        cell=[[TR_RepairProceessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%@%ld",cellID,(long)indexPath.row]];
    }
//     cell.model = self.viewModel.servicePgrList[indexPath.section];
    TR_ServicePgrModel * model = self.viewModel.servicePgrList[indexPath.section];
    if ([self.progressDetialDic.allKeys containsObject:model.processId]) {
        cell.detailModel = self.progressDetialDic[model.processId];
    }
//    cell.detailModel = self.progressDetialDic
    cell.seeBigPic = ^(NSInteger index, NSArray * _Nonnull picArray) {
        [weakSelf showBigPicturesWithList:picArray index:index];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70.0f;
}
#pragma mark-------展开关闭
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WS(weakSelf);
    TR_RepairProgressHeadView * view = (TR_RepairProgressHeadView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_RepairProgressHeadView" owner:self options:nil]lastObject];
    view.frame=CGRectMake(0, 0, KScreenWidth, 70);
    view.model = self.viewModel.servicePgrList[section];
    view.isShowMore = [self.cellShowArray[section] boolValue];
    view.showServiceDetial = ^(NSString * _Nonnull serviceID, BOOL isShow) {
        if (isShow) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [[TR_LoadingHUD sharedHud]show];
            [self.viewModel showServicePgrInfo:serviceID completionBlock:^(BOOL flag, NSString *error) {
                [[TR_LoadingHUD sharedHud]dismiss];
                if (flag) {
                    [weakSelf.progressDetialDic setObject:weakSelf.viewModel.servicePgrDeiModel forKey:serviceID];
                    dispatch_semaphore_signal(semaphore);
                    NSString *string = [NSString stringWithFormat:@"%d",isShow];
                    [weakSelf.cellShowArray replaceObjectAtIndex:section withObject:string];
                    [weakSelf.table reloadData];
                }else{
                    [TRHUDUtil showMessageWithText:error];
                    dispatch_semaphore_signal(semaphore);
                }
            }];
           
        }else{
            NSString *string = [NSString stringWithFormat:@"%d",isShow];
            [weakSelf.cellShowArray replaceObjectAtIndex:section withObject:string];
            [weakSelf.table reloadData];
        }
      
    };
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, SECTION_HEIGHT)];
    foot.backgroundColor=COLOR_245;
    return foot;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.estimatedRowHeight = 200;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_table];
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, self.repairType==RepairOD_Type_Finish?0:60+kSafeAreaBottomHeight);
        _table.tableHeaderView=[self headMsgView];
//        [_table registerClass:[TR_RepairProceessCell class] forCellReuseIdentifier:cellID];
    }
    return _table;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
- (UIView*)headMsgView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-30, 30)];
    UILabel * msgLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    [headView addSubview:msgLab];
    msgLab.text=@"服务人员";
    msgLab.textColor=COLOR_102;
    msgLab.font=FONT_TEXT(13);
    return headView;
}
@end
