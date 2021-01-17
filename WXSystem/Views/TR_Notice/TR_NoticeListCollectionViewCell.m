//
//  TR_NoticeListCollectionViewCell.m
//  OASystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_NoticeListCollectionViewCell.h"
#import "TR_NoticeListViewModel.h"
#import "TR_NoticeListTableViewCell.h"
#import "TR_NoticeListModel.h"

@interface TR_NoticeListCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TR_NoticeListViewModel *model;
@property (nonatomic, retain) UITableView *tableView;
@property (copy, nonatomic) NSString *colCode;
@end

@implementation TR_NoticeListCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.haveLoad = NO;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 0, frame.size.width - 30, frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        [self.contentView addSubview:self.tableView];
        [_tableView registerClass:[TR_NoticeListTableViewCell class]
           forCellReuseIdentifier:@"TR_NoticeListTableViewCell"];
        
        WS(weakSelf);
        [_tableView addRefreshHeader:^(UIScrollView *scrollView) {
            [weakSelf loadRefreshData];
        }];
        [_tableView addRefreshFooter:^(UIScrollView *scrollView) {
            [weakSelf loadInfiniteData];
        }];
    }
    return self;
}
-(TR_NoticeListViewModel *)model{
    if (!_model) {
        _model = [[TR_NoticeListViewModel alloc]initWithType:TR_DataLoadingTypeRefresh];
    }
    return _model;
}

- (void)loadRefreshData
{
    [self fetchQuestionList:TR_DataLoadingTypeRefresh];
}

- (void)loadInfiniteData
{
    [self fetchQuestionList:TR_DataLoadingTypeInfinite];
}

- (void)fetchQuestionList:(TR_DataLoadingType)type{
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud] showInView:self];
    [self.model fetchNoticeList:type parameters:@{@"typeId":self.colCode}  completionBlock:^(BOOL flag, NSString *error) {

        SS(strongSelf);
        strongSelf.haveLoad = YES;
        //刷新UI
        [[TR_LoadingHUD sharedHud] dismissInView:strongSelf];
        [strongSelf.tableView endRefreshing];
        if (flag) {
            if ([strongSelf.model numberOfRowsCount] == 0) {
                strongSelf.tableView.tableFooterView = [[self viewController].noDataView setNoDataType:NO_DATATYPE_NODATA];
            } else {
                strongSelf.tableView.tableFooterView = [UIView new];
            }
            [strongSelf.tableView reloadData];
            if ([strongSelf.model hasMoreQuestion]) {
                [strongSelf.tableView resetNoMoreData];
            } else {
                [strongSelf.tableView endRefreshingWithNoMoreData];
            }
            if (error) {
               [TRHUDUtil showMessageWithText:error];
            }
        }
    }];
}

-(void)loadWithColCode:(NSString *)colCode{
    self.colCode = colCode;
    [self loadRefreshData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[self.model numberOfRowsCount]);
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%lu",(unsigned long)[self.model numberOfRowsCount]);
    return [self.model numberOfRowsCount];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TR_NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TR_NoticeListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = (TR_NoticeListModel *)[self.model marketModelViewModelAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 //   TR_NoticeListModel *myModel = (TR_NoticeListModel *)[self.model marketModelViewModelAtIndex:indexPath.row];
  //  [[self viewController].pushHandleObject  parsePushUrlLocal:[NSString stringWithFormat:@"%@newsDetails/%@?type=%@",WEB_URL, myModel.newsId,myModel.newsType]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
