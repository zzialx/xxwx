//
//  TR_VersionView.m
//  WXSystem
//
//  Created by candy.chen on 2019/5/23.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_VersionView.h"

@interface TR_VersionView ()

@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIButton *sureButton;

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIImageView *versionImage;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextView *contentView;

@property (strong, nonatomic) TR_VersionModel *versionModel;

@end

@implementation TR_VersionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.versionImage];
        [self.backgroundView addSubview:self.closeButton];
        [self.backgroundView addSubview:self.titleLabel];
        [self.backgroundView addSubview:self.contentView];
        [self.backgroundView addSubview:self.sureButton];
    }
    return self;
}

- (void)showChannelChooseView:(TR_VersionModel *)model;
{
    self.versionModel = model;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if ([self.versionModel.versionRule isEqualToString:@"1"]) {
        self.closeButton.hidden = NO;
    } else  {
        self.closeButton.hidden = YES;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"发现新版本(V%@)",self.versionModel.versionCode];
    self.contentView.text = [NSString stringWithFormat:@"%@",self.versionModel.updateInfo];
}

- (void)closeButtonClick:(UIButton *)sender
{
    [self hideChannelChooseView];
}

- (void)sureButtonClick:(UIButton *)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl, self.versionModel.fileUrl]]];  
}

- (void)hideChannelChooseView{
    [self removeFromSuperview];
}

- (UIButton *)closeButton
{
    if (IsNilOrNull(_closeButton)){
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(250,15, 30, 30);
        [_closeButton setImage:[UIImage imageNamed:@"versionClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)sureButton
{
    if (IsNilOrNull(_sureButton)){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(50, self.backgroundView.frame.size.height - 60, 190, 40);
        [_sureButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _sureButton.backgroundColor = BLUECOLOR;
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)backgroundView
{
    if (IsNilOrNull(_backgroundView)) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 290)/2, (self.frame.size.height - 350)/2, 290,350)];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 5.0f;
    }
    return _backgroundView;
}

- (UIView *)maskView
{
    if (IsNilOrNull(_maskView)) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _maskView;
}

- (UIImageView *)versionImage
{
    if (IsNilOrNull(_versionImage)) {
        _versionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 290,100)];
        _versionImage.image = [UIImage imageNamed:@"versionImage"];
    }
    return _versionImage;
}

- (UILabel *)titleLabel
{
     if (IsNilOrNull(_titleLabel)) {
         _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 250,25)];
         _titleLabel.text = @"";
         _titleLabel.font = [UIFont systemFontOfSize:16.0f];
         _titleLabel.textColor = [UIColor tr_colorwithHexString:@"#333333"];
     }
     return _titleLabel;
}

- (UITextView *)contentView
{
    if (IsNilOrNull(_contentView)) {
        _contentView = [[UITextView alloc]initWithFrame:CGRectMake(20, 145, 250,130)];
        _contentView.text = @"";
        _contentView.editable = NO;
        _contentView.font = [UIFont systemFontOfSize:14.0f];
        _contentView.textColor = [UIColor tr_colorwithHexString:@"#333333"];
    }
    return _contentView;
}
@end
