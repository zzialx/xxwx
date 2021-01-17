//
//  TR_ChangeSexCell.m
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ChangeSexCell.h"

@interface TR_ChangeSexCell ()
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;


@end

@implementation TR_ChangeSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (void)showCellSex:(NSString*)sex isSelect:(BOOL)isSelect{
    self.sexLab.text = sex;
    if (isSelect) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectAction:(UIButton *)sender {
//    if (self.selectSex) {
//        self.selectSex(sender.tag);
//    }
}
@end
