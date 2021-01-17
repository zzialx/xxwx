//
//  CustomShareCollectionViewCell.m
//  SuiYangApp
//
//  Created by isaac on 2017/12/22.
//  Copyright © 2017年 zzialx. All rights reserved.
//

#import "CustomShareCollectionViewCell.h"

@implementation CustomShareCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageTitle = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageTitle];
        
        _lblTitle = [[UILabel alloc]init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lblTitle];
        
        _imageTitle.sd_layout.centerXEqualToView(self.contentView)
        .topSpaceToView(self.contentView,10)
        .widthIs(40)
        .heightIs(40);
        
        _lblTitle.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(_imageTitle,10)
        .heightIs(30);
    }
    return self;
}
@end
