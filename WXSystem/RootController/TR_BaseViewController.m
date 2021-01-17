//
//  TR_BaseViewController.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"
#import "TR_ProtocolWebViewController.h"
#import "TR_NavigationViewController.h"
#import "TR_TabBarViewController.h"
#import "SKFPreViewNavController.h"
@interface TR_BaseViewController ()
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation TR_BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.navigationController.childViewControllers count] == 1) {
        self.navView.leftImg.hidden = YES;
        self.navView.lblLeft.hidden = YES;
    }
    [self.navView.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLoginOutClick:) name:TRNotificationMacLoginOutStatus object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appLoginOutClick:(NSNotification *)note
{
    [TRHUDUtil showMessageWithText:@"你的账号已在另一台设备上登录，请重新登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //移除缓存
        [[TR_SystemInfo mainSystem]clearApplicationConfigure];
        TR_LoginViewController *loginVC = [[TR_LoginViewController alloc] initWithNibName:@"TR_LoginViewController" bundle:nil];
        TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:loginVC];
        navVC.navigationBarHidden = YES;
        loginVC.loginResult = ^(BOOL loginSuccess) {
            if (loginSuccess) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
                 [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
            }
        };
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navVC animated:YES completion:nil];
    });
}

- (TR_NODateView *)noDataView
{
    _noDataView = nil;
    if (!_noDataView) {
        _noDataView = [[TR_NODateView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), KScreenWidth, KScreenHeight - KNAV_HEIGHT)];
    }
    return _noDataView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)leftBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)backToTheRootVC{
    UIViewController *rootVC = self.presentingViewController;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)userLoginAction:(LoginResult)result
{
    if (TR_LOGIN) {
        result(YES);
        return;
    }
    TR_LoginViewController *loginVC = [[TR_LoginViewController alloc] initWithNibName:@"TR_LoginViewController" bundle:nil];
    TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:loginVC];
     navVC.navigationBarHidden = YES;
    loginVC.loginResult = ^(BOOL loginSuccess) {
        if (loginSuccess) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                 [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
            }];
             [TR_TabBarViewController defaultTabBar].selectedIndex = 0;
        }
    };
     navVC.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:navVC animated:YES completion:nil];
}

- (void)showLinkStateView
{
    [TRHUDUtil showMessageWithText:@"网络错误"];
}

- (void)jumpWebView:(NSString *)url
{
    TR_ProtocolWebViewController *webVC = [[TR_ProtocolWebViewController alloc]initWithProtocolType:url];
    [self.navigationController pushViewController:webVC animated:YES hideBottomTabBar:YES];
}
#pragma mark----查看大图
- (void)showBigPicturesWithList:(NSArray*)list index:(NSInteger)index{
    NSMutableArray * picList =[NSMutableArray arrayWithCapacity:0];
    for (NSString * url in list) {
        [picList addObject:[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,url]];
    }
    
    SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:picList index:index];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen ;
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)openFileContent:(NSString*)path fileName:(NSString*)fileName{
    TR_ProtocolWebViewController *webVC = [[TR_ProtocolWebViewController alloc]initWithProtocolType:path];
    webVC.fileName=fileName;
    [self.navigationController pushViewController:webVC animated:YES hideBottomTabBar:YES];
}
#pragma mark - getters

- (TR_PushMessageEngine *)pushHandleObject
{
    if (nil == _pushHandleObject) {
        _pushHandleObject = [TR_PushMessageEngine sharedHandler];
        WS(weakSelf);
        _pushHandleObject.engineblock = ^(TR_JumpType type, id data) {
            switch (type) {
                case TR_JumpTypeH5:
                    [weakSelf jumpWebView:data];
                    break;
                default:
                    break;
            }
        };
    }
    return _pushHandleObject;
}



-(TENaviView *)navView{
    if (!_navView) {
        _navView = [[TENaviView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KNAV_HEIGHT)];
        [self.view addSubview:_navView];
    }
    return _navView;
}

@end
