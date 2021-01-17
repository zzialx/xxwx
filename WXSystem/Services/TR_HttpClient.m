//
//  TR_HttpClient.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_HttpClient.h"
#import "TR_RequestHeadKey.h"
#import <Foundation/Foundation.h>
#import "TR_NavigationViewController.h"
#import "TR_TabBarViewController.h"
#import "TR_LoginViewController.h"

@interface TR_HttpClient()
@property (copy, nonatomic)  NSString *baseUrlString;
@property (weak, nonatomic)  UIViewController *curVisibleVC;
@property (copy, nonatomic)  AFHTTPSessionManager *session;
@property (assign, nonatomic)  BOOL isLogin;
@end

@implementation TR_HttpClient

- (void)addHeaderParameter
{
    NSDictionary *dic = [TR_RequestHeadKey fixParameter];
    for (NSString *string in [dic allKeys]) {
        [self.session.requestSerializer setValue:[dic objectForKey:string] forHTTPHeaderField:string];
    }
}

- (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"houseServer" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    return securityPolicy;
}

+(void)postRequestUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost imageKey:nil imageArray:nil withData:nil upLoadProgress:nil success:^(id requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        NSLog(@"%@",errorInfo);
        failure(errorInfo);
    }];
}

+(void)upLoadDataWithUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc]requestWithUrl:urlStr withDic:parameters requestType:RequestTypeUpLoad  imageKey:attach imageArray:nil withData:data upLoadProgress:^(float progress) {
        loadProgress(progress);
    } success:^(id requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}
+(void)upLoadImageArrayWithUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters  imageArray:(NSArray *)array upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc]requestWithUrl:urlStr withDic:parameters requestType:RequestTypeUpArrayLoad imageKey:nil imageArray:array withData:nil upLoadProgress:^(float progress) {
        loadProgress(progress);
    } success:^(id requestDic, NSString *msg) {
        success(requestDic,msg);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];
}

#pragma mark -- 网络请求统一处理
-(void)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters requestType:(RequestType)requestType imageKey:(NSString *)attach  imageArray:(NSArray *)array withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    url = [self checkHttpsPrefix:url];
    [self addHeaderParameter];
    //    [self.session setSecurityPolicy:[self customSecurityPolicy]];
    NSLog(@"requesturl:%@",url);

    //进行网络检查
      if (![TR_CommonUtil requestBeforeJudgeConnect]){
        failure(@"没有网络");
        NSLog(@"\n\n----%@------\n\n",@"没有网络");
        return;
    }
    //post请求
    if (requestType == RequestTypePost) {
        [self.session POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject success:^( id requestDic, NSString *msg) {
                success(requestDic,msg);

            } failure:^(NSString *errorInfo) {
                  failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"网络太差，操作未完成");
        }];
    }
    
    //上传
    if (requestType == RequestTypeUpLoad) {
        [self.session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [NSString stringWithFormat:@"%@.png",@(timeInterVal)];
            [formData appendPartWithFileData:data name:attach fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            loadProgress((float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject success:^(id requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"网络太差，操作未完成");
        }];
    }
    
    //多图上传
    if (requestType == RequestTypeUpArrayLoad) {
//        NSString * fileName = [NSString stringWithFormat:@"%lld.jpeg",[NSString getDateTimeTOMilliSeconds:[NSDate date]]];
        NSDictionary *dic = @{};
        [self.session POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            /**出于性能考虑,将上传图片进行压缩*/
            for (UIImage *image in array) {
                NSData * imgData = UIImageJPEGRepresentation(image, 0.5);
                //拼接data
                [formData appendPartWithFileData:imgData name:@"file" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            loadProgress((float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self dealWithResponseObject:responseObject success:^(id requestDic, NSString *msg) {
                success(requestDic,msg);
            } failure:^(NSString *errorInfo) {
                failure(errorInfo);
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(@"网络太差，操作未完成");
        }];
    }
}

#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData success:(SuccessBlock)success failure :(FailureBlock)failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
    });
        [self returnDataWithRequestData:responseData Success:^(NSDictionary *requestDic, NSString *msg) {
            success(requestDic,msg);
        } failure:^(NSString *errorInfo) {
            failure(errorInfo);
        }];
}

/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue= @"";
        if ([obj isKindOfClass:[NSString class]]) {
            finalValue  = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }if ([obj isKindOfClass:[NSArray class]]) {
            NSArray * obj_array = (NSArray*)obj;
            for (NSString * str in obj_array) {
                finalValue = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
            
        }
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        [parts addObject:part];
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",urlStr,queryString];
    return pathStr;
}

#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSDictionary *myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableLeaves error:nil];
    //判断是否为字典
    if ([myResult isKindOfClass:[NSDictionary  class]]) {
        NSDictionary *  responseDic = (NSDictionary *)myResult;
        //根据返回的接口内容来变
        NSString * code = MakeStringNotNil(responseDic[@"code"]);
        if ([code isEqualToString:@"0"]) {
            success(responseDic[@"data"],responseDic[@"message"]);
           NSLog(@"\n\n 返回数据 %@",responseDic);
        } else if ([code isEqualToString:@"401"]||[code isEqualToString:@"403"]) {
            [self getFailure];
            failure(responseDic[@"message"]);
        } else{
            failure(responseDic[@"message"]);
        }
    }
}

- (void)getFailure
{
    TR_NavigationViewController *selNav = [TR_TabBarViewController defaultTabBar].selectedNavi;
    if (!selNav) {
        return;
    }
    //已经包含登录界面？也不再弹
    for (UIViewController *vc in selNav.viewControllers) {
        if ([vc isKindOfClass:[TR_LoginViewController class]]) {
            return;
        }
    }
    //移除缓存
    [[TR_SystemInfo mainSystem]clearApplicationConfigure];
        TR_LoginViewController *loginVC = [[TR_LoginViewController alloc] initWithNibName:@"TR_LoginViewController" bundle:nil];
        TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:loginVC];
        navVC.navigationBarHidden = YES;
        __weak typeof(loginVC) weakVC = loginVC;
        loginVC.loginResult = ^(BOOL loginSuccess) {
            __strong typeof(loginVC) strongVC = weakVC;
            if (loginSuccess) {
                [strongVC.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
            }
        };
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [selNav presentViewController:navVC animated:YES completion:nil];
}

- (NSString *)checkHttpsPrefix:(NSString *)urlString
{
    //处理中文和空格问题
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.baseUrlString = API_BASE_URL_STRING;
    if (!IsStrEmpty(urlString)) {
        urlString = [API_BASE_URL_STRING stringByAppendingString:urlString];
    } else {
        urlString = API_BASE_URL_STRING;
    }
    return urlString;
}

- (AFHTTPSessionManager *)session
{
    if (IsNilOrNull(_session)) {
        _session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
        _session.requestSerializer = [AFJSONRequestSerializer serializer];
//        _session.requestSerializer = [TR_HTTPRequestSerializer serializer];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [_session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_session.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/x-www-form-urlencoded", nil]];
        _session.securityPolicy.allowInvalidCertificates = YES;
        _session.requestSerializer.timeoutInterval = 30;
        _session.requestSerializer.HTTPShouldHandleCookies = YES;
        _session.operationQueue.maxConcurrentOperationCount = 4;
    }
    return _session;
}


@end
