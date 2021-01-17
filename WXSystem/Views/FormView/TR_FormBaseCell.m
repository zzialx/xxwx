//
//  TR_FormBaseCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormBaseCell.h"
#import "SelwynExpandableTextView.h"
#import "SWFormCompat.h"

@interface TR_FormBaseCell()<UITextViewDelegate>
@end

@implementation TR_FormBaseCell

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:SW_TitleFont];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = THREECOLOR;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)lineView
{
    if (IsNilOrNull(_lineView)) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = TABLECOLOR;
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (SelwynExpandableTextView *)expandableTextView {
    if (!_expandableTextView) {
        _expandableTextView = [[SelwynExpandableTextView alloc]init];
        _expandableTextView.delegate = self;
        _expandableTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _expandableTextView.textContainer.lineFragmentPadding = 0;
        _expandableTextView.textAlignment = NSTextAlignmentRight;
        _expandableTextView.backgroundColor = [UIColor whiteColor];
        _expandableTextView.font = [UIFont systemFontOfSize:SW_InfoFont];
        _expandableTextView.scrollEnabled = NO;
        _expandableTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _expandableTextView.layoutManager.allowsNonContiguousLayout = NO;
        _expandableTextView.showsVerticalScrollIndicator = NO;
        _expandableTextView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_expandableTextView];
    }
    return _expandableTextView;
}

- (UITextField *)singleTextField {
    if (!_singleTextField) {
        _singleTextField = [[UITextField alloc]init];
        [self.contentView addSubview:_singleTextField];
        _singleTextField.textAlignment = NSTextAlignmentRight;
        _singleTextField.keyboardType = UIKeyboardTypeDefault;
        _singleTextField.font = [UIFont systemFontOfSize:SW_InfoFont];
        _singleTextField.backgroundColor = [UIColor whiteColor];
        NSString *holderText = @"请输入";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:PLACECOLOR
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:SW_InfoFont]
                            range:NSMakeRange(0, holderText.length)];
        _singleTextField.attributedPlaceholder = placeholder;
    }
    return _singleTextField;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
