//
//  TR_LoginViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_LoginViewController.h"
#import "TR_ForgetViewController.h"
#import "TR_NavigationViewController.h"

@interface TR_LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@end

@implementation TR_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordButton setImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [self.passwordButton setImage:[UIImage imageNamed:@"open_login"] forState:UIControlStateSelected];
    self.loginButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
    self.navView.hidden = YES;
    self.logoImage.layer.cornerRadius = 50.0f;
    self.nameView.layer.cornerRadius = 50.0f;
    self.nameView.layer.masksToBounds = YES;
    self.nameLabel.layer.cornerRadius = 50.0f;
    self.nameLabel.layer.masksToBounds = YES;
    self.logoImage.layer.masksToBounds = YES;
    
    if (self.phone.length >0) {
        self.phoneField.text = self.phone;
    } else {
        self.phoneField.text = [[[TR_SystemInfo mainSystem]userInfo]mobile];
    }

   if (self.phoneField.text.length > 0 &&  self.passwordField.text.length >0) {
       self.loginButton.userInteractionEnabled = YES;
       self.loginButton.backgroundColor = BLUECOLOR;
       self.loginButton.titleLabel.textColor = [UIColor whiteColor];
   } else {
      self.loginButton.userInteractionEnabled = NO;
       self.loginButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
       self.loginButton.titleLabel.textColor = [UIColor tr_colorwithHexString:@"#999999"];
   }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];// 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[GVUserDefaults standardUserDefaults].logoArray];
    for (NSData *data in dataArr) {
        TR_UserModel *locationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([locationModel.mobile isEqualToString:self.phoneField.text]) {
            [self.logoImage sd_setImageWithURL:[NSURL URLWithString:locationModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"logo_login"]];
            self.logoImage.hidden = NO;
            self.nameLabel.hidden = YES;
            self.nameView.hidden = YES;
            return;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{[super viewWillDisappear:animated];// 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (IBAction)forgetButton:(id)sender {
    TR_ForgetViewController *forgetVC = [[TR_ForgetViewController alloc] initWithNibName:@"TR_ForgetViewController" bundle:nil];
    forgetVC.phone = self.phoneField.text;
    [self.navigationController pushViewController:forgetVC animated:YES hideBottomTabBar:YES];
}

- (UIViewController *)getTopMostController {
    UIViewController *ctrl = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (true) {
        if (ctrl.presentedViewController) {
            ctrl = ctrl.presentedViewController;
        } else {
            break;
        }
    }
    return ctrl;
}

- (IBAction)passwordButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    self.passwordField.secureTextEntry = !button.selected;
}

- (IBAction)login:(id)sender {
   if ([self checkLoginData]) {
        NSDictionary *loginData = @{@"mobile":self.phoneField.text,@"password":[self.passwordField.text yh_md5String]};
        [self loginAction:loginData];
   }
}

- (BOOL)checkLoginData{
    if (![self.phoneField.text yh_conformsToMobileFormat]) {
        [TRHUDUtil showMessageWithText:@"手机格式不准确，请重新输入"];
        return NO;
    }
    if (self.passwordField.text.length<6) {
        [TRHUDUtil showMessageWithText:@"请输入密码(6-20位字符）"];
        return NO;
    }
    return YES;
}
- (void)loginAction:(NSDictionary *)para {
    [[TR_LoadingHUD sharedHud] showInView:self.view];
    WS(weakSelf);
    [self.myModel userLogin:para completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud] dismissInView:weakSelf.view];
        if (flag) {
            [TRHUDUtil showMessageWithText:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.phoneField.text forKey:LOGIN_PHONE];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSArray *viewcontrollers = self.navigationController.viewControllers;
            if (viewcontrollers.count >1) {
                if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {//push
                    if (weakSelf.loginResult) {
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        weakSelf.loginResult(flag);
                    }else{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            } else {
                if (weakSelf.loginResult) {
                   [self dismissViewControllerAnimated:NO completion:nil];
                   weakSelf.loginResult(flag);
                }else{
                   [self dismissViewControllerAnimated:YES completion:nil];
                }
              
            }
        }else {
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}

- (void)textFieldDidChange:(UITextField *)textField{
    NSInteger validTextLength = textField.text.length;
    if (validTextLength > 0) {
        self.loginButton.userInteractionEnabled=YES;
        if (textField == self.phoneField) {
            self.phoneField.text = textField.text;
            if (validTextLength >= 11) {
                self.phoneField.text = [textField.text substringToIndex:11];
                NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[GVUserDefaults standardUserDefaults].logoArray];
                for (NSData *data in dataArr) {
                    TR_UserModel *locationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if ([locationModel.mobile isEqualToString:self.phoneField.text]) {
                        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:locationModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"logo_login"]];
                        self.logoImage.hidden = NO;
                        self.nameLabel.hidden = YES;
                        self.nameView.hidden = YES;
                        break;
                    }
                }
            } else {
                self.logoImage.image = [UIImage imageNamed:@"logo_login"];
                self.logoImage.hidden = NO;
                self.nameLabel.hidden = YES;
                self.nameView.hidden = YES;
            }
        } else if (textField == self.passwordField) {
            self.passwordField.text = textField.text;
            if (validTextLength > 20) {
                self.passwordField.text = [textField.text substringToIndex:20];
            }
        }
    }
    if (self.phoneField.text.length > 0 &&  self.passwordField.text.length >0) {
        self.loginButton.backgroundColor = BLUECOLOR;
        self.loginButton.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.loginButton.backgroundColor = [UIColor tr_colorwithHexString:@"#F2F2F2"];
        self.loginButton.titleLabel.textColor = [UIColor tr_colorwithHexString:@"#999999"];
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
