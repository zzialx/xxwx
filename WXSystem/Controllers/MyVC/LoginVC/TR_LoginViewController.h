//
//  TR_LoginViewController.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_LoginRootViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginResult)(BOOL loginSuccess);

@interface TR_LoginViewController : TR_LoginRootViewController

@property(strong, nonatomic) LoginResult loginResult;

@property(strong, nonatomic) NSString *phone;

@end

NS_ASSUME_NONNULL_END
