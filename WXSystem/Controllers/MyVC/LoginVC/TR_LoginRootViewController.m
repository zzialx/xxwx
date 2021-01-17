//
//  TR_LoginRootViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_LoginRootViewController.h"

@interface TR_LoginRootViewController ()

@end

@implementation TR_LoginRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navView];
    self.myModel = [TR_MyViewModel defaultMyVM];
    [self.navView.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navView.lblLeft.hidden = YES;
    self.navView.lblBottom.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)leftBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}
-(TENaviView *)navView{
    if (!_navView) {
        _navView = [[TENaviView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KNAV_HEIGHT)];
        [self.view addSubview:_navView];
    }
    return _navView;
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
