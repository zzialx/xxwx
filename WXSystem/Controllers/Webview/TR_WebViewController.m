//
//  TR_WebViewController.m
//  WXSystem
//
//  Created by zzialx on 2019/5/16.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_WebViewController.h"

@interface TR_WebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic,strong)WKWebView * webView;
@property (nonatomic, strong) UIButton *closeItem;

@end

@implementation TR_WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navView.leftImg.hidden = NO;
    self.navView.lblLeft.hidden = NO;
    self.closeItem.frame = CGRectMake(65, self.navView.frame.size.height - 43, 40, 40);
    [self.navView addSubview:self.closeItem];
    [self.view addSubview:self.webView];

}
-(void)loadWebRequest:(NSString *)string{
    self.url = string;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
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

- (void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//关闭H5页面，直接回到原生页面
- (void)closeNative{
    [self.navigationController popViewControllerAnimated:YES];
}
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
- (WKWebView *)webView{
    
    if(_webView == nil){
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        if (@available(iOS 9.0, *)) {
            config.requiresUserActionForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        //设置是否允许画中画技术 在特定设备上有效
        if (@available(iOS 9.0, *)) {
            config.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        if (@available(iOS 9.0, *)) {
            config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        } else {
            // Fallback on earlier versions
        }
         //应用于 ajax 请求的 cookie 设置
        WKUserContentController *userContentController = WKUserContentController.new;
        NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'userToken=%@';",[GVUserDefaults standardUserDefaults].token];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        config.userContentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight-KNAV_HEIGHT) configuration:config];
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
//        WKBackForwardList * backForwardList = [_webView backForwardList];
       
    }
    return _webView;
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[TR_LoadingHUD sharedHud] showInView:self.view];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"加载失败");
    [[TR_LoadingHUD sharedHud] dismissInView:self.view];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[TR_LoadingHUD sharedHud] dismissInView:self.view];
//    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSLog(@"%@",self.jsContext);
//    self.jsContext[@"helper"] = self;
//    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
//        NSLog(@"异常信息：%@", exceptionValue);
//        NSLog(@"context      %@",context);
//
//    };
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[TR_LoadingHUD sharedHud] dismissInView:self.view];
}
// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
}
// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//
//    NSString * urlStr = navigationAction.request.URL.absoluteString;
//    NSLog(@"发送跳转请求：%@",urlStr);
//    //自己定义的协议头
//    NSString *htmlHeadString = @"github://";
//    if([urlStr hasPrefix:htmlHeadString]){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通过截取URL调用OC" message:@"你想前往我的Github主页?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }])];
//        [alertController addAction:([UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL * url = [NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@"github://callName_?" withString:@""]];
//            [[UIApplication sharedApplication] openURL:url];
//        }])];
//        [self presentViewController:alertController animated:YES completion:nil];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSString * urlStr = navigationResponse.response.URL.absoluteString;
//    NSLog(@"当前跳转地址：%@",urlStr);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//}
//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount ==0) {
            NSURLCredential*credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }else{
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
    }
}
//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
}


@end
