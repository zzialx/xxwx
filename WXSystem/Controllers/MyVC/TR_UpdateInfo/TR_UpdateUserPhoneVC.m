//
//  TR_UpdateUserPhoneVC.m
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_UpdateUserPhoneVC.h"
#import "TR_ChangePhoneView.h"
#import "TR_UpdateInfoVC.h"
@interface TR_UpdateUserPhoneVC ()
@property(nonatomic,strong)TR_ChangePhoneView * phoneView;
@end

@implementation TR_UpdateUserPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navView setLeftImg:@"back" title:@"更换手机"];
    self.view.backgroundColor=UICOLOR_RGBA(249, 249, 249);
    [self.phoneView showPhone:self.phone];
}
- (TR_ChangePhoneView*)phoneView{
    if (IsNilOrNull(_phoneView)) {
        _phoneView = (TR_ChangePhoneView*)[[[NSBundle mainBundle] loadNibNamed:@"TR_ChangePhoneView" owner:nil options:nil] lastObject];
        [self.view addSubview:_phoneView];
        _phoneView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.navView, 80).rightSpaceToView(self.view, 0).heightIs(260);
        WS(weakSelf);
        _phoneView.nextStep = ^{
            TR_UpdateInfoVC * vc = [[TR_UpdateInfoVC alloc]init];
            vc.type = TR_PERSON_CHANGE_PHONE;
            [weakSelf.navigationController pushViewController:vc animated:YES hideBottomTabBar:YES];
        };
    }
    return _phoneView;
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
