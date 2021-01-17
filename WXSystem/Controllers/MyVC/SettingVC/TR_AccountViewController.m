//
//  TR_AccountViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/19.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_AccountViewController.h"
#import "TR_ModifyViewController.h"
#import "TR_UpdateUserPhoneVC.h"

@interface TR_AccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation TR_AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setLeftImg:@"back" title:@"账户与安全"];
    self.navView.lblLeft.hidden = NO;
    self.view.backgroundColor = TABLECOLOR;
    self.phoneLabel.text = [[[TR_SystemInfo mainSystem]userInfo]mobile];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)phoneClick:(id)sender {
    TR_UpdateUserPhoneVC * phoneVC = [[TR_UpdateUserPhoneVC alloc]init];
    phoneVC.phone = [[[TR_SystemInfo mainSystem]userInfo]mobile];
    [self.navigationController pushViewController:phoneVC animated:YES];
}

- (IBAction)passwordClick:(id)sender {
    TR_ModifyViewController *modifyVC = [[TR_ModifyViewController alloc]initWithNibName:@"TR_ModifyViewController" bundle:nil];
    [self.navigationController pushViewController:modifyVC animated:YES];
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
