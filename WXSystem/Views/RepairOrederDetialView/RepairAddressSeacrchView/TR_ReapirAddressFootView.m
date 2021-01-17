//
//  TR_ReapirAddressFootView.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_ReapirAddressFootView.h"
#import "TR_RepairAddressSeaCell.h"
@interface TR_ReapirAddressFootView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * dataList;
@property(nonatomic,strong)NSIndexPath * selectIndex;
@property(nonatomic,assign)NSInteger page;
@end
static NSString * cell_ID =@"cell_id";
@implementation TR_ReapirAddressFootView
- (void)reloadData:(NSArray*)addressList{
    self.dataList = addressList;
    self.table.tableFooterView = [UIView new];
    [self.table reloadData];
    [self.table endRefreshing];

}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.page=1;
        [self table];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairAddressSeaCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    if (cell == nil) {
        cell = [[TR_RepairAddressSeaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ID];
    }
    AMapPOI * poiModel = self.dataList[indexPath.row];
    [cell showCellName:poiModel.name address:poiModel.address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex) {
        TR_RepairAddressSeaCell * cell_old = [tableView cellForRowAtIndexPath:self.selectIndex];
        cell_old.selectImg.hidden=YES;
    }
    self.selectIndex = indexPath;
    TR_RepairAddressSeaCell * cell_new = [tableView cellForRowAtIndexPath:indexPath];
    cell_new.selectImg.hidden=NO;
    AMapPOI * poiModel = self.dataList[indexPath.row];
    BLOCK_EXEC(self.selectAddress,poiModel.address,[NSString stringWithFormat:@"%lf",poiModel.location.longitude],[NSString stringWithFormat:@"%lf",poiModel.location.latitude]);
}

- (UITableView*)table{
    if (_table==nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_table];
        _table.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 60;
        _table.separatorColor=UICOLOR_RGBA(242, 242, 242);
        [_table registerNib:[UINib nibWithNibName:@"TR_RepairAddressSeaCell" bundle:nil] forCellReuseIdentifier:cell_ID];
        _table.backgroundColor=COLOR_245;
        WS(weakSelf);
        
        [_table addRefreshFooter:^(UIScrollView *scrollView) {
            weakSelf.page++;
            BLOCK_EXEC(weakSelf.loadMoreData,weakSelf.page);
        }];
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
