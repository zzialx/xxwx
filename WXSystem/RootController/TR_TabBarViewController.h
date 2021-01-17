//
//  TR_TabBarViewController.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_NavigationViewController.h"

@interface TR_TabBarViewController : UITabBarController

@property (strong, nonatomic) TR_NavigationViewController *selectedNavi;

@property (strong, nonatomic) TR_NavigationViewController *homeNavi;

@property (strong, nonatomic) TR_NavigationViewController *repairOrederNav;

@property (strong, nonatomic) TR_NavigationViewController *myNav;

@property (weak, nonatomic) id<UINavigationControllerDelegate> navigationSubDelegate;

+ (instancetype)defaultTabBar;



@end
