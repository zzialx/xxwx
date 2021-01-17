//
//  TR_RepairHeadTitleCell.m
//  WXSystem
//
//  Created by admin on 2019/11/13.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairHeadTitleCell.h"

@interface TR_RepairHeadTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLba;
@property (weak, nonatomic) IBOutlet UILabel *repairStateLab;

@end

@implementation TR_RepairHeadTitleCell
- (void)setModel:(TR_RepairDetialModel *)model{
    _model = model;
    _titleLba.text = _model.orderTitle;
    _repairStateLab.text = _model.nowStatusName;
    _repairStateLab.backgroundColor=[self stateLabColor:_model.nowStatusName];
}
- (UIColor*)stateLabColor:(NSString*)nowState{
    UIColor * color = UICOLOR_RGBA(255, 192, 105);
    if ([nowState isEqualToString:@"待接单"]) {
        color = UICOLOR_RGBA(255, 192, 105);
    }if ([nowState isEqualToString:@"待服务"]) {
        color = UICOLOR_RGBA(255, 120, 117);
    }if ([nowState isEqualToString:@"服务中"]) {
        color = UICOLOR_RGBA(149, 222, 100);
    }if ([nowState isEqualToString:@"待回访"]) {
        color = UICOLOR_RGBA(92, 219, 211);
    }if ([nowState isEqualToString:@"已取消"]) {
        color = UICOLOR_RGBA(184, 196, 206);
    }
    return color;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
