//
//  TR_ChangeNameCell.m
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ChangeNameCell.h"

@interface TR_ChangeNameCell ()<UITextFieldDelegate>

@end

@implementation TR_ChangeNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.inputTF.delegate=self;

}

- (void)showCellName:(NSString*)name placeHold:(NSString*)placeHold{
    if([name isEqualToString:@"手机号"]){
        self.inputTF.placeholder = placeHold;
        self.inputTF.keyboardType=UIKeyboardTypePhonePad;
        [self.inputTF becomeFirstResponder];
        return;
    }
    if (name.length==0) {
        self.inputTF.placeholder = placeHold;
    }else{
        self.inputTF.text = name;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
