//
//  ViewController.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "ViewController.h"
#import "TR_TabBarViewController.h"
#import "TR_LoginViewController.h"
#import "TR_HomeViewModel.h"
@interface ViewController ()
@property (strong, nonatomic) TR_HomeViewModel *homeViewModel;
@end

@implementation ViewController
- (TR_HomeViewModel *)homeViewModel
{
    if (IsNilOrNull(_homeViewModel)) {
        _homeViewModel = [[TR_HomeViewModel alloc]init];
    }
    return _homeViewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
