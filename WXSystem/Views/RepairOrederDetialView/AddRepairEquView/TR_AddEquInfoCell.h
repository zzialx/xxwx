//
//  TR_AddEquInfoCell.h
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^showMapAddress)(NSString * latitude,NSString * longitude);
typedef void(^showAddressView)(void);
typedef void(^showInputText)(NSString* input);
@interface TR_AddEquInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property(nonatomic,copy)showMapAddress showMapAddress;
@property(nonatomic,copy)showAddressView showAddressView;
@property(nonatomic,copy)showInputText  showInputText;
- (void)showCellInfo:(NSString*)info address:(NSString*)address isShowAddressLogo:(BOOL)isShowAddressLogo;

@end

NS_ASSUME_NONNULL_END
