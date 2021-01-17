//
//  TR_FileTypeView.h
//  WXSystem
//
//  Created by admin on 2019/8/12.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^openOtherFile)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TR_FileTypeView : UIView

@property(copy, nonatomic)openOtherFile openOtherFile;

@end

NS_ASSUME_NONNULL_END
