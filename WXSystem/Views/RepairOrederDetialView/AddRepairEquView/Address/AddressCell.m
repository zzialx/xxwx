//
//  AddressCell.m
//  ZHFJDAddressOC
//
//  Created by 张海峰 on 2019/8/24.
//  Copyright © 2019年 张海峰. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 昵称
       self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, KScreenWidth-64, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = UIColor.grayColor;
        [self addSubview:self.nameLabel];
        self.imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth-32, 16, 12, 8)];
        self.imageIcon.image  = [UIImage imageNamed:@"duihao"];
        [self.imageIcon setHidden: YES];
        [self addSubview:self.imageIcon];
    }
    
    return self;
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
