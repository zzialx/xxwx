//
//  TR_LoginRootViewController.h
//  WXSystem
//
//  Created by candy.chen on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_MyViewModel.h"
#import "NSString+SHA256.h"

NS_ASSUME_NONNULL_BEGIN

@interface TR_LoginRootViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) TR_MyViewModel *myModel;

@property (strong, nonatomic) TENaviView *navView;

- (BOOL)checkPassword:(NSString *) password;

@end

NS_ASSUME_NONNULL_END
