//
//  YH_PhotoFullScreenPickerCell.m
//  YH_Community
//
//  Created by candy.chen on 18/7/15.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoFullScreenPickerCell.h"

@interface YH_PhotoFullScreenPickerCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation YH_PhotoFullScreenPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.imageView.image = nil;
}

- (void)updateWithImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
