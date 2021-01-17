//
//  TR_RepairInfoVC.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairInfoVC.h"
#import "TR_RepairDescribeCell.h"
#import "TR_EquipmentInfoCell.h"
#import "TR_EquipmentFailureCell.h"
#import "TR_EquipmentPicturesCell.h"
#import "TR_ReapirEquimentInfoVC.h"

@interface TR_RepairInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * infoList;///<标题
@property(nonatomic,strong)NSMutableArray * contentList;
@end
static NSString * cellInfo = @"cell_info";
static NSString * cellEquipmentInfo = @"cell_equipment_info";
static NSString * cellEquipmentFailure = @"cell_equipment_failure";
static NSString * cellEquipmentPictures = @"cell_equipment_pictures";

@implementation TR_RepairInfoVC
- (void)setDetialInfoModel:(TR_RepairDetialModel *)detialInfoModel{
    _detialInfoModel = detialInfoModel;
    [self.contentList removeAllObjects];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.emergencyName)];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.orderTagName)];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.manyFlagName)];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.guaranteeTypeName)];
    [self.contentList addObject:@""];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.labelName)];
    [self.contentList addObject:MakeStringNotNil(_detialInfoModel.faultRemark)];
    [self.contentList addObject:@""];

    [self.table reloadData];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.infoList=@[@"紧急情况：",@"工单标签：",@"是否多次保修：",@"维保类型：",@"保修设备：",@"故障类型：",@"故障说明：",@"图片描述："];
    self.contentList=[NSMutableArray arrayWithCapacity:0];
    self.contentList=@[@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
    [self table];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =[UITableViewCell new];
    WS(weakSelf);
    if (indexPath.row==4) {
        TR_EquipmentInfoCell * equipmentInfoCell = [tableView dequeueReusableCellWithIdentifier:cellEquipmentInfo];
        if (equipmentInfoCell==nil) {
            equipmentInfoCell = [[TR_EquipmentInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEquipmentInfo];
        }
        [equipmentInfoCell showCellEqumentModel:self.detialInfoModel];
        equipmentInfoCell.showEquipmentInfo = ^(NSString * _Nonnull equipmentID) {
            TR_ReapirEquimentInfoVC * vc = [[TR_ReapirEquimentInfoVC alloc]initWithEquId:equipmentID];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell = equipmentInfoCell;
    }else if(indexPath.row==6){
        TR_EquipmentFailureCell * equipmentFailreCell = [tableView dequeueReusableCellWithIdentifier:cellEquipmentFailure];
        if (equipmentFailreCell==nil) {
            equipmentFailreCell = [[TR_EquipmentFailureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEquipmentFailure];
        }
        equipmentFailreCell.failureLab.text = self.detialInfoModel.faultRemark;
        cell = equipmentFailreCell;
    }else if(indexPath.row==7){
        TR_EquipmentPicturesCell * equipmentPicCell= [tableView dequeueReusableCellWithIdentifier:cellEquipmentPictures];
        if (equipmentPicCell==nil) {
            equipmentPicCell = [[TR_EquipmentPicturesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellEquipmentPictures];
        }
        equipmentPicCell.picArray=self.detialInfoModel.miniPicUrls;
        equipmentPicCell.showPic = ^(NSInteger index) {
            NSLog(@"查看大图");
            [weakSelf showBigPicturesWithList:weakSelf.detialInfoModel.picUrls index:index];
        };
        cell = equipmentPicCell;
    }else{
        TR_RepairDescribeCell * infoCell = [tableView dequeueReusableCellWithIdentifier:cellInfo];
        if (infoCell==nil) {
            infoCell = [[TR_RepairDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInfo];
        }
        [infoCell showCellTitle:self.infoList[indexPath.row] content:self.contentList[indexPath.row]];
        cell = infoCell;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==4) {
//        return  [TR_EquipmentInfoCell getEquCell:@[]];
//    }if (indexPath.row==6) {
//        return [TR_EquipmentFailureCell getHeightCell:@""];
//    }if (indexPath.row==7) {
//        return [TR_EquipmentPicturesCell getCellHeight];
//    }
//    return 44.0f;
//}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.separatorColor=COLOR_245;
        _table.estimatedRowHeight = 200;
        [self.view addSubview:_table];
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairDescribeCell" bundle:nil] forCellReuseIdentifier:cellInfo];
        [_table registerNib:[UINib nibWithNibName:@"TR_EquipmentInfoCell" bundle:nil] forCellReuseIdentifier:cellEquipmentInfo];
        [_table registerNib:[UINib nibWithNibName:@"TR_EquipmentFailureCell" bundle:nil] forCellReuseIdentifier:cellEquipmentFailure];
        [_table registerClass:[TR_EquipmentPicturesCell class] forCellReuseIdentifier:cellEquipmentPictures];
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, self.repairType==RepairOD_Type_Finish?0:60+kSafeAreaBottomHeight);
    }
    return _table;
}
@end
