//
//  TR_ProtocolWebViewController.m
//  HouseProperty
//
//  Created by candy.chen on 2019/2/23.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_ProtocolWebViewController.h"
#import "TR_FileTypeView.h"
 
@interface TR_ProtocolWebViewController ()<CYExport,UIWebViewDelegate,UIDocumentInteractionControllerDelegate,WKUIDelegate, UINavigationBarDelegate>

@property (copy, nonatomic) NSString *webUrl;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong)TR_FileTypeView * otherFileView;
@end

@implementation TR_ProtocolWebViewController

- (instancetype)initWithProtocolType:(NSString *)url
{
    self = [super init];
    if (self) {
        self.webUrl = url;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:self.fileName.length>0?self.fileName:@"文件"];
    [self loadWebRequest:self.webUrl];
    if (self.status) {
        self.status();
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [[TR_LoadingHUD sharedHud] dismissInView:self.view];
}
- (void)findOtherApp{
    _documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:[NSURL fileURLWithPath:self.webUrl]];
    [_documentInteractionController setDelegate:self];
    
    BOOL canOpen = [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    if (canOpen == NO) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"没有找到可以打开该文件的应用" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:alertA];
        alertC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertC animated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (TR_FileTypeView*)otherFileView{
    if (IsNilOrNull(_otherFileView)) {
        _otherFileView =(TR_FileTypeView*) [[[NSBundle mainBundle]loadNibNamed:@"TR_FileTypeView" owner:self options:nil]lastObject];
        [self.view addSubview:_otherFileView];
        [_otherFileView bringSubviewToFront:self.view];
        _otherFileView.hidden = YES;
        _otherFileView.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(168)
        .centerYEqualToView(self.view);
        WS(weakSelf);
        _otherFileView.openOtherFile = ^{
            [weakSelf findOtherApp];
        };
    }
    return _otherFileView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadDocxWithDocPath:(NSString *)docPath fileName:(NSString *)fileName {
    //    [MBProgressHUD showMessage:@"正在下载文件" toView:self.view];
    NSString *urlString = @"http://66.6.66.111:8888/UploadFile/";
    
    urlString = [urlString stringByAppendingString:fileName];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld   %lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [docPath stringByAppendingPathComponent:fileName];
        NSLog(@"文件路径＝＝＝%@",path);
        return [NSURL fileURLWithPath:path];//这里返回的是文件下载到哪里的路径 要注意的是必须是携带协议file://
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [MBProgressHUD showHUDAddedTo:@"下载完成,正在打开" animated:YES];
        //        if (error) {
        //
        //        }else {
        NSString *name = [filePath path];
        NSLog(@"下载完成文件路径＝＝＝%@",name);
        [self openDocxWithPath:name];
        //        }
    }];
    [task resume];//开始下载 要不然不会进行下载的
    
}

/**
 打开文件
 
 @param filePath 文件路径
 */
-(void)openDocxWithPath:(NSString *)filePath {
    
    UIDocumentInteractionController *doc= [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    doc.delegate = self;
    [doc presentPreviewAnimated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate
//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    
    return CGRectMake(0, 30, KScreenWidth, KScreenHeight);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
