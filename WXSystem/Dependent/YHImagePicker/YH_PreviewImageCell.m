//
//  YH_PreviewImageCell.m
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import "YH_PreviewImageCell.h"

@implementation YH_PreviewImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

@end
