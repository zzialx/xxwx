//
//  TR_ChangePhoneView.h
//  WXSystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^changePhone)(void);

@interface TR_ChangePhoneView : UIView

@property(nonatomic,copy)changePhone nextStep;

- (void)showPhone:(NSString*)phone;

@end

NS_ASSUME_NONNULL_END
