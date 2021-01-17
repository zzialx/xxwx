//
//  TR_EquipmentFailureCell.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_EquipmentFailureCell.h"

@implementation TR_EquipmentFailureCell
+ (CGFloat)getHeightCell:(NSString*)failureStr{
    return 100.0f;
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
