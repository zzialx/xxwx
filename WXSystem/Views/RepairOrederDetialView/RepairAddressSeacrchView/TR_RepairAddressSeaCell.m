//
//  TR_RepairAddressSeaCell.m
//  WXSystem
//
//  Created by admin on 2019/11/20.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairAddressSeaCell.h"

@interface TR_RepairAddressSeaCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

@implementation TR_RepairAddressSeaCell
- (void)showCellName:(NSString *)name address:(NSString*)address{
    self.nameLab.text=name;
    self.addressLab.text = address;
    self.selectImg.hidden=YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.selectImg.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
