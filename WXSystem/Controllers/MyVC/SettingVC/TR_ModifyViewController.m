//
//  TR_ModifyViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/20.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ModifyViewController.h"
#import "TR_AccountViewController.h"
#import "TR_TabBarViewController.h"
#import "TR_MyViewController.h"

@interface TR_ModifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *aginPassword;
@property (weak, nonatomic) IBOutlet UIButton *oldPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *newpasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *aginPasswordButton;
@end

@implementation TR_ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = TABLECOLOR;
    [self.navView setLeftImg:@"back" title:@"修改密码" rightBtnName:@"完成"];
    self.navView.lblLeft.hidden = NO;
    [self.navView.rightBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.oldPasswordButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
//    [self.oldPasswordButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];
//    [self.newpasswordButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
//    [self.newpasswordButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];
//    [self.aginPasswordButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
//    [self.aginPasswordButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];
    [self.oldPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.newpassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [self.aginPassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)oldPasswordClick:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.oldPassword.secureTextEntry = !button.selected;
}

- (IBAction)newpasswordClick:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.newpassword.secureTextEntry = !button.selected;
}

- (IBAction)aginPasswordClick:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.aginPassword.secureTextEntry = !button.selected;
}

- (void)sureClick:(UIButton *)sender
{
    if ([self checkLoginData]) {
        NSDictionary *data = @{@"oldPassword":MakeStringNotNil([self.oldPassword.text yh_md5String]),@"newPassword":MakeStringNotNil([self.newpassword.text yh_md5String])};
        [[TR_LoadingHUD sharedHud] showInView:self.view];
        WS(weakSelf);
        [self.myModel modifyUserPassword:data completionBlock:^(BOOL flag, NSString *error) {
            [[TR_LoadingHUD sharedHud] dismissInView:weakSelf.view];
            if (flag) {
                //移除缓存
                [[TR_SystemInfo mainSystem]clearApplicationConfigure];

                        TR_LoginViewController *loginVC = [[TR_LoginViewController alloc]initWithNibName:@"TR_LoginViewController" bundle:nil];
                        loginVC.loginResult = ^(BOOL loginSuccess) {
                            if (loginSuccess) {
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
                            }else{
                                [TRHUDUtil showMessageWithText:error];
                            }
                        };
                [self.navigationController pushViewController:loginVC animated:YES hideBottomTabBar:YES];
                
            } else {
                [TRHUDUtil showMessageWithText:error];
            }
        }];
    }
}

- (BOOL)checkLoginData{
    if (self.oldPassword.text.length<1) {
        [TRHUDUtil showMessageWithText:@"请输入密码"];
        return NO;
    }
    if (self.newpassword.text.length < 6) {
        [TRHUDUtil showMessageWithText:@"请输入密码(6-20位字符）"];
        return NO;
    }
    if (self.aginPassword.text.length < 6) {
        [TRHUDUtil showMessageWithText:@"请再次输入密码"];
        return NO;
    }
    if (![self.newpassword.text isEqualToString:self.aginPassword.text]) {
        [TRHUDUtil showMessageWithText:@"确认密码不一致"];
        return NO;
    }
    if (![NSString checkPassword:self.newpassword.text]){
        [TRHUDUtil showMessageWithText:@"密码格式不对。至少包含大写字母、小写字母、数字和符号其中三种。"];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    NSInteger validTextLength = textField.text.length;
    if (validTextLength > 0) {
        if (textField == self.oldPassword) {
            self.oldPassword.text = textField.text;
            if (validTextLength > 20) {
                self.oldPassword.text = [textField.text substringToIndex:20];
            }
        } else if (textField == self.newpassword) {
            self.newpassword.text = textField.text;
            if (validTextLength > 20) {
                self.newpassword.text = [textField.text substringToIndex:20];
            }
        } else if (textField == self.aginPassword) {
            self.aginPassword.text = textField.text;
            if (validTextLength > 20) {
                self.aginPassword.text = [textField.text substringToIndex:20];
            }
        }
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
