//
//  YH_PhotoBottomView.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/22.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "YH_PhotoBottomView.h"

@interface YH_PhotoBottomView ()

@property (strong, nonatomic) UIButton *chooseBtn;

@property (strong, nonatomic) UIButton *countBtn;

@end

@implementation YH_PhotoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.chooseBtn];
        [self addSubview:self.countBtn];
    }
    return self;
}
- (void)chooseAction:(UIButton *)sender
{
   BLOCK_EXEC(self.chooseBlock);
}

- (void)countAction:(UIButton *)sender
{
     BLOCK_EXEC(self.updateBlock);
}
- (void)updateCountBtn:(NSInteger)count
{
  [self.countBtn setTitle:[NSString stringWithFormat:@"完成(%lu)", (unsigned long) count] forState:UIControlStateNormal];
  
}
- (UIButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(15.0f, 0.0f, 60.0f, CGRectGetHeight(self.frame));
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [_chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

- (UIButton *)countBtn
{
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 71.0f, (CGRectGetHeight(self.frame)-28.0f)/2, 55.0f, 28.0f);
        _countBtn.backgroundColor = BLUECOLOR;
        [_countBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countBtn setTitle:@"0" forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(countAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
