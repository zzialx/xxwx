//
//  TEBaseWebController.h
//  TeaExchange
//
//  Created by isaac on 2019/2/12.
//  Copyright © 2018年 isaac. All rights reserved.
//

#import "TR_BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol CYExport <JSExport>
//JSExportAs
//(onDownloadStart,
// - (void)onDownloadStart:(JSValue *)fundTypeValue fundCode:(JSValue *)fundCodeValue
// );

@end

@protocol JSObjectDelegte <JSExport>

/**
 跳转页面
 
 @param string 指定页面的字符串代表
 */
-(void)jump:(NSString *)string;


/**
 关闭当前页
 */
-(void)close;


/**
 显示导航栏
 */
-(void)showTitle;

/**
 隐藏原生导航栏
 */
-(void)hideTitle;


/**
 token失效
 */
-(void)tokenInvalid;


/**
 更新标题
 
 @param title 标题内容
 */
-(void)updateTitle:(NSString *)title;


/**
 高亮模式，标题栏为白色
 */
-(void)lightMode;


/**
 暗色模式，标题栏为红色
 */
-(void)darkMode;


/**
 在H5端发生用户信息变化事件
 */
-(void)notifyUserInfoChanged;

/**
 增加右菜单
 @param string json字符串，需解析出字典
 type 1：文字菜单，2：图片菜单
 menuUrl 菜单图片地址
menuText 菜单名
menuColor 文字菜单时的文字颜色
callback 方法名回调
 */
-(void)addRightMenu:(NSString *)string;


/**
 清除右上角按钮或者图片
 */
-(void)clearRightMenu;


/**
 选择收货地址

 @param callBack 回调方法，回调传递address的json串
 */
-(void)selectAddress:(NSString *)callBack;
@end


@interface TR_BaseWebController :TR_BaseViewController<JSObjectDelegte,UIWebViewDelegate,CYExport>
@property (nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) JSContext *jsContext;


/**
 加载h5

 @param string h5地址
 */
-(void)loadWebRequest:(NSString *)string;



@end
