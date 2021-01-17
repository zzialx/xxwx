//
//  TR_AddEquInfoCell.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddEquInfoCell.h"

@interface TR_AddEquInfoCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressBtnWidth;
@end

@implementation TR_AddEquInfoCell
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //结束编辑时调用
    BLOCK_EXEC(self.showInputText,textField.text);
}
- (IBAction)showMapAction:(id)sender {
    BLOCK_EXEC(self.showMapAddress,@"",@"");
}
- (void)showCellInfo:(NSString*)info address:(NSString*)address isShowAddressLogo:(BOOL)isShowAddressLogo{
    if ([info isEqualToString:@"设备名称"]||[info isEqualToString:@"设备编号"]) {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:info  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:THREECOLOR}];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"starNeed"];
        attch.bounds = CGRectMake(0,0, 16, 16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributedTitle insertAttributedString:string atIndex:0];
        self.infoLab.attributedText = attributedTitle;
    }else{
        self.infoLab.text = info;
    }
    if (isShowAddressLogo) {
        self.addressBtn.hidden=NO;
        self.addressBtnWidth.constant=16;
//        self.inputTF.enabled=NO;
        UIView * addressView=[[UIView alloc]initWithFrame:self.inputTF.bounds];
        [self.inputTF addSubview:addressView];
        self.inputTF.text = address;
        addressView.userInteractionEnabled=YES;
//        addressView.backgroundColor=UIColor.redColor;
        [addressView addClickEvent:self action:@selector(showAddressSelectView)];
    }else{
        self.addressBtn.hidden=YES;
        [self.inputTF.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}
- (void)showAddressSelectView{
    BLOCK_EXEC(self.showAddressView);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.addressBtn.hidden=YES;
    self.addressBtnWidth.constant=0;
    self.inputTF.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
