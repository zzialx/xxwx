//
//  UIView+Clicks.m
//  HouseProperty
//
//  Created by isaac on 2019/2/12/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "UIView+Clicks.h"

@implementation UIView (Clicks)
- (void)addClickEvent:(id)target action:(SEL)action{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
}

/**
 *  获取父视图的控制器
 *
 *  @return 父视图的控制器
 */
- (TR_BaseViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (TR_BaseViewController *)nextResponder;
        }
    }
    return nil;
}
@end
