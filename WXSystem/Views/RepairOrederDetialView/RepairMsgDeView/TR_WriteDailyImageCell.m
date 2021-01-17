//
//  TR_WriteDailyImageCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/10/23.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_WriteDailyImageCell.h"
#import "TR_FormImageCollectionCell.h"
#import "SKFPreViewNavController.h"
#import "YH_PhotoPickerViewController.h"
#import "TR_NavigationViewController.h"
#import "YH_ImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TR_FormImageModel.h"
#import "TR_MyViewModel.h"

@interface TR_WriteDailyImageCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,YHPhotoPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) UICollectionView *imageCollection;
@property (strong, nonatomic) NSMutableArray *imageAssets;
@property (strong, nonatomic) NSMutableArray *controlItemValueArr;
@property (strong, nonatomic)TR_MyViewModel *viewModel;
@property (strong, nonatomic) NSMutableArray *picUrls;
@property (strong, nonatomic) NSMutableArray *miniPicUrls;

@end

@implementation TR_WriteDailyImageCell

- (void)updateImageArray:(NSMutableArray *)array {
    self.titleLabel.text = @"添加图片：";
    self.controlItemValueArr = [NSMutableArray arrayWithArray:array];
    self.imageAssets = [[NSMutableArray alloc]init];
}
- (TR_MyViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_MyViewModel alloc]init];
    }
    return _viewModel;
}
+ (CGFloat)heightWithItem:(NSMutableArray *)array {
    CGFloat width = KScreenWidth/4;
    NSInteger rowCount = (int)ceilf((array.count + 1)/4.0);
    return rowCount *width + 55;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(10, 0, self.frame.size.width, 55);
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    CGFloat heihgt = [TR_WriteDailyImageCell heightWithItem:self.controlItemValueArr];
    self.imageCollection.frame = CGRectMake(0, 55, self.frame.size.width, heihgt - 55);
    [self.imageCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.controlItemValueArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TR_FormImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TR_FormImageCollectionCell" forIndexPath:indexPath];
    if (indexPath.row == [self.controlItemValueArr count]) {
        cell.editable = NO;
        [cell.currentImageView  sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"holderIcon"] options:SDWebImageQueryMemoryData completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            NSLog(@"image:%@",image);
        }];
    } else {
            cell.editable = YES;
            TR_FormImageModel *model = self.controlItemValueArr[indexPath.row];
            [cell.currentImageView  sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", model.base,model.url]] placeholderImage:[UIImage imageNamed:@"holderIcon"] options:SDWebImageQueryMemoryData completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"image:%@",image);
            }];
        
    cell.deleteImageCompletion = ^{
        if (indexPath.row < 0 || indexPath.row >= self.controlItemValueArr.count || self.controlItemValueArr.count == 0) {
            return;
        }
        [self.controlItemValueArr removeObjectAtIndex:indexPath.row];
        [self sw_reloadData];
    };
    }
    return cell;
}
#pragma mark - YHImagePickerControllerDelegate

- (void)didSelectPhotosFromPhotoPickerController:(YH_PhotoPickerViewController *)picker result:(NSArray *)aSelected finish:(BOOL)flag {
    if (flag) {
        [self.imageAssets removeAllObjects];
        NSMutableArray *array = [NSMutableArray array];
        int timeTemp = 0;
        for (UIImage *image in aSelected) {
            timeTemp ++;
            TR_FormImageModel *imageModel = [[TR_FormImageModel alloc]init];
            UIImage *theImage = image;
            NSData * imageData = UIImageJPEGRepresentation(theImage, 0.8);
            NSString * imagelength = [NSString stringWithFormat:@"%lu",(unsigned long)imageData.length];//图片大小，单位B
            CGFloat imagth = [imagelength floatValue]/1024;
            imageModel.size = [NSString stringWithFormat:@"%0.2f",imagth];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval stamp = [date timeIntervalSince1970];
            imageModel.name = [NSString stringWithFormat:@"%.0f%d%@", stamp,timeTemp, @".png"];
            [self.imageAssets addObject:imageModel];
            [array addObject:theImage];
        }
    WS(weakSelf);
    [[TR_LoadingHUD sharedHud]showInView:self];
        __block NSInteger i=0;
        for (UIImage * image in aSelected) {
            
            NSArray * imageArray = @[image];
            [self.viewModel uploadImage:imageArray completionBlock:^(NSMutableDictionary *infoDict, NSString *error) {
                i++;
                if (error==nil) {
                    NSLog(@"上传%ld",i);
                    TR_FormImageModel *imageModel = [TR_FormImageModel new];
                    imageModel.type = @"png";
                    imageModel.miniurl = infoDict[@"miniUrl"];
                    imageModel.url = infoDict[@"url"];
                    imageModel.base=infoDict[@"serverUrl"];
                    [weakSelf.controlItemValueArr insertObject:imageModel atIndex:weakSelf.controlItemValueArr.count];
                    if (i==array.count) {
                        [[TR_LoadingHUD sharedHud]dismiss];
                        [weakSelf sw_reloadData];
                    }
                }else{
                    [TRHUDUtil showMessageWithText:error];
                }
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        WS(weakSelf);
        [[TR_LoadingHUD sharedHud]showInView:self];
        NSArray * imageArray = @[theImage];
        [self.viewModel uploadImage:imageArray completionBlock:^(NSMutableDictionary *infoDict, NSString *error) {
            if (error==nil) {
                [weakSelf.picUrls addObject:infoDict[@"url"]];
                [weakSelf.miniPicUrls addObject:infoDict[@"miniUrl"]];
                TR_FormImageModel *imageModel = [TR_FormImageModel new];
                imageModel.type = @"png";
                imageModel.miniurl = infoDict[@"miniUrl"];
                imageModel.url = infoDict[@"url"];
                imageModel.base=infoDict[@"serverUrl"];
                [weakSelf.controlItemValueArr insertObject:imageModel atIndex:weakSelf.controlItemValueArr.count];
                [weakSelf sw_reloadData];
            }else{
                [TRHUDUtil showMessageWithText:error];
            }
        }];
    }
}
// 上面保存图片或录像的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存图片完成");
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.controlItemValueArr.count) {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册选择",nil];
        [action showInView:self];
    } else{
        NSMutableArray *array = [NSMutableArray array];
        if (IsDictionaryClass(self.controlItemValueArr[indexPath.row])) {
            NSDictionary *dic = self.controlItemValueArr[indexPath.row];
            TR_FormImageModel *model = [TR_FormImageModel yy_modelWithDictionary:dic];
            [array addObject:[NSString stringWithFormat:@"%@%@",model.base,model.url]];
        }else {
            for (TR_FormImageModel *model in self.controlItemValueArr) {
                [array addObject:[NSString stringWithFormat:@"%@%@",model.base,model.url]];
            }
        }
          //大图浏览
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:array index:indexPath.row];
        [imagePickerVc setDidFinishDeletePic:^(NSArray<UIImage *> *photos) {
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.window.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (KScreenWidth)/4;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark   ------------- 相机还是相册--------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
                {
                    [TRHUDUtil showMessageWithText:@"照相机无权限访问"];
                    return;
                }
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                    pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                    pickerVC.delegate = self;
                    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self.window.rootViewController presentViewController:pickerVC animated:YES completion:^{
                        
                    }];
                });
               
            } else {
                [TRHUDUtil showMessageWithText:@"后置摄像头不可用"];
            }
        } else {
            [TRHUDUtil showMessageWithText:@"照相机功能不可用"];
        }
    } else if (buttonIndex == 1) {
        [self photoSelectet];
    }
}
#pragma mark - 选择图片
- (void)photoSelectet{
    // 打开图片选择VC
    YH_PhotoPickerViewController *pickVC = [[YH_PhotoPickerViewController alloc] initWithSelectAssets:nil];
    pickVC.nMaxCount = 9;
    pickVC.nInitCount = 0;
    pickVC.nColumnCount = 4;
    pickVC.nResultType = YH_PICKER_RESULT_UIIMAGE;
    pickVC.delegate = self;
    UIViewController *currentVC = [self yh_getCurrentViewController];
    TR_NavigationViewController *navVC = [[TR_NavigationViewController alloc] initWithRootViewController:pickVC];
    navVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [currentVC presentViewController:navVC animated:YES completion:^{
    }];
}

/** 获取当前View的控制器对象 */
- (UIViewController *)yh_getCurrentViewController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}
#pragma mark -- 刷新当前图片数据
- (void)sw_reloadData {
    if (self.imageCompletion) {
        self.imageCompletion(self.controlItemValueArr,nil);
    }
}

- (UICollectionView *)imageCollection {
    if (!_imageCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _imageCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,55, self.frame.size.width,  CGRectGetHeight(self.frame) - 55) collectionViewLayout:layout];
        _imageCollection.backgroundColor = [UIColor whiteColor];
        _imageCollection.delegate = self;
        _imageCollection.dataSource = self;
        _imageCollection.scrollEnabled = NO;
        _imageCollection.scrollsToTop = NO;
        _imageCollection.alwaysBounceVertical = YES;
        _imageCollection.showsVerticalScrollIndicator = NO;
        _imageCollection.showsHorizontalScrollIndicator = NO;
        [_imageCollection registerClass:[TR_FormImageCollectionCell class] forCellWithReuseIdentifier:@"TR_FormImageCollectionCell"];
        [self.contentView addSubview:_imageCollection];
    }
    return _imageCollection;
}
@end
@implementation UITableView (TR_WriteDailyImageCell)

- (TR_WriteDailyImageCell *)leavelImageCellWithId:(NSString *)cellId
{
    TR_WriteDailyImageCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TR_WriteDailyImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.expandableTableView = self;
    }
    return cell;
}

@end
