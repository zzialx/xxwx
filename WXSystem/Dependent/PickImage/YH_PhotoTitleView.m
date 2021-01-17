//
//  YH_PhotoTitleView.m
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoTitleView.h"

#pragma mark - YH_PhotoTitleView

@interface YH_PhotoTitleView()

@property (strong, nonatomic) UIButton *groupButton;

@end

@implementation YH_PhotoTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"photoDown"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"photoUp"] forState:UIControlStateSelected];
        [self.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(groupPickerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)updateGroupName:(NSString *)groupName isSelect:(BOOL)flag
{
    [self setSelected:flag];
    [self setTitle:groupName forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 可以根据实际情况修改EdgeInsets,实现左字右图
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat titleWidth = self.titleLabel.bounds.size.width;
    if (imageWidth > 0 && titleWidth > 0) {
        CGFloat margin = 2.0f;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageWidth-margin, 0, imageWidth+margin)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth+margin, 0, -titleWidth-margin)];
    }
}

- (void)groupPickerAction:(UIButton *)sender
{
    if (sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    
    BLOCK_EXEC(self.openBlock, sender.isSelected, nil);
}

@end
