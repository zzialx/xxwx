//
//  TR_HeadTableViewCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/20.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_HeadTableViewCell.h"

@interface TR_HeadTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation TR_HeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headView.layer.cornerRadius = 20.0f;
    // Initialization code
    self.headImage.layer.cornerRadius = 20.0f;
    self.headImage.layer.masksToBounds = YES;
}

- (void)updateHead:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            NSString *string = MakeStringNotNil([[[TR_SystemInfo mainSystem]userInfo] avatarUrl]);
            self.titleLabel.text = @"头像";
            self.headView.backgroundColor = [UIColor whiteColor];
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"logo_login"]];
            self.headImage.hidden = NO;
        } else if (indexPath.row == 1) {
            self.titleLabel.text = @"姓名";
            self.headLabel.text = [[[TR_SystemInfo mainSystem]userInfo] realName];
            self.arrow.hidden=YES;
            self.headImage.hidden = YES;
        } else if (indexPath.row == 2) {
            self.titleLabel.text = @"手机号";
            self.headLabel.text = [[[TR_SystemInfo mainSystem]userInfo] mobile];
            self.headImage.hidden = YES;
        }
    }if (indexPath.section==1) {
        self.titleLabel.text = @"技能标签";
        self.headLabel.text =[[[TR_SystemInfo mainSystem]userInfo] label];
        self.arrow.hidden=YES;
        self.headImage.hidden = YES;
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
