//
//  NewsHeaderCollectionViewCell.m
//  SuiYangApp
//
//  Created by isaac on 2018/1/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NewsHeaderCollectionViewCell.h"

@implementation NewsHeaderCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lblTitle = [[UILabel alloc]init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblTitle];
        
        _lblLine = [[UILabel alloc]init];
        _lblLine.backgroundColor = [UIColor grayColor];
        _lblTitle.layer.cornerRadius = 1;
        _lblTitle.layer.masksToBounds = YES;
        [self.contentView addSubview:_lblLine];
        
        _lblTitle.sd_layout
        .leftSpaceToView(self.contentView,0)
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(self.contentView,0)
        .bottomSpaceToView(self.contentView,0);
        
        _lblLine.sd_layout
        .leftSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,0.5)
        .heightIs(2);
    }
    return self;
}
-(void)setModel:(TR_NoticeColModel *)model{
    _model = model;
    
}
@end
