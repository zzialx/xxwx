//
//  TR_NoticeListCollectionViewCell.h
//  OASystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_NoticeListCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL haveLoad;
-(void)loadWithColCode:(NSString *)colCode;
@end

NS_ASSUME_NONNULL_END
