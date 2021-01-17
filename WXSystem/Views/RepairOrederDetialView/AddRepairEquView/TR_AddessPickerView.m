//
//  TR_AddessPickerView.m
//  WXSystem
//
//  Created by admin on 2019/11/21.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddessPickerView.h"

@interface TR_AddessPickerView()
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIView * bottomView;
@property(nonatomic,strong)UIButton * cancleBtn;///<取消按钮
@property(nonatomic,strong)UIButton * finishBtn;///<完成按钮
@property(nonatomic,strong)UILabel * titleLab;///<标题

@end

@implementation TR_AddessPickerView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (UIView*)bottomView{
    if (IsNilOrNull(_bottomView)) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-435, KScreenWidth, 435)];
        [self addSubview:_bottomView];
        _bottomView.backgroundColor=UIColor.whiteColor;
    }
    return _bottomView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
