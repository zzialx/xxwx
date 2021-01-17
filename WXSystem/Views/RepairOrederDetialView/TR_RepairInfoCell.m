//
//  TR_RepairInfoCell.m
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairInfoCell.h"

@interface TR_RepairInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (assign, nonatomic)NSInteger  selectIndex;
@end

@implementation TR_RepairInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
//工单详情头部
- (void)showCellInfoTitle:(NSString *)title content:(NSString*)content index:(NSInteger)index{
    self.titlelab.text = title;
    self.contentLab.text = content;
    self.selectIndex = index;
    if (index==3) {
        self.infoBtn.hidden=NO;
        [self.infoBtn setBackgroundImage:[UIImage imageNamed:@"phone_logo-1"] forState:UIControlStateNormal];
    }else if (index==4){
        self.infoBtn.hidden=NO;
        [self.infoBtn setBackgroundImage:[UIImage imageNamed:@"address_logo"] forState:UIControlStateNormal];
    }else{
        self.infoBtn.hidden=YES;
    }
}
//设备详情页面
- (void)showEquimentInfoTitle:(NSString *)title content:(NSString*)content index:(NSInteger)index{
    self.titlelab.text = title;
    self.contentLab.text = content;
    self.selectIndex = index;
    if (index==4){
        self.infoBtn.hidden=NO;
        [self.infoBtn setBackgroundImage:[UIImage imageNamed:@"address_logo"] forState:UIControlStateNormal];
    }else{
        self.infoBtn.hidden=YES;
    }
}

- (IBAction)infoBtnAction:(id)sender {
    if (self.selectIndex==4) {
         BLOCK_EXEC(self.showBtnAction,RepairBtnType_Address);
    }if (self.selectIndex==3) {
          BLOCK_EXEC(self.showBtnAction,RepairBtnType_Phone);
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
