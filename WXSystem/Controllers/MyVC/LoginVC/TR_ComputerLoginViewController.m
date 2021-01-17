//
//  TR_ComputerLoginViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/21.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ComputerLoginViewController.h"

@interface TR_ComputerLoginViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation TR_ComputerLoginViewController

- (IBAction)loginClick:(id)sender {
    UIActionSheet *sheet;
    if ([[GVUserDefaults standardUserDefaults].macLogin isEqualToString:@"Y"]) {
        sheet = [[UIActionSheet alloc]initWithTitle:@"确认登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认登录", nil];
    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认退出", nil];
    }
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * islogin = MakeStringNotNil([GVUserDefaults standardUserDefaults].macLogin);
        NSString *string = @"";
        NSString *nextLogin = @"";
        if ([islogin isEqualToString:@"Y"]) {
            string = @"登录";
            nextLogin = @"N";
            NSDictionary *dic = @{@"flag":islogin,@"url":self.result};
            WS(weakSelf);
            [[TR_MyViewModel defaultMyVM] userMacLogin:dic completionBlock:^(BOOL flag, NSString *error) {
                if (flag) {
                    [GVUserDefaults standardUserDefaults].macLogin = nextLogin;
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"%@成功",string]];
                } else {
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"%@失败",string]];
                }
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            string = @"登出";
            nextLogin = @"Y";
            WS(weakSelf);
            [[TR_MyViewModel defaultMyVM] userMacScanLoginOut:@{} completionBlock:^(BOOL flag, NSString *error) {
                if (flag) {
                    [GVUserDefaults standardUserDefaults].macLogin = nextLogin;
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"%@成功",string]];
                } else {
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"%@失败",string]];
                }
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.titleLabel.text = @"确认登录";
    self.login.backgroundColor = BLUECOLOR;
    NSString * islogin = MakeStringNotNil([GVUserDefaults standardUserDefaults].macLogin);
    if ([islogin isEqualToString:@"Y"]) {
        [self.login setTitle:@"确认登录" forState:UIControlStateNormal];
    } else {
        [self.login setTitle:@"退出电脑端" forState:UIControlStateNormal];
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
