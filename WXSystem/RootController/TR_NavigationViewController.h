//
//  TR_NavigationViewController.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ML_NavigationControllerDelegate <NSObject>

@optional

- (BOOL)NavigationControllerGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

@end

@interface TR_NavigationViewController : UINavigationController

@property (nonatomic, strong) UIView *overlayView;

- (UIViewController *)rootViewController;

@end
