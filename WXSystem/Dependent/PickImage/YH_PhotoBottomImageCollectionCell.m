//
//  YH_PhotoBottomImageCollectionCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/23.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "YH_PhotoBottomImageCollectionCell.h"

@interface YH_PhotoBottomImageCollectionCell()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImageView *backImageView;
@end

@implementation YH_PhotoBottomImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.backImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

- (void)updateWithImage:(UIImage *)image isSelect:(BOOL)isSelect
{
    self.imageView.image = image;
    if (isSelect) {
        self.backImageView.hidden = NO;
    } else {
       self.backImageView.hidden = YES;
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.backgroundColor = [UIColor clearColor];
        _backImageView.image = [UIImage imageNamed:@"backSelect"];
    }
    return _backImageView;
}

@end
