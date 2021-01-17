//
//  TR_RepairOrderDetailHeadView.m
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairOrderDetailHeadView.h"
#import "TR_RepairHeadTitleCell.h"
#import "TR_RepairInfoCell.h"

@interface TR_RepairOrderDetailHeadView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSArray * titleList;
@property(nonatomic,strong)NSMutableArray * contentArray;
@end
static NSString * cell_head = @"cell_head";
static NSString * cell_info = @"cell_info";

@implementation TR_RepairOrderDetailHeadView
- (void)setDetialModel:(TR_RepairDetialModel *)detialModel{
    _detialModel = detialModel;
    [self.contentArray removeAllObjects];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.orderId)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.companyName)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.contactName)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.contactPhone)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.serviceAddr)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.addr)];
    [self.contentArray addObject:MakeStringNotNil(_detialModel.appointmentTime)];

    [self.table reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame initWithData:(NSString*)data{
    self = [super initWithFrame:frame];
    if (self) {
        [self table];
        self.titleList=@[@"工单编号：",@"客户名称：",@"联系人：",@"服务电话：",@"服务地址：",@"详细地址：",@"预约时间："];
        self.contentArray=[NSMutableArray arrayWithCapacity:0];
        for (NSString *str in self.titleList) {
            [self.contentArray addObject:@""];
        }
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 7;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    WS(weakSelf);
    if (indexPath.section==0) {
        TR_RepairHeadTitleCell *head_cell = [tableView dequeueReusableCellWithIdentifier:cell_head];
        if (head_cell==nil) {
            head_cell=[[TR_RepairHeadTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_head];
        }
        head_cell.model=self.detialModel;
        cell = head_cell;
    }else{
        TR_RepairInfoCell*info_cell = [tableView dequeueReusableCellWithIdentifier:cell_info];
        if (info_cell==nil) {
            info_cell=[[TR_RepairInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_info];
        }
        [info_cell showCellInfoTitle:self.titleList[indexPath.row] content:self.contentArray[indexPath.row] index:indexPath.row];
        info_cell.showBtnAction = ^(RepairBtnType type) {
            BLOCK_EXEC(weakSelf.repairHeadAction,type);
        };
        cell = info_cell;
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return 94.0f;
//    }if (indexPath.section==1) {
//        return 44.0f;
//    }
//    return 0.0f;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10.0)];
    head.backgroundColor=COLOR_245;
    return head;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.estimatedRowHeight=44.0f;
        _table.rowHeight=UITableViewAutomaticDimension;
        [self addSubview:_table];
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairHeadTitleCell" bundle:nil] forCellReuseIdentifier:cell_head];
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairInfoCell" bundle:nil] forCellReuseIdentifier:cell_info];
        [_table setSeparatorColor:UICOLOR_RGBA(245, 245, 245)];
        _table.scrollEnabled=NO;

    }
    return _table;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
