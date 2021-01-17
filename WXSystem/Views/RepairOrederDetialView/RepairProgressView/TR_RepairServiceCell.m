//
//  TR_RepairServiceCell.m
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairServiceCell.h"

@interface TR_RepairServiceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation TR_RepairServiceCell

+ (CGFloat)getCellHeight:(NSString*)address{
    CGFloat cellHeight = 98.0;
    CGFloat opinionH =  [address yh_heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:(KScreenWidth-51.5-32)];
    cellHeight+=opinionH;
    return cellHeight;
}

- (void)showCellSectionIndex:(NSInteger)sectionIndex serviceModel:(TR_ServicePgrDetialModel*)serviceModel{
    if (sectionIndex==0) {
        self.bottomLine.hidden=NO;
        self.topLine.hidden=YES;
        self.titleName.text=@"开始服务";
        self.timeLab.text = serviceModel.startTime;
        self.addressLab.text=serviceModel.startAddr;
        if (serviceModel.beforePicUrls.count==0) {
            self.bottomLine.hidden=YES;
        }
    }if (sectionIndex==3) {
        self.bottomLine.hidden=YES;
        self.topLine.hidden=NO;
        self.titleName.text=@"服务完成";
        self.timeLab.text = serviceModel.endTime;
        self.addressLab.text=serviceModel.endAddr;
    }
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
