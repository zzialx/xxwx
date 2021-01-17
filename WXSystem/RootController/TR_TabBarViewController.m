//
//  TR_TabBarViewController.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_TabBarViewController.h"
#import "TR_HomeViewController.h"
#import "TR_RepairOrderViewController.h"
#import "TR_MyViewController.h"
#import "TR_RepairListViewController.h"

@interface TR_TabBarViewController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@end

@implementation TR_TabBarViewController

+ (instancetype)defaultTabBar
{
    static TR_TabBarViewController * _defaultTabBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultTabBar = [[self alloc]init];
    });
    return _defaultTabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLECOLOR;
    self.delegate = self;
    
    [self getTabbarStyle];
    // 1.初始化子控制器
    
    TR_HomeViewController *homeVC = [[TR_HomeViewController alloc] init];
    self.homeNavi = [self addChildVc:homeVC title:@"首页" image:@"shouye" selectedImage:@"shouye_select"];
    
    TR_RepairListViewController *addressVC = [[TR_RepairListViewController alloc] init];
    self.repairOrederNav = [self addChildVc:addressVC title:@"工单" image:@"order" selectedImage:@"order_select"];
    
    
    TR_MyViewController *myVC = [[TR_MyViewController alloc] init];
    self.myNav = [self addChildVc:myVC title:@"我的" image:@"geren" selectedImage:@"geren_select"];
    self.selectedIndex = 0;
    self.viewControllers = @[self.homeNavi, self.repairOrederNav, self.myNav];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTabbarStyle
{
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.tabBar setTintColor:BLUECOLOR];
    self.tabBar.translucent = NO;
    self.tabBar.alpha = 0.95f;
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, KScreenWidth, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [UIColor tr_colorwithHexString:@"#E5E5E5"].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self.tabBar setShadowImage:img];
}

- (TR_NavigationViewController *)selectedNavi
{
    TR_NavigationViewController *nav;
    switch (self.selectedIndex) {
        case 0:
            nav = self.homeNavi;
            break;
        case 1:
            nav = self.repairOrederNav;
            break;
        case 2:
            nav = self.myNav;
            break;
        default:
            break;
    }
    return nav;
}

- (TR_NavigationViewController *)addChildVc:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVC.title = title;
    
    TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:childVC];
    navVC.tabBarItem.image = [UIImage imageNamed:image];
    navVC.tabBarItem.image = [navVC.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    navVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    navVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    navVC.delegate = self;
    navVC.navigationBarHidden = YES;
    return navVC;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
     NSLog(@"角标数量====%ld",[UIApplication sharedApplication].applicationIconBadgeNumber);
//    NSInteger tabIndex = [tabBar.items indexOfObject:item];
//    if (tabIndex ==1) {
//        [self.addressNav popToRootViewControllerAnimated:YES];
//    }
}
#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.navigationSubDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.navigationSubDelegate navigationController:navigationController willShowViewController:viewController animated:YES];
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
