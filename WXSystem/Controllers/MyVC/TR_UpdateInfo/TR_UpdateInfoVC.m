//
//  TR_UpdateInfoVC.m
//  OASystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_UpdateInfoVC.h"
#import "TR_MyViewModel.h"
#import "TR_ChangeNameCell.h"
#import "TR_PhoneCodeVC.h"

@interface TR_UpdateInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)TR_MyViewModel * viewModel;
@property(nonatomic,strong)NSIndexPath * indexPath;
@end
static NSString * cell_name_id = @"cell_name_id";
static NSString * cell_sex_id = @"cell_sex_id";
static NSString * cell_landline_id = @"cell_landline_id";
static NSString * cell_email_id = @"cell_email_id";
static NSString * cell_phone_id = @"cell_phone_id";

@implementation TR_UpdateInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navView.rightBtn addTarget:self action:@selector(confirmChange:) forControlEvents: UIControlEventTouchUpInside];
    [self table];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.viewModel.sexDic=nil;
}
- (void)confirmChange:(UIButton*)sender{
    TR_ChangeNameCell * cell_name = (TR_ChangeNameCell*)[self.table cellForRowAtIndexPath:self.indexPath];
    NSString * inputtext = cell_name.inputTF.text;
    switch ((NSInteger)self.type) {
        case TR_PERSON_CHANGE_PHONE:{
            //下一步按钮
            if (![inputtext yh_conformsToMobileFormat]) {
                [TRHUDUtil showMessageWithText:@"手机格式不准确，请重新输入"];
                return;
            }if ([inputtext isEqualToString:[TR_SystemInfo mainSystem].userInfo.mobile]) {
                [TRHUDUtil showMessageWithText:@"提示用户已存在"];
                return;
            }
            [self getPhoneCode:inputtext];
        }
            break;
        default:
            break;
    }
}
- (void)setType:(TR_PERSON_CHANGE_TYPE)type{
    _type = type;
    switch ((NSInteger)type) {
        case TR_PERSON_CHANGE_NAME:
            [self.navView setLeftImg:@"back" title:@"名字" rightBtnName:@"确定"];
        break;
        case TR_PERSON_CHANGE_PHONE:
            [self.navView setLeftImg:@"back" title:@"更换手机" rightBtnName:@"下一步"];
            [self.navView.rightBtn setTitleColor:UICOLOR_RGBA(200, 200, 200) forState:UIControlStateNormal];
            self.navView.rightBtn.userInteractionEnabled=NO;
            break;
        default:
            break;
    }
}
- (void)getPhoneCode:(NSString*)phone{
    WS(weakSelf);
    NSDictionary * para = @{@"mobile":phone};
    [self.viewModel getMessageCode:para completionBlock:^(BOOL flag, NSString *error) {
        if (!flag) {
            [TRHUDUtil showMessageWithText:error];
        }else{
            TR_PhoneCodeVC * vc = [[TR_PhoneCodeVC alloc]init];
            vc.phone = phone;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.type == TR_PERSON_CHANGE_SEX?2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    self.indexPath = indexPath;
    TR_ChangeNameCell * cell_name = [tableView dequeueReusableCellWithIdentifier:cell_name_id];
    if (self.type == TR_PERSON_CHANGE_NAME) {
        [cell_name showCellName:self.model.realName placeHold:@"请输入您的真实名字"];
        cell = cell_name;
    }
    if(self.type == TR_PERSON_CHANGE_PHONE){
        [cell_name showCellName:@"手机号"  placeHold:@"请填写手机号"];
        cell = cell_name;
    }
    //添加方法
    [cell_name.inputTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (void)textFieldChanged:(UITextField*)textField{
    NSString * contentPhone  = textField.text;
    NSLog(@"输入内容===%@",contentPhone);
    if(contentPhone.length>0&&contentPhone.length<11){
        [self.navView.rightBtn setTitleColor:UICOLOR_RGBA(40, 40, 40) forState:UIControlStateNormal];
        self.navView.rightBtn.userInteractionEnabled=YES;
    }if (contentPhone.length>11) {
        [self.navView.rightBtn setTitleColor:UICOLOR_RGBA(200, 200, 200) forState:UIControlStateNormal];
        self.navView.rightBtn.userInteractionEnabled=NO;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    head.backgroundColor=GRAY_BGCOLOR;
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.type == TR_PERSON_CHANGE_LANDLINE?30:0;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    foot.backgroundColor=UICOLOR_RGBA(249, 249, 249);
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, KScreenWidth-32, 20)];
    lab.font=FONT_TEXT(14);
    lab.textColor=UICOLOR_RGBA(153, 153, 153);
    lab.text= @"由区号及个人号码组成，例如021-8888888";
    [foot addSubview:lab];
    return foot;
}
- (UITableView*)table{
    if (_table == nil) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_table];
        _table.backgroundColor=UICOLOR_RGBA(249, 249, 249);
        _table.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.navView, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, kSafeAreaBottomHeight);
        _table.delegate=self;
        _table.dataSource=self;
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_table registerNib:[UINib nibWithNibName:@"TR_ChangeNameCell" bundle:nil] forCellReuseIdentifier:cell_name_id];
        [_table registerNib:[UINib nibWithNibName:@"TR_ChangeSexCell" bundle:nil] forCellReuseIdentifier:cell_sex_id];
    }
    return _table;
}
- (TR_MyViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_MyViewModel alloc]init];
    }
    return _viewModel;
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
