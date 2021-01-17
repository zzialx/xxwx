//
//  TR_ResetViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ResetViewController.h"
#import "TR_LoginViewController.h"
#import "TR_TabBarViewController.h"
#import "TR_HomeViewController.h"
#import "AppDelegate.h"
@interface TR_ResetViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *aginPassButton;
@property (weak, nonatomic) IBOutlet UITextField *aginField;
@property (weak, nonatomic) IBOutlet UIButton *passButton;
@property (copy, nonatomic) NSString *phoneString;
@property (copy, nonatomic) NSString *codeString;
@end

@implementation TR_ResetViewController

- (void)resetPhone:(NSString *)phone code:(NSString *)code
{
    self.phoneString = phone;
    self.codeString = code;
}

- (IBAction)closeButton:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureButton:(id)sender {

    if ([self checkLoginData]) {
        NSDictionary *data = @{
                               @"newPassword":MakeStringNotNil([self.passwordField.text yh_md5String]),@"verificationCode":MakeStringNotNil(self.codeString),
                               @"mobile":MakeStringNotNil(self.phoneString)};
        [[TR_LoadingHUD sharedHud] showInView:self.view];
        WS(weakSelf);
        [self.myModel resetUserPassword:data completionBlock:^(BOOL flag, NSString *error) {
            SS(strongSelf);
            [[TR_LoadingHUD sharedHud] dismissInView:strongSelf.view];
            if (flag) {
                NSDictionary *loginData = @{@"mobile":MakeStringNotNil(self.phoneString),@"password":[self.passwordField.text yh_md5String]};
                [strongSelf.myModel userLogin:loginData completionBlock:^(BOOL flag, NSString *error) {
                    [[TR_LoadingHUD sharedHud] dismissInView:strongSelf.view];
                    if (flag) {
//                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phoneString forKey:LOGIN_PHONE];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        TR_TabBarViewController *tabBarController = [TR_TabBarViewController defaultTabBar];
                         [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
                        [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
                    }
                }];
            } else {
                [TRHUDUtil showMessageWithText:error];
            }
        }];
    }
}

- (IBAction)password:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.passwordField.secureTextEntry = !button.selected;
}
- (IBAction)agin:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.aginField.secureTextEntry = !button.selected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navView.leftImg.image = [UIImage imageNamed:@"login_close"];
    [self.navView setLeftImg:@"login_close" title:@""];
    self.navView.leftImg.frame=CGRectMake(LEFT_VIEW, self.navView.leftImg.origin.y, 15, 15);

    self.navView.lblLeft.hidden = YES;

    [self.passButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [self.passButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];
    [self.aginPassButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [self.aginPassButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];

    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.aginField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.sureButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
    self.sureButton.userInteractionEnabled=YES;
    
}

- (BOOL)checkLoginData{
   if (self.passwordField.text.length<1) {
        [TRHUDUtil showMessageWithText:@"请输入密码"];
        return NO;
    }
    if (self.aginField.text.length < 6) {
        [TRHUDUtil showMessageWithText:@"请输入密码(6-20位字符）"];
        return NO;
    }
    if (![self.passwordField.text isEqualToString:self.aginField.text]) {
        [TRHUDUtil showMessageWithText:@"确认密码不一致"];
        return NO;
    }
    if (![NSString checkPassword:self.passwordField.text]){
        [TRHUDUtil showMessageWithText:@"密码格式不对。至少包含大写字母、小写字母、数字和符号其中三种。"];
        return NO;
    }
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField{
    NSInteger validTextLength = textField.text.length;
    if (validTextLength > 0) {
        if (textField == self.passwordField) {
            self.passwordField.text = textField.text;
            if (validTextLength > 20) {
                self.passwordField.text = [textField.text substringToIndex:20];
            }
        } else if (textField == self.aginField) {
            self.aginField.text = textField.text;
            if (validTextLength > 20) {
                self.aginField.text = [textField.text substringToIndex:20];
            }
        }
    }
    if (self.passwordField.text.length > 5 &&  self.aginField.text.length >5) {
        self.sureButton.userInteractionEnabled=YES;
        self.sureButton.backgroundColor = BLUECOLOR;
        self.sureButton.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.sureButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
        self.sureButton.titleLabel.textColor = [UIColor tr_colorwithHexString:@"#999999"];
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
