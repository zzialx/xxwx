//
//  TR_RepairProgressHeadView.m
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairProgressHeadView.h"

@interface TR_RepairProgressHeadView ()
@property (weak, nonatomic) IBOutlet UIButton *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (assign,nonatomic)BOOL isOpen;
@end


@implementation TR_RepairProgressHeadView

- (void)setModel:(TR_ServicePgrModel *)model{
    _model = model;
    NSString * headUrl = [NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,_model.avatarUrl];
    [self.headImg sd_setBackgroundImageWithURL:[NSURL URLWithString:headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo_login"]];
    self.nameLab.text = _model.realName;
    self.phoneLab.text = _model.mobile;
}

- (IBAction)showCellAction:(UIButton*)sender {
    if (!self.model.hasInfo.boolValue) {
        [TRHUDUtil showMessageWithText:@"无进度详情"];
        return;
    }
    self.isShowMore=!self.isShowMore;
    BLOCK_EXEC(self.showServiceDetial,self.model.processId, self.isShowMore);
}
- (void)setIsShowMore:(BOOL)isShowMore{
    _isShowMore = isShowMore;
    self.line.hidden = !_isShowMore;
    if (_isShowMore) {
        [self.openBtn setImage:[UIImage imageNamed:@"more_up"] forState:UIControlStateNormal];
    }else{
        [self.openBtn setImage:[UIImage imageNamed:@"more_down"] forState:UIControlStateNormal];
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.headImg.layer.cornerRadius=20;
    self.headImg.layer.masksToBounds=YES;
    self.line.hidden=YES;
    [self addBorderToLayer:self.line];
}
- (void)addBorderToLayer:(UIView *)view{
    view.bounds=CGRectMake(view.frame.origin.x, view.frame.origin.y, KScreenWidth-15*3-11, 0.5);
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
@end
