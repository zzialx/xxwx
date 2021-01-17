//
//  TR_AboutViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_AboutViewController.h"

@interface TR_AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@end

@implementation TR_AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABLECOLOR;
    // Do any additional setup after loading the view from its nib.
    self.logoImage.image = [UIImage imageNamed:@"icon_about"];
    self.logoImage.layer.cornerRadius = 15.0f;
    self.logoImage.clipsToBounds = YES;
    self.versionLabel.text = [NSString stringWithFormat:@"版本%@",kBundleVersionString];
    [self.navView setLeftImg:@"back" title:@"关于"];
    self.navView.lblLeft.hidden = NO;
}
- (IBAction)versionClick:(id)sender {
    NSDictionary *dic = @{@"versionCode":kBundleVersionString,@"systemType":@"2"};
    [self.myModel userVersion:dic completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [GVUserDefaults standardUserDefaults].fileUrl,self.myModel.versionModel.fileUrl]]];
        } else {
             [TRHUDUtil showMessageWithText:@"当前是最新版本"];
//            NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8"; //更换id即可
            
        }
    }];
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
