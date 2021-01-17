//
//  TR_ResetViewController.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_LoginRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_ResetViewController : TR_LoginRootViewController

- (void)resetPhone:(NSString *)phone code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
