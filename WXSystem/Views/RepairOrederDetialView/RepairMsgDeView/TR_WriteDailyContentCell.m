//
//  TR_WriteDailyContentCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/10/23.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_WriteDailyContentCell.h"
#import "SelwynExpandableTextView.h"
#import "SWFormCompat.h"

@interface TR_WriteDailyContentCell () <UITextViewDelegate>

@end

@implementation TR_WriteDailyContentCell

- (void)updateContentItem:(NSString *)fieldString {
      self.expandableTextView.textAlignment = NSTextAlignmentLeft;
      NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入工单留言最多500字" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:PLACECOLOR}];
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
    CGFloat newHeight = 290;
    self.expandableTextView.frame = CGRectMake(2*SW_EdgeMargin, 15, SW_SCRREN_WIDTH - 4*SW_EdgeMargin, newHeight - SW_EdgeMargin -15);
}

- (void)textViewDidChange:(UITextView *)textView {
    BLOCK_EXEC(self.contentBlock,textView.text,@"");
}

+ (CGFloat)heightWithItem
{
    return 290.0f;
}

@end
@implementation UITableView (TR_WriteDailyContentCell)

- (TR_WriteDailyContentCell *)contentCellWithId:(NSString *)cellId
{
    TR_WriteDailyContentCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TR_WriteDailyContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.expandableTableView = self;
    }
    return cell;
}

@end
