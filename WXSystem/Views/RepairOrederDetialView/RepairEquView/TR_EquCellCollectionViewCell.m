//
//  TR_SearchCollectionViewCell.m
//  TeaCity
//
//  Created by admin on 2019/1/4.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_EquCellCollectionViewCell.h"

@interface TR_EquCellCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *teaNameLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation TR_EquCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.teaNameLab.layer.borderColor=UICOLOR_RGBA(24, 144, 255).CGColor;
    self.teaNameLab.layer.borderWidth=1.0;
}
- (void)showTeaName:(NSString*)name index:(NSInteger)index{
    self.teaNameLab.text = name;
}
@end
