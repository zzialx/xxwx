//
//  TR_ForgetViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ForgetViewController.h"
#import "TR_ResetViewController.h"
#import "TR_TabBarViewController.h"
@interface TR_ForgetViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic,strong)UILabel * timeLab;
@end

@implementation TR_ForgetViewController
- (UILabel*)timeLab{
    if (IsNilOrNull(_timeLab)) {
        _timeLab = [[UILabel alloc]init];
        [self.view addSubview:_timeLab];
        _timeLab.sd_layout.rightEqualToView(self.codeButton)
        .centerYEqualToView(self.codeButton)
        .heightIs(19)
        .widthIs(30);
        _timeLab.hidden=YES;
        _timeLab.font=FONT_TEXT(13);
        _timeLab.textColor=[UIColor tr_colorwithHexString:@"#666666"];
    }
    return _timeLab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nextButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
    [self.navView setLeftImg:@"login_close" title:@""];
    self.navView.leftImg.frame=CGRectMake(LEFT_VIEW, self.navView.leftImg.origin.y, 15, 15);
    [self.navView.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.hidden = YES;
    self.nextButton.userInteractionEnabled = YES;
    self.codeButton.userInteractionEnabled = YES;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor tr_colorwithHexString:@"#3A7CD2"] forState:UIControlStateNormal];
    [self timeLab];
    self.phoneField.text = self.phone;
}

- (void)back {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)codeButton:(id)sender {
    [self countDown];
}

- (IBAction)nextButton:(id)sender {
    self.nextButton.userInteractionEnabled = YES;
    if ([self checkLoginData]) {
        NSDictionary *dic = @{@"mobile":MakeStringNotNil(self.phoneField.text),@"verificationCode":MakeStringNotNil(self.codeField.text)};
        [[TR_LoadingHUD sharedHud]showInView:self.view];
       WS(weakSelf);
        [self.myModel checkMessageCode:dic completionBlock:^(BOOL flag, NSString *error) {
             [[TR_LoadingHUD sharedHud]dismissInView:weakSelf.view];
            if (flag) {
                
                TR_ResetViewController *resetVC  = [[TR_ResetViewController alloc]initWithNibName:@"TR_ResetViewController" bundle:nil];
                [resetVC resetPhone:weakSelf.phoneField.text code:weakSelf.codeField.text];
                [weakSelf.navigationController pushViewController:resetVC animated:YES];
            } else {
                [TRHUDUtil showMessageWithText:error];
            }
        }];

    }
}

- (void)countDown{
    
    if (self.phoneField.text.length == 0) {
        [TRHUDUtil showMessageWithText:@"请先输入手机号"];
        return;
    }
    NSDictionary *data = @{@"mobile":self.phoneField.text};
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud]showInView:self.view];
    [self.myModel getPhoneCode:data completionBlock:^(BOOL flag, NSString *error) {
     [[TR_LoadingHUD sharedHud]dismissInView:weakSelf.view];
         [TRHUDUtil showMessageWithText:error];
        if (flag) {
            [weakSelf startCountDown];
        }else{
            weakSelf.codeButton.userInteractionEnabled = YES;
        }
    }];
}

- (BOOL)checkLoginData{
    if (![self.phoneField.text yh_conformsToMobileFormat]) {
        [TRHUDUtil showMessageWithText:@"手机格式不准确，请重新输入"];
        return NO;
    } else if (self.codeField.text.length<1) {
        [TRHUDUtil showMessageWithText:@"请输入验证码"];
        return NO;
    }
    return YES;
}

- (void)startCountDown
{
    [self.codeButton setTitle:@"" forState:UIControlStateNormal];
//    self.codeButton.hidden = YES;
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
         time--;
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
//                self.codeButton.hidden=NO;
                self.timeLab.hidden=YES;
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[UIColor tr_colorwithHexString:@"#3A7CD2"] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
            
        }else{
//            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                self.timeLab.hidden =NO;
                self.timeLab.text =[NSString stringWithFormat:@"%ldS", time];
            
            self.codeButton.userInteractionEnabled = NO;
            });
           
        }
    });
    dispatch_resume(_timer);
}


- (void)textFieldDidChange:(UITextField *)textField{
    NSInteger validTextLength = textField.text.length;
    if (validTextLength > 0) {
        if (textField == self.phoneField) {
            self.phoneField.text = textField.text;
            if (validTextLength ==11) {
                self.codeButton.userInteractionEnabled = YES;
                [self.codeButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            }
            if(validTextLength <11){
                self.codeButton.userInteractionEnabled = NO;
                [self.codeButton setTitleColor:[UIColor tr_colorwithHexString:@"#666666"] forState:UIControlStateNormal];
            }
            if (validTextLength > 11) {
                self.phoneField.text = [textField.text substringToIndex:11];
            }
        } else if (textField == self.codeField) {
            if(validTextLength>=4){
                self.nextButton.userInteractionEnabled=YES;
            }
            self.codeField.text = textField.text;
            if (validTextLength > 8) {
                self.codeField.text = [textField.text substringToIndex:8];
            }
        }
    }
    
    if (self.phoneField.text.length > 0 &&  self.codeField.text.length >0) {
        self.nextButton.backgroundColor = BLUECOLOR;
        self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.nextButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
        self.nextButton.titleLabel.textColor = [UIColor tr_colorwithHexString:@"#999999"];
    }
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
