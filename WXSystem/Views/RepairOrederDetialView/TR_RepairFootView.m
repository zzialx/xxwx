//
//  TR_RepairFootView.m
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairFootView.h"

@interface TR_RepairFootView ()
@property (weak, nonatomic) IBOutlet UIButton *footBtn;
@property (weak, nonatomic) IBOutlet UIButton *leavelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leavelBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelBtnAndFootBtnDistance;
@property (weak, nonatomic) IBOutlet UIButton *addServiceProBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveBtnAndAddProBtnDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addEquBtnAndAddProBtnMuti;

@end

@implementation TR_RepairFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.footBtn.layer.cornerRadius=2.0f;
    self.footBtn.layer.masksToBounds=YES;
    self.addServiceProBtn.layer.cornerRadius=2.0f;
    self.addServiceProBtn.layer.masksToBounds=YES;
}

-(void)setDetialType:(RepairOD_Type)detialType{
    _detialType = detialType;
    switch (_detialType) {
        case RepairOD_Type_Wait_Receive:
            [self p_changeMultiplierOfConstraint:self.addEquBtnAndAddProBtnMuti multiplier:0];
            self.receiveBtnAndAddProBtnDis.constant=0;
            break;
        case RepairOD_Type_Wait_Service:
            self.footBtn.backgroundColor = UICOLOR_RGBA(34, 197, 107);
            [self.footBtn setTitle:@"开始服务" forState:UIControlStateNormal];
            [self p_changeMultiplierOfConstraint:self.addEquBtnAndAddProBtnMuti multiplier:0];
            self.receiveBtnAndAddProBtnDis.constant=0;
            break;
        case RepairOD_Type_Wait_Visit:
            self.leavelBtnWidth.constant = 0;
            self.levelBtnAndFootBtnDistance.constant=0;
            [self.footBtn setTitle:@"留言" forState:UIControlStateNormal];
            [self p_changeMultiplierOfConstraint:self.addEquBtnAndAddProBtnMuti multiplier:0];
            self.receiveBtnAndAddProBtnDis.constant=0;
            break;
        case RepairOD_Type_Cancle:
            self.leavelBtnWidth.constant = 0;
            self.levelBtnAndFootBtnDistance.constant=0;
            self.leavelBtn.clipsToBounds=YES;
            self.footBtn.backgroundColor=UICOLOR_RGBA(215, 54, 63);
            [self.footBtn setTitle:@"查看取消原因" forState:UIControlStateNormal];
            [self p_changeMultiplierOfConstraint:self.addEquBtnAndAddProBtnMuti multiplier:0];
            self.receiveBtnAndAddProBtnDis.constant=0;
            break;
        case RepairOD_Type_Finish:
            
            break;
        case RepairOD_Type_In_Service:
            [self p_changeMultiplierOfConstraint:self.addEquBtnAndAddProBtnMuti multiplier:1];
            self.receiveBtnAndAddProBtnDis.constant=11;
            [self.footBtn setTitle:@"补充设备信息" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
#pragma mark----动态修改Multiplier
- (void)p_changeMultiplierOfConstraint:(NSLayoutConstraint *)constraint multiplier:(CGFloat)multiplier {
    if(constraint==nil)return;
    [NSLayoutConstraint deactivateConstraints:@[constraint]];
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:constraint.firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:constraint.secondItem attribute:constraint.secondAttribute multiplier:multiplier constant:constraint.constant];
    newConstraint.priority = constraint.priority;
    newConstraint.shouldBeArchived = constraint.shouldBeArchived;
    newConstraint.identifier = constraint.identifier;
    [NSLayoutConstraint activateConstraints:@[newConstraint]];
}
- (IBAction)leavelMsgAction:(UIButton *)sender {
    BLOCK_EXEC(self.footAction,Repair_Foot_Type_Leavel);
}
- (IBAction)acceptRepairAction:(UIButton *)sender {
    switch (_detialType) {
        case RepairOD_Type_Wait_Receive:
            BLOCK_EXEC(self.footAction,Repair_Foot_Type_Recive);
            break;
        case RepairOD_Type_Wait_Service:
            BLOCK_EXEC(self.footAction,Repair_Foot_Type_Start);
            break;
        case RepairOD_Type_Wait_Visit:
            BLOCK_EXEC(self.footAction,Repair_Foot_Type_Leavel);
            break;
        case RepairOD_Type_Cancle:
            BLOCK_EXEC(self.footAction,Repair_Foot_Type_Cancle);
            break;
        case RepairOD_Type_Finish:
            break;
        case RepairOD_Type_In_Service:
            BLOCK_EXEC(self.footAction,Repair_Foot_Type_Equ);
            break;
        default:
            break;
    }
   
}
//添加服务进度
- (IBAction)addProgressAction:(id)sender {
    BLOCK_EXEC(self.footAction,Repair_Foot_Type_Pro);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
