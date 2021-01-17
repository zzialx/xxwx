//
//  TR_LoadingHUD.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kAnimationImageWidth ;
extern CGFloat const kAnimationImageHeight ;

@class TR_LoadingHUD;

@interface UIView (TR_LoadingHUD)

- (void)yh_dismissHud;

- (TR_LoadingHUD *)yh_loadingHUD;

@end


@interface TR_LoadingHUD : UIView

+ (instancetype)sharedHud;

+ (instancetype)make;

- (void)show;

- (void)showInView:(UIView *)view;

- (void)showInView:(UIView *)view positionScale:(CGFloat)scale;

- (void)dismiss;

- (void)dismissInView:(UIView *)view;


@end
