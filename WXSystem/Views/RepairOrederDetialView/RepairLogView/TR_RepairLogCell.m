//
//  TR_RepairLogCell.m
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairLogCell.h"

@interface TR_RepairLogCell ()
@property (weak, nonatomic) IBOutlet UIImageView *circleLogo;
@property (weak, nonatomic) IBOutlet UILabel *logName;
@property (weak, nonatomic) IBOutlet UILabel *logContentLab;
@property (weak, nonatomic) IBOutlet UILabel *logTimeLab;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end


@implementation TR_RepairLogCell
- (void)showRepairlogCellWithData:(TR_LogModel*)logModel  isFirstRow:(BOOL)isFirstRow isLastRow:(BOOL)isLastRow index:(NSInteger)index{
    self.topLine.hidden=NO;
    self.bottomLine.hidden=NO;
    if (isFirstRow) {
        self.topLine.hidden=YES;
    }if (isLastRow) {
        self.bottomLine.hidden=YES;
    }
    if (index==0) {
        self.circleLogo.image=[UIImage imageNamed:@"circle_select"];
    }
    self.logName.text = logModel.logTypeName;
    self.logTimeLab.text = logModel.logTime;
    self.logContentLab.text = logModel.logInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
