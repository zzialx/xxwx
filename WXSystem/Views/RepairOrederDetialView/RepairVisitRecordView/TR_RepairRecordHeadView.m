//
//  TR_RepairRecordHeadView.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairRecordHeadView.h"

@interface TR_RepairRecordHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *degressLab;

@end


@implementation TR_RepairRecordHeadView
- (void)setVisitModel:(TR_RepairVisitModel *)visitModel{
    self.degressLab.text = visitModel.degreeStr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
