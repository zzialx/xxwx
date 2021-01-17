//
//  TR_ChangePhoneView.m
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ChangePhoneView.h"

@interface TR_ChangePhoneView ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation TR_ChangePhoneView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.changeBtn.layer.cornerRadius = 8;
    self.changeBtn.layer.masksToBounds=YES;
}
- (void)showPhone:(NSString *)phone{
    self.phoneLab.text=[NSString stringWithFormat:@"当前手机号：%@",phone];
}
- (IBAction)changeAction:(UIButton *)sender {
    if (self.nextStep) {
        self.nextStep();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
