//
//  TR_WebViewController.h
//  WXSystem
//
//  Created by zzialx on 2019/5/16.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TR_WebViewController : TR_BaseViewController
@property(nonatomic,strong)NSString * url;
@property(nonatomic, retain) JSContext *jsContext;

-(void)loadWebRequest:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
