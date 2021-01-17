//
//  TR_FormImageCollectionCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormImageCollectionCell.h"
#import "SWFormCompat.h"
#import "TR_FormImageModel.h"

static CGFloat const SWDeleteIconWidth = 18.0f;
static CGFloat const SWDeleteBtnWidth = 30.0f;

@interface TR_FormImageCollectionCell()
@property (nonatomic, strong) UIImageView *deleteIcon;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation TR_FormImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width;
        if (self.frame.size.width > 80) {
            width = 75.0f;
        } else {
            width = 58.0f;
        }
        self.currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, width, width)];
        self.currentImageView.clipsToBounds = YES;
        self.currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.currentImageView];
        
        self.deleteIcon = [[UIImageView alloc]initWithFrame:CGRectMake(width, 0, SWDeleteIconWidth, SWDeleteIconWidth)];
        self.deleteIcon.image = [UIImage imageNamed:SW_DeleteIcon];
        [self.contentView addSubview:self.deleteIcon];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.deleteBtn.frame = CGRectMake(self.frame.size.width - SWDeleteBtnWidth, 0,SWDeleteBtnWidth, SWDeleteBtnWidth);
        self.deleteBtn.backgroundColor = [UIColor clearColor];
        [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
    }
    return self;
}

- (void)deleteAction {
    if (self.deleteImageCompletion) {
        self.deleteImageCompletion();
    }
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.deleteBtn.hidden = !editable;
    self.deleteIcon.hidden = !editable;
}

#pragma mark -- 设置当前图片
- (void)setModel:(TR_FormImageModel *)model {
//    _image = image;
//    if ([image isKindOfClass:[UIImage class]]) {
//        self.currentImageView.image = image;
//    }
//    else if ([image isKindOfClass:[NSURL class]]) {
//        [self.currentImageView  sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:SW_PlaceholderImage]];
//    }
//    else if ([image isKindOfClass:[NSString class]]) {
        
//    }
//    else {
//        self.currentImageView.image = [UIImage imageNamed:SW_PlaceholderImage];
//    }
}

@end
