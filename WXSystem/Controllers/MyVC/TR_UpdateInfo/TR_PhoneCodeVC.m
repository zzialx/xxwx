//
//  TR_PhoneCodeVC.m
//  WXSystem
//
//  Created by zzialx on 2019/2/19.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_PhoneCodeVC.h"
#import "TR_MyViewModel.h"
#import "TR_TabBarViewController.h"


@interface TR_PhoneCodeVC ()
@property(nonatomic,strong)UILabel * cluesLab;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UILabel * phoneTitle;
@property(nonatomic,strong)UILabel * phoneLab;
@property(nonatomic,strong)UILabel * codeTitle;
@property(nonatomic,strong)UITextField * codeTF;

@property(nonatomic,strong)TR_MyViewModel * viewModel;

@end

@implementation TR_PhoneCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    self.phoneLab.text = self.phone;
    
}
#pragma mark---------ACTION----

- (void)confirmChange:(UIButton*)sender{
    if ([self.codeTF.text isEqualToString:@""]) {
         [TRHUDUtil showMessageWithText:@"请输入验证码"];
        return;
    }
    [self updatePhone];
    
//    WS(weakSelf);
//     NSDictionary *dic = @{@"mobile":MakeStringNotNil(self.phone),@"verificationCode":MakeStringNotNil(self.codeTF.text)};
//    [self.viewModel checkMessageCode:dic completionBlock:^(BOOL flag, NSString *error) {
//        [[TR_LoadingHUD sharedHud]dismissInView:weakSelf.view];
//        if (flag) {
//            [weakSelf updatePhone];
//        } else {
//            [TRHUDUtil showMessageWithText:error];
//        }
//    }];
    
}
- (void)updatePhone{
    WS(weakSelf);
    NSDictionary *paramerters = @{@"mobile":self.phone,@"verificationCode":self.codeTF.text};
    [self.viewModel updateUserinfoPhone:paramerters completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [TRHUDUtil showMessageWithText:@"修改成功"];
            //移除缓存
            [[TR_SystemInfo mainSystem]clearApplicationConfigure];
                    TR_LoginViewController *loginVC = [[TR_LoginViewController alloc]initWithNibName:@"TR_LoginViewController" bundle:nil];
                    loginVC.phone = self.phone;
                    loginVC.loginResult = ^(BOOL loginSuccess) {
                        if (loginSuccess) {
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
                        }
                    };
                    [weakSelf.navigationController pushViewController:loginVC animated:YES];
            
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (void)setUI{
    self.view.backgroundColor=UICOLOR_RGBA(249, 249, 249);
    [self.navView setLeftImg:@"back" title:@"更换手机" rightBtnName:@"完成"];
    [self.navView.rightBtn addTarget:self action:@selector(confirmChange:) forControlEvents: UIControlEventTouchUpInside];
    [self cluesLab];
    [self bgView];
    [self phoneTitle];
    [self phoneLab];
    [self codeTitle];
    [self codeTF];
}
- (UITextField*)codeTF{
    if (IsNilOrNull(_codeTF)) {
        _codeTF = [[UITextField alloc]init];
        [self.bgView addSubview:_codeTF];
        _codeTF.sd_layout.leftSpaceToView(self.codeTitle, 10).topSpaceToView(self.phoneLab, 17).rightSpaceToView(self.bgView, 20).heightIs(20);
        _codeTF.keyboardType=UIKeyboardTypeNamePhonePad;
        _codeTF.borderStyle=UITextBorderStyleNone;
        _codeTF.font=FONT_TEXT(16);
        _codeTF.placeholder=@"请输入验证码";
        _codeTF.textColor=UICOLOR_RGBA(51, 51, 51);
    }
    return _codeTF;
}
- (UILabel*)codeTitle{
    if (IsNilOrNull(_codeTitle)) {
        _codeTitle = [[UILabel alloc]init];
        [self.bgView addSubview:_codeTitle];
        _codeTitle.sd_layout.leftSpaceToView(self.bgView, 16).topSpaceToView(self.phoneTitle, 17).widthIs(60).heightIs(20);
        _codeTitle.textColor=UICOLOR_RGBA(51, 51, 51);
        _codeTitle.font=FONT_TEXT(16);
        _codeTitle.text=@"验证码";
    }
    return _codeTitle;
}
- (UILabel*)phoneTitle{
    if (IsNilOrNull(_phoneTitle)) {
        _phoneTitle = [[UILabel alloc]init];
        [self.bgView addSubview:_phoneTitle];
        _phoneTitle.sd_layout.leftSpaceToView(self.bgView, 16).topSpaceToView(self.bgView, 17).widthIs(60).heightIs(20);
        _phoneTitle.textColor=UICOLOR_RGBA(51, 51, 51);
        _phoneTitle.font=FONT_TEXT(16);
        _phoneTitle.text=@"手机号";
    }
    return _phoneTitle;
}
- (UILabel*)phoneLab{
    if (IsNilOrNull(_phoneLab)) {
        _phoneLab = [[UILabel alloc]init];
        [self.bgView addSubview:_phoneLab];
        _phoneLab.sd_layout.leftSpaceToView(self.phoneTitle, 10).topSpaceToView(self.bgView, 17).rightSpaceToView(self.bgView, 20).heightIs(20);
        _phoneLab.textColor=UICOLOR_RGBA(51, 51, 51);
        _phoneLab.font=FONT_TEXT(16);
    }
    return _phoneLab;
}
-  (UIView*)bgView{
    if (IsNilOrNull(_bgView)) {
        _bgView = [[UIView alloc]init];
        [self.view addSubview:_bgView];
        _bgView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.cluesLab, 0).rightSpaceToView(self.view, 0).heightIs(108);
        _bgView.backgroundColor=UIColor.whiteColor;
    }
    return _bgView;
}
-  (UILabel*)cluesLab{
    if(IsNilOrNull(_cluesLab)){
        _cluesLab =[[UILabel alloc]init];
        [self.view addSubview:_cluesLab];
        _cluesLab.sd_layout.leftSpaceToView(self.view, 16).topSpaceToView(self.navView, 10).rightSpaceToView(self.view, 0).heightIs(20);
        _cluesLab.textColor=UICOLOR_RGBA(153, 153, 153);
        _cluesLab.font=FONT_TEXT(14);
        _cluesLab.text=@"短信验证码已发送，请填写验证码";
    }
    return _cluesLab;
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
