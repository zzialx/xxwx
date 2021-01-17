//
//  TR_RepairMessageDetialVC.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairMessageDetialVC.h"
#import "TR_MsgTimeCell.h"
#import "TR_MsgTitleCell.h"
#import "TR_MstContentCell.h"
#import "TR_EquipmentPicturesCell.h"
#import "TR_LesvelMsgModel.h"
#import "TR_RepairDetialViewModel.h"


@interface TR_RepairMessageDetialVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)TR_RepairDetialViewModel * viewModel;
@end
static NSString * cellTitle = @"cellTitle";
static NSString * cellTime = @"cellTime";
static NSString * cellContent = @"cellContent";
static NSString * cellpictures = @"cellpictures";

@implementation TR_RepairMessageDetialVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navView setTitle:@"留言详情"];
    self.view.backgroundColor=UIColor.whiteColor;
    [self table];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getMsgInfo];
}
- (void)getMsgInfo{
    [[TR_LoadingHUD sharedHud] show];
    WS(weakSelf);
    [self.viewModel getRepairLeavelMsgInfoWithMsgID:self.msgId completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud] dismiss];
        if (flag) {
            [weakSelf.table reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    if (indexPath.row==0) {
        TR_MsgTitleCell  * cell_title = [tableView dequeueReusableCellWithIdentifier:cellTitle];
        if (cell_title==nil) {
            cell_title=[[TR_MsgTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTitle];
        }
        cell_title.titleLab.text = self.viewModel.leavelMsgInfo.userName;
        cell= cell_title;
    }if (indexPath.row==1) {
        TR_MsgTimeCell  * cell_time = [tableView dequeueReusableCellWithIdentifier:cellTime];
        if (cell_time==nil) {
            cell_time=[[TR_MsgTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTime];
        }
        cell_time.timeLab.text = self.viewModel.leavelMsgInfo.messageTime;
        cell= cell_time;
    } if (indexPath.row==2) {
        TR_MstContentCell  * cell_content = [tableView dequeueReusableCellWithIdentifier:cellContent];
        if (cell_content==nil) {
            cell_content=[[TR_MstContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellContent];
        }
        cell_content.contentLab.text=self.viewModel.leavelMsgInfo.messageInfo;
        cell= cell_content;
    }if (indexPath.row==3) {
        TR_EquipmentPicturesCell  * cell_pic = [tableView dequeueReusableCellWithIdentifier:cellpictures];
        if (cell_pic==nil) {
            cell_pic=[[TR_EquipmentPicturesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellpictures];
        }
        cell_pic.picArray =  self.viewModel.leavelMsgInfo.miniPicUrls;
        WS(weakSelf);
        cell_pic.showPic = ^(NSInteger index) {
            NSLog(@"查看大图");
            [weakSelf showBigPicturesWithList:weakSelf.viewModel.leavelMsgInfo.picUrls index:index];
        };
        cell= cell_pic;
    }
    return cell;
}
- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_table];
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 30;
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.navView, 0)
        .bottomSpaceToView(self.view, 0);
        [_table registerClass:[TR_EquipmentPicturesCell class] forCellReuseIdentifier:cellpictures];
        [_table registerNib:[UINib nibWithNibName:@"TR_MsgTitleCell" bundle:nil] forCellReuseIdentifier:cellTitle];
        [_table registerNib:[UINib nibWithNibName:@"TR_MsgTimeCell" bundle:nil] forCellReuseIdentifier:cellTime];
        [_table registerNib:[UINib nibWithNibName:@"TR_MstContentCell" bundle:nil] forCellReuseIdentifier:cellContent];

    }
    return _table;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
@end
