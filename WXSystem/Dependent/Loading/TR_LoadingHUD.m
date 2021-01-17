//
//  TR_LoadingHUD.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_LoadingHUD.h"

CGFloat const kAnimationImageWidth = 50.f;
CGFloat const kAnimationImageHeight = 50.f;

static CGFloat const kAnimationDuration = 0.1f;
static void *kYH_HUDkey = &kYH_HUDkey;

@interface TR_LoadingHUD ()

@property (strong, nonatomic) UIImageView *animationImageView;

@end

@implementation TR_LoadingHUD

+ (instancetype)sharedHud
{
    static dispatch_once_t onceToken;
    static TR_LoadingHUD *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[TR_LoadingHUD alloc] init];
    });
    
    return instance;
}

+ (instancetype)make {
    return [[TR_LoadingHUD alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        self.contentMode = UIViewContentModeCenter;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)drawHUD
{
    [self addSubview:self.animationImageView];
}

#pragma show & hide

- (void)startRotationAnimation
{
    LogInfo(@"loadinghud start rotation animation");
    if (!self.animationImageView.isAnimating) {
        [self.animationImageView startAnimating];
    }
}

- (void)stopRotationAnimation
{
    LogInfo(@"loadinghud stop rotation animation");
    
    [self removeFromSuperview];
    
    if (self.animationImageView.isAnimating) {
        [self.animationImageView stopAnimating];
    }
}

- (void)show {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [self showInView:keyWindow];
}

- (void)showInView:(UIView *)view {
    
    [self showInView:view positionScale:0.5f];
}

- (void)showInView:(UIView *)view positionScale:(CGFloat)scale {
    
    if (!view || self.superview) {
        return;
    }
    
    TR_LoadingHUD *hud = objc_getAssociatedObject(view, &kYH_HUDkey);
    if (hud) {
        [view addSubview:hud];
        hud.hidden = NO;
        hud.alpha = 1.f;
        [hud startRotationAnimation];
        return;
    }
    
    objc_setAssociatedObject(view, &kYH_HUDkey, self, OBJC_ASSOCIATION_RETAIN);
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self setFrame:CGRectOffset(view.bounds, 0.f, 0.f)];
    [self drawHUD];
    
    [view addSubview:self];
    
    CGPoint centerPoint = self.center;
    [self.animationImageView setCenter:CGPointMake(centerPoint.x, CGRectGetHeight(self.bounds)*scale)];
    
    [UIView beginAnimations:@"showAnimation" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(startRotationAnimation)];
    [self.animationImageView setAlpha:1.0f];
    
    [UIView commitAnimations];
}

- (void)dismiss
{
    if (self.superview) {
        CGPoint centerPoint = self.animationImageView.center;
        
        [UIView beginAnimations:@"dismissAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.1f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDidStopSelector:@selector(stopRotationAnimation)];
        
        [self.animationImageView setCenter:CGPointMake(centerPoint.x, centerPoint.y)];
        [self.animationImageView setAlpha:0.0f];
        
        [UIView commitAnimations];
    }
}

- (void)dismissInView:(UIView *)view
{
    for (UIView *tempView in view.subviews) {
        if ([tempView isKindOfClass:[self class]]) {
            [(TR_LoadingHUD *)tempView dismiss];
        }
    }
}

#pragma mark- getter
- (UIImageView *)animationImageView
{
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, kAnimationImageWidth, kAnimationImageHeight)];
        [_animationImageView setAlpha:0.f];
        [_animationImageView setAnimationDuration:1.f];
        [_animationImageView setAnimationImages:[[TR_Global sharedInstance] loadingAnimationImages]];
        _animationImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _animationImageView;
}


@end

#pragma mark -
@implementation UIView (TR_LoadingHUD)

- (void)yh_dismissHud {
    TR_LoadingHUD *hud = objc_getAssociatedObject(self, &kYH_HUDkey);
    if (!hud) {
        return;
    }
    
    [hud dismissInView:self];
    objc_setAssociatedObject(self, &kYH_HUDkey, nil, OBJC_ASSOCIATION_RETAIN);
}

- (TR_LoadingHUD *)yh_loadingHUD {
    return objc_getAssociatedObject(self, &kYH_HUDkey);
}

@end
