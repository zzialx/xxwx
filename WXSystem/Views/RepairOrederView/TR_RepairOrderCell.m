//
//  TR_RepairOrderCell.m
//  WXSystem
//
//  Created by admin on 2019/11/12.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairOrderCell.h"

@interface TR_RepairOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderUserLab;
@property (weak, nonatomic) IBOutlet UILabel *orderAddressLab;
@property (weak, nonatomic) IBOutlet UIView *line;

@end


@implementation TR_RepairOrderCell
- (void)setModel:(TR_RepairListModel *)model{
    _model = model;
    self.orderTitleLab.text = _model.orderTitle;
    self.orderStateLab.text = _model.nowStatusName;
    self.orderStateLab.backgroundColor=[self stateLabColor:_model.nowStatusName];
    self.orderNumberLab.text = _model.orderNum;
    self.orderTimeLab.text = _model.appointmentTime;
    self.orderUserLab.text = _model.companyName;
    self.orderAddressLab.text = _model.addr;
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
    self.selectionStyle=UITableViewCellSelectionStyleNone;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    //设置大小
//    maskLayer.frame = self.contentView.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    self.contentView.layer.mask = maskLayer;
    [self addBorderToLayer:self.line];
}
- (void)addBorderToLayer:(UIView *)view{
    view.bounds=CGRectMake(view.frame.origin.x, view.frame.origin.y, KScreenWidth-15*4, 0.5);
    CAShapeLayer *border = [CAShapeLayer layer];
    //  线条颜色
    border.strokeColor = UICOLOR_RGBA(221, 221, 221).CGColor;
    border.fillColor = nil;
    UIBezierPath *pat = [UIBezierPath bezierPath];
    [pat moveToPoint:CGPointMake(0, 0)];
    if (CGRectGetWidth(view.frame) > CGRectGetHeight(view.frame)) {
        [pat addLineToPoint:CGPointMake(view.bounds.size.width, 0)];
    }else{
        [pat addLineToPoint:CGPointMake(0, view.bounds.size.height)];
    }
    border.path = pat.CGPath;
    border.frame = view.bounds;
    // 不要设太大 不然看不出效果
    border.lineWidth = 0.5;
    border.lineCap = @"butt";
    //  第一个是 线条长度   第二个是间距    nil时为实线
    border.lineDashPattern = @[@6, @8];
    [view.layer addSublayer:border];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
