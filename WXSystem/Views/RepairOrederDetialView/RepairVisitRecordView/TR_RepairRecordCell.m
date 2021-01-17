//
//  TR_RepairRecordCell.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairRecordCell.h"

@interface TR_RepairRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *evaluationLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation TR_RepairRecordCell
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
- (void)setVisitModel:(TR_RepairVisitModel *)visitModel{
    _visitModel = visitModel;
    if (self.indexPath.row==0) {
        self.titleLab.text =@"客户评价";
        self.evaluationLab.text = _visitModel.evaluation;
    }if (self.indexPath.row==1) {
        self.titleLab.text =@"回访备注";
        self.evaluationLab.text = _visitModel.visitRemark;
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
