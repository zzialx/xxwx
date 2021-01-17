//
//  YH_PhotoGroupPickerView.h
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 相册选择页面
@interface YH_PhotoGroupPickerView : UIView

@property (copy, nonatomic) ObjectBlock selectBlock;

- (void)updateWithAssetsGroupId:(NSString *)groupId;

- (void)closePickerView;

@end

@interface YH_PhotoGroupCell : UITableViewCell

- (void)updateWithAssetsGroupInfo:(NSDictionary *)groupInfo;

@end
