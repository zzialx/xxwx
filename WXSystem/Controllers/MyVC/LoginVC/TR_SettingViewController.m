//
//  TR_SettingViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SettingViewController.h"
#import "TR_SettingCell.h"

static CGFloat const SettingHeadLablePadding = 15.0f;

#define kContentViewWidth (KScreenWidth - SettingHeadLablePadding * 2)

@interface TR_SettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TR_SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setLeftImg:@"back" title:@"设置"];
    self.navView.lblLeft.hidden = NO;
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"NotificationSetting" object:nil];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    [self.myModel getAppSetMessageCompletionBlock:^(BOOL flag, NSString *error) {
        SS(strongSelf);
        [strongSelf.tableView reloadData];
    }];
   
}

-(void)reloadData{
    if (_tableView) {
        _tableView = nil;
    }
     [self.view addSubview:self.tableView];
    WS(weakSelf);
//    [self.myModel settingWithBlock:^{
//        SS(strongSelf);
//        [strongSelf.tableView reloadData];
//    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.myModel.settingArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.myModel.settingArray objectAtIndex:section] objectForKey:@"row"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TR_SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TR_SettingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindViewModel:self.myModel atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self view:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    TR_SettingSectionType type = [[[self.myModel settingArray][section] objectForKey:@"section"] integerValue];
    if (type ==TR_SettingSectionTypeNull||type == TR_SettingSectionTypeSound) {
        return 30;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 0;
    }
    return 54.0f;
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

- (UIView *)view:(NSInteger)section
{
    TR_SettingSectionType sectionType = [[self.myModel.settingArray [section] objectForKey:@"section"] integerValue];
    UIView *headerView = [[UIView alloc] init];
    CGFloat cellHeight=44.0;
    NSInteger font = 13;
    if (sectionType == TR_SettingSectionTypeSound||sectionType ==TR_SettingSectionTypeNotice) {
        font = 15;
    }
    if (sectionType == TR_SettingSectionTypeNull||sectionType == TR_SettingSectionTypeSound) {
        cellHeight=30;
    }
    headerView.frame =  CGRectMake(0.0f, 0.0f, kContentViewWidth, cellHeight);
    headerView.backgroundColor = TABLECOLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0, kContentViewWidth, cellHeight)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = [UIColor tr_colorwithHexString:@"#999999"];
    label.text = self.myModel.sectionTitleArray[section];
    [headerView addSubview:label];
    return headerView;
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = TABLECOLOR;
        [_tableView registerNib:[UINib nibWithNibName:@"TR_SettingCell" bundle:nil] forCellReuseIdentifier:@"TR_SettingCell"];
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
