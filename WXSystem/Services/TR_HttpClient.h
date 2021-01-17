//
//  TR_HttpClient.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <YYCache/YYCache.h>
@interface TR_HttpClient : NSObject

typedef void (^SuccessBlock)(id requestDic, NSString * msg);
typedef void (^FailureBlock)(NSString *errorInfo);
typedef void (^loadProgress)(float progress);

/**
 *  Post请求 不对数据进行缓存
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)postRequestUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;

/**
 *  上传单个文件
 *
 *  @param urlStr       服务器地址
 *  @param parameters   参数
 *  @param attach       上传的key
 *  @param data         上传的问价
 *  @param loadProgress 上传的进度
 *  @param success      成功的回调
 *  @param failure      失败的回调
 */
+(void)upLoadDataWithUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  上传多个文件
 *
 *  @param urlStr       服务器地址
 *  @param parameters   参数
 *  @param array        上传的图片数组
 *  @param loadProgress 上传的进度
 *  @param success      成功的回调
 *  @param failure      失败的回调
 */
+(void)upLoadImageArrayWithUrlString:(NSString *)urlStr withDic:(NSDictionary *)parameters  imageArray:(NSArray *)array upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
