//
//  TR_ZbarViewController.m
//  OASystem
//
//  Created by isaac on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ZbarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "drawView.h"
#import "TR_ComputerLoginViewController.h"

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";
static const CGFloat leftWidth = 60;
static const CGFloat heightTop = 120;

@interface TR_ZbarViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResult;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)drawView *drawView;
@end

@implementation TR_ZbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.navView setLeftImg:@"back" title:@"扫一扫" bgColor:[UIColor whiteColor]];
    [self startReading];
    _lastResult = YES;
}
- (BOOL)startReading{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置扫描区域 注:这里CGRectMake中填写的数字是0-1,并且x与y互换,height与width互换
    [captureMetadataOutput setRectOfInterest:CGRectMake(heightTop/self.view.layer.bounds.size.height,leftWidth/self.view.layer.bounds.size.width, (self.view.layer.bounds.size.width - leftWidth*2.0)/self.view.layer.bounds.size.height,(self.view.layer.bounds.size.width - leftWidth*2.0)/self.view.layer.bounds.size.width)];
    
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_videoPreviewLayer setFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight-KNAV_HEIGHT)];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(leftWidth, heightTop, self.view.layer.bounds.size.width - leftWidth*2.0, self.view.layer.bounds.size.width - leftWidth*2.0)];
    _imageView.image = [UIImage imageNamed:@"qrcode_scan_full_net"];
    
    [self.view addSubview:_imageView];

    _drawView = [[drawView alloc]initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight)];
    _drawView.backgroundColor = [UIColor blackColor];
    _drawView.alpha = 0.6;
    [self.view addSubview:_drawView];
    

    //选定一块区域,设置不同的透明度
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,  self.view.bounds.size.width,  self.view.bounds.size.height)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(leftWidth, heightTop, self.view.layer.bounds.size.width - leftWidth*2.0, self.view.layer.bounds.size.width - leftWidth*2.0) cornerRadius:0] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [_drawView.layer setMask:shapeLayer];
    // 开始会话
    [_captureSession startRunning];
    [self stepAnimation];
    
    return YES;
}

- (void)stepAnimation{
    
    CGRect frame = CGRectMake(leftWidth, heightTop, self.view.layer.bounds.size.width - leftWidth*2.0, 0);
    
    _imageView.frame = frame;
    
    _imageView.alpha = 0.0;
    
    __weak __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:3.0 animations:^{
        self.imageView.alpha = 1.0;
        self.imageView.frame = CGRectMake(leftWidth, heightTop,self.view.layer.bounds.size.width - leftWidth*2.0, self.view.layer.bounds.size.width - leftWidth*2.0 + 66);
        
    } completion:^(BOOL finished)
     {
         
         [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
     }];
}

- (void)stopReading{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
    [_imageView removeFromSuperview];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}
- (void)reportScanResult:(NSString *)result{
    [self stopReading];
    if (!_lastResult) {
        return;
    }
    _lastResult = NO;
    [self startReading];
    NSLog(@"result:%@",result);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    }else{
        TR_ComputerLoginViewController *computerVC = [[TR_ComputerLoginViewController alloc]initWithNibName:@"TR_ComputerLoginViewController" bundle:nil];
        [self.navigationController pushViewController:computerVC animated:YES];
    }
    // 以下处理了结果，继续下次扫描
    _lastResult = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
