//
//  TR_NavigationViewController.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_NavigationViewController.h"

@interface TR_NavigationViewController ()<UITabBarControllerDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation TR_NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        //跳转渐隐效果
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    //    SYRootViewController *contoller = [self.childViewControllers lastObject];
    //    if ([contoller isKindOfClass:[SYLoginViewController class]]) {
    //        return NO;
    //    }
    return YES;
}

- (UIViewController *)rootViewController
{
    return [self.viewControllers firstObject];
}

-(BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
