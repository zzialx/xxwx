//
//  TR_NoticeListTableViewCell.m
//  OASystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_NoticeListTableViewCell.h"

@implementation TR_NoticeListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lblType = [[UILabel alloc]init];
        _lblType.font = [UIFont systemFontOfSize:11];
        _lblType.textColor = UICOLOR_RGBA(76, 159, 255);
        _lblType.backgroundColor = UICOLOR_RGBA(237, 237, 237);
        _lblType.textAlignment = NSTextAlignmentCenter;
        _lblType.text = @"人事通告";
        _lblType.layer.borderWidth = 0.5;
        _lblType.layer.borderColor = UICOLOR_RGBA(76, 159, 25513).CGColor;
        _lblType.layer.cornerRadius = 2;
        _lblType.layer.masksToBounds = YES;
        [self.contentView addSubview:_lblType];
        
        _lblTitle = [[UILabel alloc]init];
        _lblTitle.font = [UIFont boldSystemFontOfSize:17];
        _lblTitle.numberOfLines = 0;
        _lblTitle.text = @"        新立讯会议培训通知";
        [self.contentView addSubview:_lblTitle];
        
        _lblDepartment = [[UILabel alloc]init];
        _lblDepartment.text = @"行政部";
        _lblDepartment.font = [UIFont systemFontOfSize:13];
        _lblDepartment.textColor = [UIColor grayColor];
        [self.contentView addSubview:_lblDepartment];
        
        _lblTime = [[UILabel alloc]init];
        _lblTime.font = [UIFont systemFontOfSize:13];
        _lblTime.textColor = UICOLOR_RGBA(153, 153, 153);
        [self.contentView addSubview:_lblTime];
        
        UILabel *lblLine = [[UILabel alloc]init];
        lblLine.backgroundColor = UICOLOR_RGBA(163, 163, 163);
        [self.contentView addSubview:lblLine];
        
        _lblType.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .heightIs(15)
        .heightIs(80);
        
        _lblTitle.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .heightIs(40);
        
        _lblDepartment.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10)
        .heightIs(20)
        .autoWidthRatio(0);
        
        lblLine.sd_layout
        .leftSpaceToView(_lblDepartment, 5)
        .bottomSpaceToView(self.contentView, 15)
        .widthIs(0.5)
        .heightIs(10);
        
        _lblTime.sd_layout
        .leftSpaceToView(lblLine, 5)
        .rightSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10)
        .heightIs(20);
        
    }
    return self;
}
-(void)setModel:(TR_NoticeListModel *)model{
    _model = model;
    _lblType.text = model.typeName;
    _lblTitle.text = model.title;
    _lblDepartment.text = model.publisher;
    _lblTime.text = model.createTime;
}
@end
