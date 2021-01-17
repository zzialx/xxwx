//
//  TR_BaseViewController.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_LoadingHUD.h"
#import "TENaviView.h"
#import "TR_NODateView.h"
#import "TR_AlertViewController.h"
#import "TR_LoginViewController.h"
#import "TR_PushMessageEngine.h"

typedef void(^collectHandle)(NSString *isCollect);

@interface TR_BaseViewController : UIViewController

@property(nonatomic,strong) TENaviView *navView;

@property(nonatomic,strong) TR_NODateView *noDataView;

@property (strong, nonatomic) TR_PushMessageEngine *pushHandleObject;    //跳转处理对象


-(TENaviView *)navView;

-(void)leftBtnClicked:(UIButton *)sender;

- (void)showLinkStateView;

- (void)userLoginAction:(LoginResult)result;

- (void)backToTheRootVC;
//查看大图
- (void)showBigPicturesWithList:(NSArray*)list index:(NSInteger)index;
//查看附件
- (void)openFileContent:(NSString*)path fileName:(NSString*)fileName;
@end
