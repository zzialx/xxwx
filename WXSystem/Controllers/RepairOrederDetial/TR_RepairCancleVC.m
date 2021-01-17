//
//  TR_RepairCancleVC.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairCancleVC.h"
#import "TR_RepairCancleCell.h"
#import "TR_RepairDetialViewModel.h"

@interface TR_RepairCancleVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)TR_RepairDetialViewModel  * detialVM;
@end
static NSString * cellId = @"cellID";
@implementation TR_RepairCancleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=UIColor.whiteColor;
    [self.navView setTitle:@"取消原因"];
    [self table];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getCancleInfoDetial];
}
- (void)getCancleInfoDetial{
    [[TR_LoadingHUD sharedHud]show];
    WS(weakSelf);
    [self.detialVM getOrderCancleInfo:self.orderID completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud] dismiss];
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairCancleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[TR_RepairCancleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.contentLab.text = self.detialVM.cancleInfo;
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    UILabel * headView =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    headView.textColor=COLOR_51;
    headView.text=@"这里是工单的取消原因：";
    [view addSubview:headView];
    view.backgroundColor=UIColor.whiteColor;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
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
        .topSpaceToView(self.navView, 0)
        .bottomSpaceToView(self.view, 0);
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairCancleCell" bundle:nil] forCellReuseIdentifier:cellId];
    }
    return _table;
}
- (TR_RepairDetialViewModel*)detialVM{
    if (IsNilOrNull(_detialVM)) {
        _detialVM=[[TR_RepairDetialViewModel alloc]init];
    }
    return _detialVM;
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
