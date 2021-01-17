//
//  TR_HomeHeadLogoCell.m
//  WXSystem
//
//  Created by admin on 2019/11/11.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_HomeHeadLogoCell.h"

@interface TR_HomeHeadLogoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headLogo;
@property (weak, nonatomic) IBOutlet UIView *headLineView;

@end

@implementation TR_HomeHeadLogoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //绘制圆角 要设置的圆角 使用“|”来组合
    self.headLineView.bounds=CGRectMake(0, self.headLineView.bounds.origin.y, KScreenWidth, 20);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headLineView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.headLineView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.headLineView.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
