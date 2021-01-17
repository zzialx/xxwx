//
//  TR_MyHeaderCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_MyHeaderCell.h"

@interface TR_MyHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *manyiLab;

@property (weak, nonatomic) IBOutlet UILabel *organizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixiuLeavelLab;
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@end

@implementation TR_MyHeaderCell

- (void)updateMyHeader
{
    NSString *string = MakeStringNotNil([[TR_SystemInfo mainSystem].userInfo avatarUrl]);
    NSString *realName = MakeStringNotNil([[TR_SystemInfo mainSystem].userInfo realName]);
    if (realName.length >8){
        realName = [realName substringToIndex:8];
    }
    self.nameLabel.text = realName;
    [self.logoImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"logo_login"]];
    self.logoImage.hidden = NO;
    self.weixiuLeavelLab.text = MakeStringNotNil([[TR_SystemInfo mainSystem].userInfo label]);
    self.totalLab.text=[NSString stringWithFormat:@"%ld",[[TR_SystemInfo mainSystem].userInfo monthServer]];
    CGFloat manyidu = [[[TR_SystemInfo mainSystem].userInfo monthReturnDegree] floatValue];
    self.manyiLab.text=[NSString stringWithFormat:@"%.2lf%@",manyidu*100,@"%"];
}

- (IBAction)showInfoAction:(UIButton *)sender {
    BLOCK_EXEC(self.showInfo);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logoImage.layer.cornerRadius = 41.0f;
    self.logoImage.layer.masksToBounds = YES;
    
    self.viewBg.layer.cornerRadius=8.0f;
    self.viewBg.layer.masksToBounds=YES;
}

@end
