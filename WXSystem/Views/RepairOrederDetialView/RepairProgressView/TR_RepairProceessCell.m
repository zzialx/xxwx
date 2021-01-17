//
//  TR_RepairProceessCell.m
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairProceessCell.h"
#import "TR_RepairProgressInfoCell.h"
#import "TR_RepairServiceCell.h"
#import "TR_RepairProgressTitleView.h"
#import "TR_ServicePgrDetialModel.h"
#import "TR_RepairDetialViewModel.h"
#import "ProgressManager.h"

@interface TR_RepairProceessCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UITableView * processTable;
@property (strong, nonatomic)TR_RepairDetialViewModel * viewModel;
@property (strong, nonatomic)NSMutableArray * serviceList;
@end


@implementation TR_RepairProceessCell
+ (CGFloat)getCellHeightWithProgressModel:(TR_ServicePgrModel*)progressModel{
   __block CGFloat cellHeight = 0.0;
//    NSDictionary * parameter = @{@"processId":MakeStringNotNil(progressModel.processId)};
//    [TR_HttpClient postRequestUrlString:POST_DETIAL_PGR_INFO withDic:parameter success:^(id requestDic, NSString *msg) {
//        TR_ServicePgrDetialModel * servicePgrDeiModel = [TR_ServicePgrDetialModel yy_modelWithJSON:requestDic];
//        if (servicePgrDeiModel.startAddr.length>0) {
//             cellHeight += [TR_RepairServiceCell getCellHeight:servicePgrDeiModel.startAddr];
//        }if (servicePgrDeiModel.beforeService.length>0) {
//            //服务前和服务后的状态是成对出现的，单一不可能出现
//              cellHeight += [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:servicePgrDeiModel.beforeService servicePic:servicePgrDeiModel.beforePicUrls];
//            cellHeight = [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:servicePgrDeiModel.afterService servicePic:servicePgrDeiModel.afterPicUrls];
//             cellHeight +=[TR_RepairServiceCell getCellHeight:servicePgrDeiModel.endAddr];
//        }
//
//    } failure:^(NSString *errorInfo) {
//
//    }];
     return cellHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=COLOR_245;
        [self bgView];
        [self processTable];
        self.serviceList=[NSMutableArray arrayWithCapacity:0];
        if (@available(iOS 11.0, *)) {
            _processTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return  self;
}
- (void)setDetailModel:(TR_ServicePgrDetialModel *)detailModel{
    _detailModel=detailModel;
    self.viewModel.servicePgrDeiModel = _detailModel;
    [self.serviceList removeAllObjects];
    if (self.detailModel.startAddr.length>0) {
        [self.serviceList addObject:self.detailModel.startAddr];
    }if (self.detailModel.beforeService.length>0) {
        //服务前和服务后的状态是成对出现的，单一不可能出现
        [self.serviceList addObject:self.detailModel.beforeService];
        [self.serviceList addObject:self.detailModel.afterService];
    } if (self.viewModel.servicePgrDeiModel.endTime.length>0) {
        [self.serviceList addObject:self.detailModel.endTime];
    }
    [self.processTable reloadData];
    
    //立即layoutIfNeeded获取contentSize
    [self.bgView layoutIfNeeded];
    CGFloat height = self.processTable.contentSize.height;
    NSLog(@"高度123===%lf",height);
    NSLog(@"手动计算高度====%lf",self.viewModel.servicePgrDeiModel.cellHeight);
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}
#warning 等待优化
- (void)setModel:(TR_ServicePgrModel *)model{
    _model = model;
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud]show];
    [self.viewModel showServicePgrInfo:self.model.processId completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud]dismiss];
        if (flag) {
            [weakSelf.serviceList removeAllObjects];
            if (weakSelf.viewModel.servicePgrDeiModel.startAddr.length>0) {
                [weakSelf.serviceList addObject:weakSelf.viewModel.servicePgrDeiModel.startAddr];
            }if (weakSelf.viewModel.servicePgrDeiModel.beforeService.length>0) {
                //服务前和服务后的状态是成对出现的，单一不可能出现
                [weakSelf.serviceList addObject:weakSelf.viewModel.servicePgrDeiModel.beforeService];
                [weakSelf.serviceList addObject:weakSelf.viewModel.servicePgrDeiModel.afterService];
            } if (weakSelf.viewModel.servicePgrDeiModel.endTime.length>0) {
                [weakSelf.serviceList addObject:weakSelf.viewModel.servicePgrDeiModel.endTime];
            }
            [weakSelf.processTable reloadData];
            
            //立即layoutIfNeeded获取contentSize
            [weakSelf.bgView layoutIfNeeded];
            CGFloat height = weakSelf.processTable.contentSize.height;
            NSLog(@"高度123===%lf",height);
            NSLog(@"手动计算高度====%lf",weakSelf.viewModel.servicePgrDeiModel.cellHeight);
            [weakSelf.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            
            ProgressManager * manager = [ProgressManager shareInstance];
            [manager.progressCellHeightDic setValue:[NSString stringWithFormat:@"%lf",weakSelf.viewModel.servicePgrDeiModel.cellHeight] forKey:model.processId];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.serviceList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat row_height = 0.0f;
    if (indexPath.section==0) {
        row_height=[TR_RepairServiceCell getCellHeight:self.viewModel.servicePgrDeiModel.startAddr];
    }if (indexPath.section==3) {
        row_height=[TR_RepairServiceCell getCellHeight:self.viewModel.servicePgrDeiModel.endAddr];
    }if(indexPath.section==1){
        row_height = [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:self.viewModel.servicePgrDeiModel.beforeService servicePic:self.viewModel.servicePgrDeiModel.beforePicUrls];
    }if(indexPath.section==2){
        row_height = [TR_RepairProgressInfoCell getProgressCellHeightServiceContent:self.viewModel.servicePgrDeiModel.afterService servicePic:self.viewModel.servicePgrDeiModel.afterPicUrls];
    }
    return row_height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [UITableViewCell new];
    WS(weakSelf);
    if (indexPath.section==0) {
        TR_RepairServiceCell * startServiceCell = [tableView dequeueReusableCellWithIdentifier:@"TR_RepairServiceCell"];
        if (startServiceCell==nil) {
            startServiceCell = [[TR_RepairServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TR_RepairServiceCell"];
        }
        [startServiceCell showCellSectionIndex:indexPath.section serviceModel:self.viewModel.servicePgrDeiModel];
        cell = startServiceCell;
    }if (indexPath.section==1) {
        TR_RepairProgressInfoCell * centerCell = [tableView dequeueReusableCellWithIdentifier:@"TR_RepairProgressInfoCell"];
        if (centerCell==nil) {
            centerCell = [[TR_RepairProgressInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TR_RepairProgressInfoCell"];
        }
        [centerCell showCellSection:indexPath.section serviceModel:self.viewModel.servicePgrDeiModel];
        centerCell.showBigPic = ^(NSInteger index) {
            NSLog(@"查看大图");
            BLOCK_EXEC(weakSelf.seeBigPic,index,weakSelf.viewModel.servicePgrDeiModel.beforePicUrls);
        };
        cell = centerCell;
    }if (indexPath.section==2) {
        TR_RepairProgressInfoCell * centerCell = [tableView dequeueReusableCellWithIdentifier:@"TR_RepairProgressInfoCell"];
        if (centerCell==nil) {
            centerCell = [[TR_RepairProgressInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TR_RepairProgressInfoCell"];
        }
        [centerCell showCellSection:indexPath.section serviceModel:self.viewModel.servicePgrDeiModel];
        centerCell.showBigPic = ^(NSInteger index) {
            NSLog(@"查看大图");
            BLOCK_EXEC(weakSelf.seeBigPic,index,weakSelf.viewModel.servicePgrDeiModel.afterPicUrls);
        };
        cell = centerCell;
    }if (indexPath.section==3) {
        TR_RepairServiceCell * endServiceCell = [tableView dequeueReusableCellWithIdentifier:@"TR_RepairServiceCell"];
        if (endServiceCell==nil) {
            endServiceCell = [[TR_RepairServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TR_RepairServiceCell"];
        }
        [endServiceCell showCellSectionIndex:indexPath.section serviceModel:self.viewModel.servicePgrDeiModel];
        cell = endServiceCell;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 20.0;
    }
    return 0.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        //维修进度显示按钮
        TR_RepairProgressTitleView * titleView = (TR_RepairProgressTitleView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_RepairProgressTitleView" owner:self options:nil]lastObject];
        return titleView;
    }
    return nil;
}
- (UITableView*)processTable{
    if (IsNilOrNull(_processTable)) {
        _processTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.bgView addSubview:_processTable];
        [_processTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgView);
        }];
        _processTable.delegate=self;
        _processTable.dataSource=self;
        _processTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        _processTable.scrollEnabled=NO;
        [_processTable registerNib:[UINib nibWithNibName:@"TR_RepairServiceCell" bundle:nil] forCellReuseIdentifier:@"TR_RepairServiceCell"];
         [_processTable registerNib:[UINib nibWithNibName:@"TR_RepairProgressInfoCell" bundle:nil] forCellReuseIdentifier:@"TR_RepairProgressInfoCell"];
    }
    return _processTable;
}
- (UIView*)bgView{
    if(IsNilOrNull(_bgView)){
        _bgView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_bgView];
        _bgView.backgroundColor=UIColor.whiteColor;
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(0);
            make.left.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(KScreenWidth-30);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
    }
    return _bgView;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
