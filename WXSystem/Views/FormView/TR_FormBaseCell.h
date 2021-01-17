//
//  TR_FormBaseCell.h
//  WXSystem
//
//  Created by candy.chen on 2019/4/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelwynExpandableTextView;

NS_ASSUME_NONNULL_BEGIN

@interface TR_FormBaseCell : UITableViewCell

@property (nonatomic, strong) SelwynExpandableTextView *expandableTextView;

@property (strong, nonatomic) UITextField *singleTextField;
/**
 表单标题
 */
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) UIView *lineView;

/**
 表单条目所在的tableView
 */
@property (nonatomic, weak) UITableView *expandableTableView;

@end


NS_ASSUME_NONNULL_END
