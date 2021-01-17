//
//  YH_PhotoPickerCell.m
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoPickerCell.h"

#define kImagePickerSelectedViewWidth       30.0f


@interface YH_PhotoPickerCell()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *selectBtn;

@end

@implementation YH_PhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    [self.selectBtn setSelected:NO];
    [self.selectBtn setTitle:@"" forState:UIControlStateNormal];
}

- (void)updateWithImage:(UIImage *)image index:(NSUInteger)index
{
    self.imageView.image = image;
    [self.selectBtn setSelected:(index != NSNotFound)];
    if (index != NSNotFound) {
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%lu", index+1] forState:UIControlStateSelected];
    }
}


- (void)updateCellSelection:(BOOL )isSelected index:(NSUInteger)index {
    
    [self.selectBtn setSelected:isSelected];

    if (index != NSNotFound) {
        [self.selectBtn setTitle:[NSString stringWithFormat:@"%lu", index+1] forState:UIControlStateSelected];
    }
}

- (void)handleSelect:(UIButton *)button
{
    BLOCK_EXEC(self.selectBlock, self, @"");
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.layer.masksToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _imageView;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - kImagePickerSelectedViewWidth, 0, kImagePickerSelectedViewWidth, kImagePickerSelectedViewWidth);
        [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"cmt_choose_icon"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"cmt_number_icon"] forState:UIControlStateSelected];
        [_selectBtn setTitle:@"" forState:UIControlStateNormal];
        [_selectBtn setTitle:@"1" forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(handleSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
