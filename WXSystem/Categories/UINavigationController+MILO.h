//
//  UINavigationController+MILO.h
//  MiloFoundation
//
//  Created by candy.chen on 2017/8/15.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MILO)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottomTabBar:(BOOL)hide;

@end
