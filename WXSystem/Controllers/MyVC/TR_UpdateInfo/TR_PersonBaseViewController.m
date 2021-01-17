//
//  TR_PersonBaseViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/20.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_PersonBaseViewController.h"
#import "TR_MyViewModel.h"
#import "TR_HeadTableViewCell.h"
#import "TR_SettingHeadViewController.h"
#import "TR_UpdateUserPhoneVC.h"

@interface TR_PersonBaseViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TR_MyViewModel *myViewModel;

@end

@implementation TR_PersonBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.navView setLeftImg:@"back" title:@"个人信息"];
    self.myViewModel = [TR_MyViewModel defaultMyVM];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [self.myViewModel.personArray count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TR_HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TR_HeadTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateHead:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 60;
        }
    }
    return 54.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    head.backgroundColor=COLOR_245;
    return head;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            TR_SettingHeadViewController * headVC  = [[TR_SettingHeadViewController alloc]init];
            [self.navigationController pushViewController:headVC animated:YES];
        }if (indexPath.row==2) {
            TR_UpdateUserPhoneVC * vc  = [[TR_UpdateUserPhoneVC alloc]init];
            vc.phone = [[[TR_SystemInfo mainSystem]userInfo] mobile];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } 
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = TABLECOLOR;
        [_tableView registerNib:[UINib nibWithNibName:@"TR_HeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"TR_HeadTableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollsToTop = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
