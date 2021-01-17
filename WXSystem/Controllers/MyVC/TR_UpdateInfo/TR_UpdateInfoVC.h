//
//  TR_UpdateInfoVC.h
//  OASystem
//
//  Created by zzialx on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_BaseViewController.h"
#import "TR_UserModel.h"

typedef void(^backInfo)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TR_UpdateInfoVC : TR_BaseViewController

@property(nonatomic,assign) TR_PERSON_CHANGE_TYPE  type;
@property(nonatomic,strong) TR_UserModel * model;
@property(nonatomic,copy) backInfo back;

@end

NS_ASSUME_NONNULL_END
