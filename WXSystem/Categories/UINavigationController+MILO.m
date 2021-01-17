//
//  UINavigationController+MILO.m
//  MiloFoundation
//
//  Created by candy.chen on 2017/8/15.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import "UINavigationController+MILO.h"

@implementation UINavigationController (MILO)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottomTabBar:(BOOL)hide
{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; 
    }
    [self pushViewController:viewController animated:animated];
}

@end
