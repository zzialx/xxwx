//
//  TR_ReapirEquimentInfoVC.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_ReapirEquimentInfoVC.h"
#import "TR_EquipmentPicturesCell.h"
#import "TR_RepairInfoCell.h"
#import "TR_EqumentModel.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_RepairInfoShowMapVC.h"

@interface TR_ReapirEquimentInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSArray * titleList;
@property(nonatomic,copy)NSString * equmentId;///<设备id
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@property(nonatomic,strong)NSMutableArray * contentList;
@end
static NSString * cellEquipmentPictures = @"cell_equipment_pictures";
static NSString * cellEquipmentInfo = @"cell_equipment_info";

@implementation TR_ReapirEquimentInfoVC
- (instancetype)initWithEquId:(NSString*)equId{
    self = [super init];
    if (self) {
        self.equmentId = equId;
        self.contentList = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navView setTitle:@"设备信息"];
    self.titleList=@[@"设备名称：",@"设备编号：",@"设备品牌：",@"设备型号：",@"设备位置：",@"详细地址："];
    [self  table];
    [self getEqumentInfo];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)getEqumentInfo{
    WS(weakSelf);
    [self.viewModel showEqumentId:self.equmentId completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    WS(weakSelf);
    if (indexPath.row==6) {
        TR_EquipmentPicturesCell * equipmentPicCell= [tableView dequeueReusableCellWithIdentifier:cellEquipmentPictures];
        if (equipmentPicCell==nil) {
            equipmentPicCell = [[TR_EquipmentPicturesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEquipmentPictures];
        }
        equipmentPicCell.picArray =  self.viewModel.equmentModel.miniPicUrls;
        equipmentPicCell.showPic = ^(NSInteger index) {
            NSLog(@"查看大图");
            [weakSelf showBigPicturesWithList:self.viewModel.equmentModel.fileUrls index:index];
        };
        cell = equipmentPicCell;
    }else{
        TR_RepairInfoCell*info_cell = [tableView dequeueReusableCellWithIdentifier:cellEquipmentInfo];
        if (info_cell==nil) {
            info_cell=[[TR_RepairInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEquipmentInfo];
        }
        [info_cell showEquimentInfoTitle:self.titleList[indexPath.row] content:self.viewModel.equInfoList[indexPath.row] index:indexPath.row];
        info_cell.showBtnAction = ^(RepairBtnType type) {
            if (type==RepairBtnType_Address) {
                TR_RepairInfoShowMapVC * vc = [[TR_RepairInfoShowMapVC alloc]init];
                vc.equmentModel = weakSelf.viewModel.equmentModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        
        cell = info_cell;
    }
    return cell;
}

- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 200;
        _table.separatorColor=COLOR_245;
//        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_table];
        _table.tableFooterView=[[UIView alloc ] init];
        [_table registerClass:[TR_EquipmentPicturesCell class] forCellReuseIdentifier:cellEquipmentPictures];
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairInfoCell" bundle:nil] forCellReuseIdentifier:cellEquipmentInfo];
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.navView, 0)
        .bottomSpaceToView(self.view, 0);
    }
    return _table;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel =[[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
    
}
@end
