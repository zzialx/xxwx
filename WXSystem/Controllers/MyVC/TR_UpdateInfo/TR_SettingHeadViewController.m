//
//  TR_SettingHeadViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/20.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SettingHeadViewController.h"
#import "XCImagePickerTool.h"
#import <Photos/Photos.h>
#include <AVFoundation/AVFoundation.h>

@interface TR_SettingHeadViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView *headImage;

@property (strong, nonatomic) UIButton *photoImage;

@property (strong, nonatomic) UIButton *cameraImage;

@end

@implementation TR_SettingHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_51;
    [self.navView setLeftImg:@"back" title:@"个人头像" rightBtnName:@"修改"];
    [self.navView.rightBtn setTitleColor:UICOLOR_RGBA(25, 140, 255) forState:UIControlStateNormal];
    [self.navView.rightBtn addTarget:self action:@selector(updateHead) forControlEvents:UIControlEventTouchUpInside];
    [self headImage];
//    [self photoImage];
//    [self cameraImage];
    // Do any additional setup after loading the view from its nib.
}
- (void)updateHead{
    WS(weakSelf);
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"修改头像" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf cameraImageClick];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf photoImageClick];
    }];
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
//    [action setValue: UICOLOR_RGBA(51, 51, 51) forKey:@"_titleTextColor"];
//    [action1 setValue: UICOLOR_RGBA(51, 51, 51) forKey:@"_titleTextColor"];
//    [action2 setValue: UICOLOR_RGBA(51, 51, 51) forKey:@"_titleTextColor"];
    [alertController addAction:action];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)photoImageClick
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                LogInfo(@"用户第一次同意了访问相册权限");
                } else { // 用户第一次拒绝了访问相机权限
                LogInfo(@"用户第一次拒绝了访问相册权限");
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
                LogInfo(@"用户允许访问相册权限");
            [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertA];
            alertC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}

- (void)cameraImageClick
{
//    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted){// 用户同意授权
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES; //可编辑
                //判断是否可以打开照相机
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    //摄像头
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }else {// 用户拒绝授权
            }
        }];
    } else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *tips = [NSString stringWithFormat:@"请在”设置-隐私-相机“选项中，允许%@访问你的手机相机",app_Name];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        return;
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES; //可编辑
        //判断是否可以打开照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    WS(weakSelf);
    [[TR_MyViewModel defaultMyVM] uploadImage:@[image] completionBlock:^(NSMutableDictionary *infoDict, NSString *error) {
        SS(strongSelf);
        [[TR_LoadingHUD sharedHud]dismissInView:strongSelf.view];
        if (error) {
            [TRHUDUtil showMessageWithText:error];
        } else {
            strongSelf.headImage.image = image;
            [strongSelf updateUserLogo:infoDict];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//相册选择
- (void)showImagePicker:(UIImagePickerControllerSourceType)sourcetype
{
    XCImagePickerTool *tool = [XCImagePickerTool sharedInstance];
    WS(weakSelf);
    tool.chooseImageBlock = ^(UIImage *image){
        SS(strongSelf);
        [[TR_LoadingHUD sharedHud]showInView:strongSelf.view];
        [[TR_MyViewModel defaultMyVM] uploadImage:@[image] completionBlock:^(NSMutableDictionary *infoDict, NSString *error) {
            [[TR_LoadingHUD sharedHud]dismissInView:strongSelf.view];
            if (error) {
                [TRHUDUtil showMessageWithText:error];
            } else {
                strongSelf.headImage.image = image;
                [strongSelf updateUserLogo:infoDict];
            }
        }];
    };
    
    [tool showImagePickerWithPresentController:self sourceType:sourcetype allowEdit:YES cutFrame:CGRectMake(0,(KScreenHeight - KScreenWidth)/2, KScreenWidth, KScreenWidth)];
}

- (void)updateUserLogo:(NSDictionary *)infoDict
{
    NSString *logo = infoDict[@"url"];
    NSDictionary *data = @{@"fileUrl":MakeStringNotNil(logo)};
    WS(weakSelf);
     [[TR_LoadingHUD sharedHud]showInView:self.view];
     [[TR_MyViewModel defaultMyVM]updateUserinfo:data isHeadImg:YES completionBlock:^(BOOL flag, NSString *error) {
        [[TR_LoadingHUD sharedHud]dismissInView:weakSelf.view];
        if (flag) {
            NSString * logo_url =  [NSString stringWithFormat:@"%@%@",infoDict[@"serverUrl"],infoDict[@"url"]];
            [TR_SystemInfo mainSystem].userInfo.avatarUrl = [NSString stringWithFormat:@"%@%@",infoDict[@"serverUrl"],infoDict[@"url"]];
                NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[GVUserDefaults standardUserDefaults].logoArray];
                if (dataArr.count > 0) {
                    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSData *data = (NSData *)obj;
                        TR_UserModel *locationModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        if ([locationModel.mobile isEqualToString:[TR_USERINFO mobile]]) {
                            locationModel.avatarUrl = logo_url;
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:locationModel];
                            [dataArr replaceObjectAtIndex:idx withObject:data];
                            [GVUserDefaults standardUserDefaults].logoArray = dataArr;
                            *stop = YES;
                        }
                        *stop = NO;
                    }];
                }
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}

- (UIImageView *)headImage
{
    if (IsNilOrNull(_headImage)) {
        _headImage = [[UIImageView alloc]init];
        NSString *string = [[TR_SystemInfo mainSystem].userInfo avatarUrl];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"logo_login"]];;
        [self.view addSubview:_headImage];
        _headImage.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.navView, 40).widthIs(KScreenWidth).heightIs(KScreenWidth);
    }
    return _headImage;
}

- ( UIButton *)photoImage;
{
    if (IsNilOrNull(_photoImage)) {
        _photoImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoImage setTitle:@"从相册选择一张" forState:UIControlStateNormal];
        [_photoImage setTitleColor:[UIColor tr_colorwithHexString:@"#333333"] forState:UIControlStateNormal];
        [_photoImage addTarget:self action:@selector(photoImageClick) forControlEvents:UIControlEventTouchUpInside];
        _photoImage.layer.borderWidth = 0.5f;
        _photoImage.backgroundColor = [UIColor whiteColor];
        _photoImage.layer.borderColor = [UIColor tr_colorwithHexString:@"#DFDFDF"].CGColor;
        [self.view addSubview:_photoImage];
        _photoImage.sd_layout.leftSpaceToView(self.view, 37).topSpaceToView(self.headImage, 40).widthIs(KScreenWidth - 37*2).heightIs(44);
    }
    return _photoImage;
}

- (UIButton *)cameraImage;
{
    if (IsNilOrNull(_cameraImage)) {
        _cameraImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraImage setTitle:@"拍照" forState:UIControlStateNormal];
        [_cameraImage setTitleColor:[UIColor tr_colorwithHexString:@"#333333"] forState:UIControlStateNormal];
        _cameraImage.layer.borderWidth = 0.5f;
        _cameraImage.backgroundColor = [UIColor whiteColor];
        _cameraImage.layer.borderColor = [UIColor tr_colorwithHexString:@"#DFDFDF"].CGColor;
        [_cameraImage addTarget:self action:@selector(cameraImageClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cameraImage];
        _cameraImage.sd_layout.leftSpaceToView(self.view, 37).topSpaceToView(self.photoImage, 20).widthIs(KScreenWidth - 37*2).heightIs(44);
    }
    return _cameraImage;
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
