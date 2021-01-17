//
//  TRHUDUtil.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TRHUDUtil.h"
#import "AppDelegate.h"

@implementation TRHUDUtil

+ (void)showMessageWithText:(NSString *)text
{
    
    if (MakeStringNotNil(text).length > 0) {
        [self hideHud:nil];
        [self performSelectorOnMainThread:@selector(showMessageOnMainThreadWithText:) withObject:text waitUntilDone:YES];
    } else {
        
    }
}

+ (void)hideHud:(UIView *)view
{
    [self performSelectorOnMainThread:@selector(hideHudOnMianThread:) withObject:view waitUntilDone:YES];
}

+ (void)showMessageOnMainThreadWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    [label sizeToFit];
    
    UIView *view = [AppDelegate currentAppdelegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = label;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.alpha = 0.85f;
    hud.bezelView.color = [UIColor blackColor];
    hud.margin = MarginFactor(18.0f);
    [hud hideAnimated:YES afterDelay:1.0f];
}

+ (void)hideHudOnMianThread:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subView) hideAnimated:YES];
        }
    }
}

@end
