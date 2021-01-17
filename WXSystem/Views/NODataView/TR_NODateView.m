//
//  TR_NODateView.m
//  HouseProperty
//
//  Created by zzialx on 2019/2/12/13.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_NODateView.h"

@implementation TR_NODateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImageView *)noDataImg
{
    if (!_noDataImg) {
        _noDataImg = [UIImageView new];
        [self addSubview:_noDataImg];
        _noDataImg.sd_layout.centerXEqualToView(self).topSpaceToView(self, 50).widthIs(160).heightIs(160);
    }
    return _noDataImg;
}
- (UILabel *)noDataLab
{
    if (!_noDataLab) {
        _noDataLab = [UILabel new];
        [self addSubview:_noDataLab]; _noDataLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.noDataImg, 20).widthRatioToView(self, 1).heightIs(30);
        _noDataLab.textAlignment = 1;
        _noDataLab.font = [UIFont systemFontOfSize:18];
        _noDataLab.textColor = [UIColor darkGrayColor];
    }
    return _noDataLab;
}
- (instancetype)initWithFrame:(CGRect)frame type:(NO_DATATYPE)type
{
    if (self = [super initWithFrame:frame]) {
        [self setNoDataType:type];
    }
    return self;
}
- (instancetype)setNoDataType:(NO_DATATYPE)type
{
    if (type == NO_DATATYPE_NODATA) {
        [self.noDataImg setImage:[UIImage imageNamed:@"no_data"]];
        [self.noDataLab setText:@"暂无数据"];
    }if (type == NO_DATATYPE_NOSEARCH) {
        [self.noDataImg setImage:[UIImage imageNamed:@"no_search"]];
        [self.noDataLab setText:@"搜索无结果"];
    }if (type == NO_DATATYPE_NETERROR) {
        [self.noDataImg setImage:[UIImage imageNamed:@"no_net"]];
        [self.noDataLab setText:@"网络异常，请刷新"];
    }if (type == NO_DATATYPE_ERROR) {
        [self.noDataImg setImage:[UIImage imageNamed:@"no_error"]];
        [self.noDataLab setText:@"系统异常，请刷新"];
    }
    return self;
}
@end
