//
//  TR_CustomizeAlertView.m
//  WXSystem
//
//  Created by candy.chen on 2019/9/25.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_CustomizeAlertView.h"

@interface TR_CustomizeAlertView ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIButton *canceButton;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayList;
@end

@implementation TR_CustomizeAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)showChannelChooseView:(NSArray *)array
{
    self.arrayList = [NSMutableArray arrayWithArray:array];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.tableView reloadData];
    self.tableView.frame = CGRectMake(0, KScreenHeight - (array.count +1) * 60 , KScreenWidth,(array.count +1) * 60);
}

- (void)canceButtonClick:(UIButton *)sender
{
   [self hideChannelChooseView];
}

- (void)sureButtonClick:(UIButton *)sender
{
    [self hideChannelChooseView];
}

- (void)hideChannelChooseView{
    [self removeFromSuperview];
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [self hideChannelChooseView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
         return self.arrayList.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.section == 0) {
        cell.textLabel.text = self.arrayList[indexPath.row];
        cell.textLabel.textColor = BLUECOLOR;
    } else {
       cell.textLabel.text = @"取消";
       cell.textLabel.textColor = SIXCOLOR;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideChannelChooseView];
    if (indexPath.section == 0) {
       BLOCK_EXEC(self.alertBlock,indexPath);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
      if (section == 0) {
          UIView *view = [[UIView alloc]init];
          view.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
          return view;
      }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 0;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)maskView
{
    if (IsNilOrNull(_maskView)) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_maskView addGestureRecognizer:tap1];
    }
    return _maskView;
}

@end
