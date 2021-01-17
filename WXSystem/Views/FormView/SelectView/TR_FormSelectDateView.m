//
//  TR_FormSelectDateView.m
//  OASystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormSelectDateView.h"

@interface TR_FormSelectDateView ()
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *backgroundView;
@end

@implementation TR_FormSelectDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.resetButton];
        [self.backgroundView addSubview:self.sureButton];
        [self setupDateKeyPan];
        [self.backgroundView addSubview:self.datePicker];
    }
    return self;
}

- (void)showChannelChooseView:(NSArray *)array;
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)resetButtonClick:(UIButton *)sender
{
    
}

- (void)sureButtonClick:(UIButton *)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *dateStr = [formatter  stringFromDate:self.datePicker.date];
    NSLog(@"dateStr:%@",dateStr);
    BLOCK_EXEC(self.selectDateBlock,dateStr,nil);
    [self hideChannelChooseView];
}

- (void)hideChannelChooseView{
    [self removeFromSuperview];
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [self hideChannelChooseView];
}

- (void)setupDateKeyPan {
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.backgroundView.frame), CGRectGetHeight(self.backgroundView.frame) - 50)];
    //设置地区: zh-中国
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    [ self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    NSLog(@"dateStr:%@",dateStr);
}

- (UIButton *)resetButton
{
    if (IsNilOrNull(_resetButton)){
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.frame = CGRectMake(0,0, 60, 40);
        [_resetButton setTitle:@"取消" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIButton *)sureButton
{
    if (IsNilOrNull(_sureButton)){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(CGRectGetWidth(self.backgroundView.frame) - 60, 0, 60, 40);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor tr_colorwithHexString:@"#4C9FFF"] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)backgroundView
{
    if (IsNilOrNull(_backgroundView)) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 300, self.frame.size.width,300)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 8.0f;
    }
    return _backgroundView;
}

- (UIView *)maskView
{
    if (IsNilOrNull(_maskView)) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_maskView addGestureRecognizer:tap1];
    }
    return _maskView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
