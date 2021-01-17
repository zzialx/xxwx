//
//  TR_AddRepairContentCell.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddRepairContentCell.h"
#import "SelwynExpandableTextView.h"
#import "SWFormCompat.h"

@interface TR_AddRepairContentCell ()<UITextViewDelegate>

@end

@implementation TR_AddRepairContentCell
- (void)updateAddEquContentItem:(NSString *)fieldString{
    NSString * placeHoldStr = @"请描述故障情况";
    self.titleLabel.text = @"故障情况";
    self.expandableTextView.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHoldStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:PLACECOLOR}];
    self.expandableTextView.attributedPlaceholder = attributedPlaceholder;
    self.expandableTextView.editable = YES;
    self.expandableTextView.keyboardType = UIKeyboardTypeDefault;
    self.expandableTextView.showsVerticalScrollIndicator = YES;
    self.expandableTextView.showsHorizontalScrollIndicator = YES;
    self.expandableTextView.userInteractionEnabled = YES;
    self.expandableTextView.scrollEnabled = YES;//滑动
    self.expandableTextView.text = fieldString;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)updateContentItem:(NSString *)fieldString section:(NSInteger)section{
    NSString * titleStr = section==0?@"服务前情况":@"服务后情况";
    NSString * placeHoldStr = section==0?@"请描述服务前设备情况":@"请描述服务后设备情况";

    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleStr  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:THREECOLOR}];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"starNeed"];
    attch.bounds = CGRectMake(0,0, 16, 16);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attributedTitle insertAttributedString:string atIndex:0];
    self.titleLabel.attributedText = attributedTitle;
    
    self.expandableTextView.textAlignment = NSTextAlignmentLeft;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeHoldStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:PLACECOLOR}];
    self.expandableTextView.attributedPlaceholder = attributedPlaceholder;
    self.expandableTextView.editable = YES;
    self.expandableTextView.keyboardType = UIKeyboardTypeDefault;
    self.expandableTextView.showsVerticalScrollIndicator = YES;
    self.expandableTextView.showsHorizontalScrollIndicator = YES;
    self.expandableTextView.userInteractionEnabled = YES;
    self.expandableTextView.scrollEnabled = YES;//滑动
    self.expandableTextView.text = fieldString;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(SW_EdgeMargin, 0, SW_SCRREN_WIDTH - 2*SW_EdgeMargin, SW_TitleHeight);
    CGFloat newHeight = 120;
    self.expandableTextView.frame = CGRectMake(2*SW_EdgeMargin, SW_TitleHeight, SW_SCRREN_WIDTH - 4*SW_EdgeMargin, newHeight - SW_EdgeMargin - SW_TitleHeight);
}

- (void)textViewDidChange:(UITextView *)textView {
    BLOCK_EXEC(self.contentBlock,textView.text,@"");
}

+ (CGFloat)heightWithItem
{
    return 130.0f;
}

@end
@implementation UITableView (TR_AddRepairContentCell)

- (TR_AddRepairContentCell *)contentProgressCellWithId:(NSString *)cellId
{
    TR_AddRepairContentCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TR_AddRepairContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.expandableTableView = self;
    }
    return cell;
}

@end
