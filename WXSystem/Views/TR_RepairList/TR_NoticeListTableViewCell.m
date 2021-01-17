//
//  TR_NoticeListTableViewCell.m
//  WXSystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_NoticeListTableViewCell.h"

@implementation TR_NoticeListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        _lblType = [[UILabel alloc]init];
        _lblType.font = [UIFont systemFontOfSize:11];
        _lblType.textColor = UICOLOR_RGBA(76, 159, 255);
        _lblType.backgroundColor = [UIColor tr_colorwithHexString:@"#EFF7FF"];
        _lblType.textAlignment = NSTextAlignmentCenter;
        _lblType.text = @"人事通告";
        _lblType.layer.borderWidth = 0.5;
        _lblType.layer.borderColor = BLUECOLOR.CGColor;
        _lblType.layer.cornerRadius = 2;
        _lblType.layer.masksToBounds = YES;
        [self.contentView addSubview:_lblType];
        
        _lblTitle = [[UILabel alloc]init];
        _lblTitle.font = [UIFont systemFontOfSize:17];
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
        .topSpaceToView(self.contentView, 20)
        .heightIs(20)
        .widthIs(60);
        
        _lblTitle.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 20)
        .autoHeightRatio(0)
        .minHeightIs(20);
        
        _lblDepartment.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10)
        .heightIs(20);
        
        [_lblDepartment setSingleLineAutoResizeWithMaxWidth:150];
        
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

@end
