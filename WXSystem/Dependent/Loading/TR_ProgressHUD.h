//
//  TR_ProgressHUD.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TR_ProgressHUD : UIView

@property (assign, nonatomic) BOOL shouldAutoMediate;

@property (assign, nonatomic) SHGProgressHUDType type;

- (void)startAnimation;

- (void)stopAnimation;

- (CGSize)SHGProgressHUDSize;

@end
