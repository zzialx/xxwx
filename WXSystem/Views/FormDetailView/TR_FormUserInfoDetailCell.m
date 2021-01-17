//
//  TR_FormUserInfoDetailCell.m
//  OASystem
//
//  Created by candy.chen on 2019/4/24.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormUserInfoDetailCell.h"
#import "SWFormCompat.h"
#import "SWFormItem.h"

@interface TR_FormUserInfoDetailCell ()

@property (nonatomic, strong) UIImageView *logoImage;

@end

@implementation TR_FormUserInfoDetailCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.logoImage.frame = CGRectMake(15, 15, 40, 40);
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.logoImage.frame) + 25, 0, KScreenWidth - 135, 70);
    self.contentLabel.frame = CGRectMake(KScreenWidth - 60, 25, 45, 20);
}

- (void)setItem:(SWFormItem *)item {
    _item = item;
    self.accessoryType = UITableViewCellAccessoryNone;
}


+ (CGFloat)heightWithItem:(SWFormItem *)item {
    return 70;
}
- (UIImageView *)logoImage
{
    if (IsNilOrNull(_logoImage)) {
        _logoImage = [[UIImageView alloc]init];
        _logoImage.layer.cornerRadius = 20.0f;
        _logoImage.clipsToBounds = YES;
    }
    return _logoImage;
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
