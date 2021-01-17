//
//  TR_RepairDescribeCell.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairDescribeCell.h"

@interface TR_RepairDescribeCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation TR_RepairDescribeCell
- (void)showCellTitle:(NSString*)title content:(NSString*)content{
    self.titleLab.text = title;
    self.contentLab.text = content;
    if ([content isEqualToString:@"紧急"]&&[title isEqualToString:@"紧急情况："]) {
        self.contentLab.textColor=UICOLOR_RGBA(251, 54, 63);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
