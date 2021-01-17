//
//  TEBaseWebController.m
//  TeaExchange
//
//  Created by isaac on 2019/2/12.
//  Copyright © 2018年 isaac. All rights reserved.
//

#import "TR_BaseWebController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TR_BaseWebController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *dicData;
    BOOL authed;
    NSURL *authedurl;
    NSURLRequest *originRequest;
}

//关闭按钮
@property (nonatomic, strong) UIButton *closeItem;

@end

@implementation TR_BaseWebController

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.frame = CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight-KNAV_HEIGHT);
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = KSYS_BGCOLOR;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.leftImg.hidden = NO;
    self.navView.lblLeft.hidden = NO;
    self.closeItem.frame = CGRectMake(65, self.navView.frame.size.height - 43, 40, 40);
    [self.navView addSubview:self.closeItem];
}

-(void)leftBtnClicked:(UIButton *)sender{
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
    } else {
        [self closeNative];
    }
}

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --加载h5
-(void)loadWebRequest:(NSString *)string{
    [self setCookie];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",string]];
    authedurl = url;
    NSLog(@"%@",[NSString stringWithFormat:@"%@",string]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"fffffff");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[TR_LoadingHUD sharedHud] dismissInView:self.view];
    //h5页面触发原生界面方法
    //self.navView.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"%@",self.jsContext);
    self.jsContext[@"helper"] = self;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
        NSLog(@"context      %@",context);
        
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [[TR_LoadingHUD sharedHud] dismissInView:self.view];
}
#pragma mark --塞cookie
-(void)setCookie{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        if ([cookie.name isEqualToString:@"DEVICEID"] || [cookie.name isEqualToString:@"userToken"] || [cookie.name isEqualToString:@"userId"]) {
            [cookieStorage deleteCookie:cookie];
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/",WEB_URL]];
    
    NSMutableDictionary *deviceProperties = [NSMutableDictionary dictionary];
    deviceProperties[NSHTTPCookieName] = @"DEVICEID";
    //deviceProperties[NSHTTPCookieValue] = [Utils UUID];
    deviceProperties[NSHTTPCookieDomain] = url.host;
    deviceProperties[NSHTTPCookiePath] = url.path;
    deviceProperties[NSHTTPCookieExpires] = [NSDate distantFuture];
    NSHTTPCookie *deviceCookie = [NSHTTPCookie cookieWithProperties:deviceProperties];
    [cookieStorage setCookie:deviceCookie];
    
    NSMutableDictionary *userTokenProperties = [NSMutableDictionary dictionary];
    userTokenProperties[NSHTTPCookieName] = @"userToken";
    userTokenProperties[NSHTTPCookieValue] = [GVUserDefaults standardUserDefaults].token;
    userTokenProperties[NSHTTPCookieDomain] = url.host;
    userTokenProperties[NSHTTPCookiePath] = url.path;
    userTokenProperties[NSHTTPCookieExpires] = [NSDate distantFuture];
    NSHTTPCookie *userTokenCookie = [NSHTTPCookie cookieWithProperties:userTokenProperties];
    [cookieStorage setCookie:userTokenCookie];
    
    NSMutableDictionary *userIdTokenProperties = [NSMutableDictionary dictionary];
    userIdTokenProperties[NSHTTPCookieName] = @"userId";
   // userIdTokenProperties[NSHTTPCookieValue] = [[User mainUser] userInfo].userId;
    userIdTokenProperties[NSHTTPCookieDomain] = url.host;
    userIdTokenProperties[NSHTTPCookiePath] = url.path;
    userIdTokenProperties[NSHTTPCookieExpires] = [NSDate distantFuture];
    NSHTTPCookie *userIdTokenCookie = [NSHTTPCookie cookieWithProperties:userIdTokenProperties];
    [cookieStorage setCookie:userIdTokenCookie];
}

#pragma mark --跳转到指定页面
-(void)jump:(NSString *)string{
//      __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([string isEqualToString:@"teaShop://msg"]) {//跳转到消息中心页面
//
//        }else if ([string isEqualToString:@"teaShop://home?id=1"]){//跳转到主页
//            weakSelf.tabBarController.selectedIndex = 0;
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else if ([string isEqualToString:@"teaShop://search"]){//跳转到搜索
//            TESearchController *search = [[TESearchController alloc]init];
//            [weakSelf.navigationController pushViewController:search animated:YES];
//        }else if ([string isEqualToString:@"teaShop://report"]){//跳转到意见反馈
//            FeedbackViewController *feedback = [[FeedbackViewController alloc]init];
//            [weakSelf.navigationController pushViewController:feedback animated:YES];
//        }else if ([string isEqualToString:@"teaStore://logout"]){//登出
//            [weakSelf loginOut];
//        }else if ([string containsString:@"teaShop://foot"]){//跳转到足迹
//            MyFootprintVC *foot = [[MyFootprintVC alloc]init];
//            [weakSelf.navigationController pushViewController:foot animated:YES];
//        }else if ([string containsString:@"teaShop://personalInfo"]){//上传头像（跳转至个人信息页）
//            ShopInfoVC *shopInfo = [[ShopInfoVC alloc]init];
//            [weakSelf.navigationController pushViewController:shopInfo animated:YES];
//        }else if ([string containsString:@"teaShop://updateName"]){//设置用户名（跳转至设置昵称页面）
//            ShopInfoVC *shopInfo = [[ShopInfoVC alloc]init];
//            [weakSelf.navigationController pushViewController:shopInfo animated:YES];
//        }else if ([string containsString:@"teaShop://personalInfo"]){//设置性别（跳转至个人信息页）
//            ShopInfoVC *shopInfo = [[ShopInfoVC alloc]init];
//            [weakSelf.navigationController pushViewController:shopInfo animated:YES];
//        }else if ([string containsString:@"teaShop://safe"]){//实名认证（跳转至账户安全信息页）
//            RealNameCertifyController *realName = [[RealNameCertifyController alloc]init];
//            [weakSelf.navigationController pushViewController:realName animated:YES];
//        }
//    });
}
#pragma mark --关闭当前页面
-(void)close{
     __weak typeof(self) weakSelf = self;
 dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark -- 显示导航栏
-(void)showTitle{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.navView.hidden = NO;
        weakSelf.webView.frame = CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight-KNAV_HEIGHT);
    });
   
}
#pragma mark --隐藏原生导航栏
-(void)hideTitle{
    self.navView.hidden = YES;
    self.webView.frame = CGRectMake(0,-KNAV_STATUS_HEIGHT, KScreenWidth, KScreenHeight+KNAV_STATUS_HEIGHT);
}
#pragma mark --  在H5端发生用户信息变化事件
-(void)notifyUserInfoChanged{
    
}
#pragma mark --token失效,跳转到登录页面
-(void)tokenInvalid{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"重新登录" message:@"token失效，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self loginOut];
}
#pragma mark --登出
-(void)loginOut{
}
#pragma mark -- 更新标题
-(void)updateTitle:(NSString *)title{
    self.navView.titleLabel.text = title;
}

#pragma mark --高亮模式，标题栏为白色
-(void)lightMode{
    self.navView.leftImg.image = [UIImage imageNamed:BACK_GRAY];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.titleLabel.textColor = [UIColor blackColor];
}
#pragma mark --暗色模式，标题栏为红色
-(void)darkMode{
    self.navView.leftImg.image = [UIImage imageNamed:BACK_WHITE];
    self.navView.backgroundColor = KNAV_BGCOLOR;
    self.navView.titleLabel.textColor = [UIColor whiteColor];
}
#pragma mark --增加右菜单
-(void)addRightMenu:(NSString *)string{
//
//    NSDictionary *dic = [Utils dictionaryWithJsonString:[Utils getStringEmptyOrNot:string]];
//    dicData = [[NSMutableDictionary alloc]initWithDictionary:dic];
//    NSLog(@"%@",dic);
//    if ([[Utils getStringEmptyOrNot:dic[@"type"]] integerValue] == 1) {
//        self.navView.rightImg.hidden = YES;
//        self.navView.rightBtn.hidden = NO;
//        [self.navView.rightBtn setTitle:[Utils getStringEmptyOrNot:dic[@"menuTxt"]] forState:UIControlStateNormal];
//        [self.navView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.navView.rightBtn addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
//        [self.navView.rightBtn setTitleColor:[Utils tr_colorwithHexString:dic[@"menuColor"] alpha:1.0] forState:UIControlStateNormal];
//    }else if ([[Utils getStringEmptyOrNot:dic[@"type"]] integerValue] == 2){
//        self.navView.rightImg.hidden = NO;
//        self.navView.rightBtn.hidden = YES;
//        [self.navView.rightImg sd_setImageWithURL:[NSURL URLWithString:[Utils getStringEmptyOrNot:dic[@"menuUrl"]]] placeholderImage:[UIImage imageNamed:@"placeImage-2"]];
//        [Utils addClickEvent:self action:@selector(callBack) owner:self.navView.rightImg];
//    }
}
#pragma mark -- 清除右上角按钮或者图片
-(void)clearRightMenu{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.navView.rightImg.hidden = YES;
        weakSelf.navView.rightBtn.hidden = YES;
    });
}
#pragma mark --点击原生按钮，触发h5方法
-(void)callBack{
    JSValue *jsValue = [self.jsContext evaluateScript:dicData[@"callBack"]];
    [jsValue callWithArguments:@[dicData[@"callBack"]]];
}
#pragma mark --传递地址的json串
-(void)selectAddress:(NSString *)callBack{
   
//    NSLog(@"%@",callBack);
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        TEAddressListController *addressList = [[TEAddressListController alloc]init];
//        addressList.selectAddress = ^(AddressListModel *address) {
//            NSDictionary *dic = @{
//                                  @"userId":address.userId,
//                                  @"cityId":address.cityId,
//                                  @"provinceId":address.provinceId,
//                                  @"addressId":address.addressId,
//                                  @"area":address.area,
//                                  @"areaId":address.areaId,
//                                  @"addr":address.addr,
//                                  @"zip":address.zip,
//                                  @"telephone":address.telephone,
//                                  @"name":address.name,
//                                  @"nowAddress":address.nowAddress
//                                  };
//            NSString *jsonString = [Utils dictionaryToJson:dic];
//            NSString *test = [NSString stringWithFormat:@"%@(%@)",callBack,jsonString];
//            NSLog(@"%@-----%@",jsonString,test);
//            JSValue *jsValue = [weakSelf.jsContext evaluateScript:test];
//            [jsValue callWithArguments:@[test]];
//        };
//
//        [weakSelf.navigationController pushViewController:addressList animated:YES];
//    });
 
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
//    NSString* scheme = [[request URL] scheme];
//    NSLog(@"scheme = %@ --url = %@",scheme,[request URL]);
//    if ([scheme isEqualToString:@"https"]) {
//        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
//        if (!authed) {
//            originRequest = request;
//            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [conn start];
//            [webView stopLoading];
//            return NO;
//        }
//    }

    [[TR_LoadingHUD sharedHud] showInView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"%@",str);
    return YES;
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//
//    if ([challenge previousFailureCount]== 0) {
//        authed = YES;
//        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
//        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
//    }
//}
//
//
//# pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>
//
//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
//{
//
//    NSLog(@"%@",request);
//    return request;
//
//}
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//
//    authed = YES;
//    //webview 重新加载请求。
//    [self.webView loadRequest:originRequest];
//    [connection cancel];
//}
//

- (UIButton *)closeItem
{
    if (!_closeItem) {
        _closeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeItem setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeItem setTitleColor:THREECOLOR forState:UIControlStateNormal];
        [_closeItem.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_closeItem addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
        _closeItem.backgroundColor = [UIColor clearColor];
    }
    return _closeItem;
}

@end
