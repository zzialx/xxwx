//
//  YH_PhotoPickerViewController.m
//  YH_Community
//
//  Created by candy.chen on 18/7/6.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoPickerViewController.h"
#import "YH_PhotoPickerCell.h"
#import "YH_PreviewImageCell.h"
#import "YH_PhotoTitleView.h"
#import "YH_PhotoGroupPickerView.h"
#import "YH_PhotoLargePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "YH_PhotoBottomActionView.h"
#import "YH_PhotoBottomView.h"
 #import "YH_PhotoLargeImageViewController.h"

#define kImagePickerBottomViewHeight    55.0f
#define kImagePickerCellSpace           5.0f
#define kImagePickerCellMargin          6.0f


@interface YH_PhotoPickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton *sureButton;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic, readwrite) UIButton *cameraButton;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) YH_PhotoTitleView *titleView;

@property (strong, nonatomic) YH_PhotoBottomView *actionView;

@property (strong, nonatomic) YH_PhotoGroupPickerView *groupPickerView;

@property (strong, nonatomic) ALAssetsGroup *currentGroup;

@property (strong, nonatomic) NSArray *lookPhotos;


@end

@implementation YH_PhotoPickerViewController

#pragma mark - Cycle Life

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nMaxCount = YH_NO_LIMIT_SELECT;
        self.nColumnCount = 4;
        self.nResultType = YH_PICKER_RESULT_UIIMAGE;
        self.selectAssets = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets
{
    self = [self init];
    if (self) {
        self.selectAssets = [NSMutableArray arrayWithArray:selectAssets];
    }
    return self;
}

- (void)dealloc
{
    // iOS8上UIScrollView的子类UITableView和UICollectionView在释放时仍会调用回调函数导致crash，需要置空
    if (_collectionView) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
    // new photo is located at the first of array
    ASSETHELPER.bReverse = YES;
    
    WS(weakSelf);
    [ASSETHELPER getGroupList:^(NSArray *groupList) {
        
        if (groupList.count > 0) {
            // 取默认相册名称
            weakSelf.currentGroup = groupList[0];
            [weakSelf updateTitleView];
            
            [ASSETHELPER getSavedPhotoList:^(NSArray *savePhotos) {
                LogInfo(@"Get %ld Saved Photos.", (long)[savePhotos count]);
                [weakSelf updatePhotoView];
            } error:^(NSError *error) {
                LogError(@"Get Saved Photos failed:%@", error.localizedDescription);
            }];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self updatePhotoView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - Private Methods

- (void)initViews
{

//        左边返回，右边完成
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
        UIBarButtonItem *leftSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        leftSpaceButtonItem.width = -13.5f;
        [self.navigationItem setLeftBarButtonItems:@[leftSpaceButtonItem, backItem]];
        
        UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:self.sureButton];
        UIBarButtonItem *rightSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        rightSpaceButtonItem.width = -6.5f;
        [self.navigationItem setRightBarButtonItems:@[rightSpaceButtonItem, cameraItem]];

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.actionView];
    [self.view addSubview:self.groupPickerView];
}

- (NSArray *)selectPhotos
{
    if (self.nResultType == YH_PICKER_RESULT_UIIMAGE) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:self.selectAssets.count];
        for (ALAsset *asset in self.selectAssets) {
            UIImage *image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_FULL_RESOLUTION];
            if (!image) {
               image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_ASPECT_THUMBNAIL];
            }
            if (image) {
                [images addObject:image];
            }
        }
        return images;
    } else {
        return self.selectAssets;
    }
}

- (NSArray *)lookPhotos
{
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:self.selectAssets.count];
        for (ALAsset *asset in self.selectAssets) {
            UIImage *image;
            image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_SCREEN_SIZE]; //ASSET_PHOTO_ASPECT_THUMBNAIL
            if(!image){
                image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_ASPECT_THUMBNAIL];
            }
            
            if (image) {
                [images addObject:image];
            }
        }
        
        return images;
}

- (void)showMaxCountAlert
{
    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"最多可选择%zd张图片",self.nMaxCount]];
    // 超出最大选择个数
}

- (void)updatePhotoView
{
    [self.collectionView reloadData];
    [self.actionView updateCountBtn:self.selectAssets.count];
}

- (void)updateTitleView
{
    NSString *name = [self.currentGroup valueForProperty:ALAssetsGroupPropertyName];
    [self.titleView updateGroupName:name isSelect:NO];
    self.navigationItem.titleView = self.titleView;
}

#pragma mark - Action Methods

- (void)back:(BOOL)animated
{
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)backAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotosFromPhotoPickerController:result:finish:)]) {
        [self.delegate didSelectPhotosFromPhotoPickerController:self result:[self selectPhotos] finish:NO];
    }
    [self back:YES];
}

- (void)rightAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelFromPhotoPickerController:)]) {
        [self.delegate didCancelFromPhotoPickerController:self];
    }
    [self back:YES];
}

- (void)takePhotoAction:(UIButton *)sender
{
    if (self.groupPickerView.isHidden == NO) {
        [self.groupPickerView closePickerView];
    }
    
    NSInteger count = self.nMaxCount - self.selectAssets.count;
    if (count > 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
                {
                    [TRHUDUtil showMessageWithText:@"照相机无权限访问"];
                    return;
                }
                UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                pickerVC.delegate = self;
                [self presentViewController:pickerVC animated:YES completion:nil];
            } else {
                [TRHUDUtil showMessageWithText:@"后置摄像头不可用"];
            }
        } else {
            [TRHUDUtil showMessageWithText:@"照相机功能不可用"];
        }
    } else {
        [self showMaxCountAlert];
    }
}

- (void)handleTapChooseButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotosFromPhotoPickerController:result:finish:)]) {
        [self.delegate didSelectPhotosFromPhotoPickerController:self result:[self selectPhotos] finish:YES];
    }
    // VC弹出规则可以由上一层VC控制
    [self back:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YH_PhotoPickerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoPickerCell" forIndexPath:indexPath];
    
    ALAsset *currentAsset = [ASSETHELPER getAssetAtIndex:indexPath.row];

    UIImage *image = nil;
    if (self.nColumnCount >= 4) {
        image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_ASPECT_THUMBNAIL];
    } else {
        image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_ASPECT_THUMBNAIL];
    }

    [imageCell updateWithImage:image index:[self.selectAssets indexOfObject:currentAsset]];
    
    WS(weakSelf);
    imageCell.selectBlock = ^(id cell, NSString *error){
        NSIndexPath *indexPath = [weakSelf.collectionView indexPathForCell:cell];
        
        ALAsset *currentAsset = [ASSETHELPER getAssetAtIndex:indexPath.row];
        if ([weakSelf.selectAssets containsObject:currentAsset]) {
            [weakSelf.selectAssets removeObject:currentAsset];

            [weakSelf updatePhotoView];
            
        } else {
            if ([weakSelf.selectAssets count] < weakSelf.nMaxCount) {
                
                [weakSelf.selectAssets addObject:currentAsset];
                
                [weakSelf updatePhotoView];
                
                [cell updateCellSelection:YES index:[weakSelf.selectAssets indexOfObject:currentAsset]];
               [weakSelf.actionView updateCountBtn:weakSelf.selectAssets.count];
                
            } else {
                // 单选情况，点击其他图片，可取消之前的选中状态
                if (weakSelf.nMaxCount == 1) {
                    [weakSelf.selectAssets removeAllObjects];
                    [weakSelf.selectAssets addObject:currentAsset];
                    
                    [weakSelf updatePhotoView];
                } else {
                    // 超出最大选择个数
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"最多可选择%zd张图片",self.nMaxCount]];
                }
            }
        }
    };
    return imageCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    YH_PhotoLargePickerViewController *nextVC = [[YH_PhotoLargePickerViewController alloc] initWithSelectAssets:self.selectAssets maxSelectNum:self.nMaxCount currentIndex:indexPath.row];
    nextVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nextVC animated:YES completion:^{
        
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = floorf((MIN(KScreenWidth, KScreenHeight) - kImagePickerCellSpace*(self.nColumnCount-1) - kImagePickerCellMargin*2)/self.nColumnCount);
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kImagePickerCellMargin, kImagePickerCellMargin, kImagePickerCellMargin, kImagePickerCellMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kImagePickerCellSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kImagePickerCellSpace;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [TRHUDUtil showMessageWithText:@"保存中..."];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    LogInfo(@"imageSavedToPhotosAlbum %@", error.localizedDescription);
    if (error) {
        [TRHUDUtil showMessageWithText:@"照片保存失败!"];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WS(weakSelf);
            
            self.currentGroup = [ASSETHELPER getGroupAtIndex:0];
            [self updateTitleView];
            
            [ASSETHELPER getSavedPhotoList:^(NSArray *savePhotos) {
                LogInfo(@"Get %ld Saved Photos.", (long)[savePhotos count]);
                ALAsset *firstItem = [savePhotos objectAtIndex:0];
                if (firstItem && ![weakSelf.selectAssets containsObject:firstItem]) {
                    [weakSelf.selectAssets addObject:firstItem];
                }
                [weakSelf updatePhotoView];
            } error:^(NSError *error) {
                LogError(@"Get Saved Photos failed:%@", error.localizedDescription);
            }];
        });
    }
}

#pragma mark - property get

- (UIButton *)sureButton
{
    if (!_sureButton) {
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, 0, 44, 44);
        [_sureButton setExclusiveTouch:YES];
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(handleTapChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setExclusiveTouch:YES];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(0, 0, 44, 44);
        [_cameraButton setExclusiveTouch:YES];
        [_cameraButton setImage:[UIImage imageNamed:@"cmt_camera_icon"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cameraButton;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGRect frame = CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.view.frame) - kImagePickerBottomViewHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YH_PhotoPickerCell class] forCellWithReuseIdentifier:@"YH_PhotoPickerCell"];
    }
    return _collectionView;
}

- (YH_PhotoTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[YH_PhotoTitleView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 44.0f)];
        _titleView.backgroundColor = [UIColor clearColor];
        
        WS(weakSelf);
        _titleView.openBlock = ^(BOOL flag, NSString *error){
            if (flag) {
                NSString *groupId = [weakSelf.currentGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
                [weakSelf.groupPickerView updateWithAssetsGroupId:groupId];
            } else {
                [weakSelf.groupPickerView closePickerView];
            }
        };
    }
    return _titleView;
}

- (YH_PhotoBottomView *)actionView
{
    if (!_actionView) {
        _actionView = [[YH_PhotoBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kImagePickerBottomViewHeight - kSafeAreaBottomHeight, CGRectGetWidth(self.view.bounds), kImagePickerBottomViewHeight)];
        
        WS(weakSelf);
        _actionView.chooseBlock = ^{
            SS(strongSelf);
            if (strongSelf.selectAssets.count >0) {
                YH_PhotoLargeImageViewController *imageVC = [[YH_PhotoLargeImageViewController alloc]initWithSelectAssets:[strongSelf lookPhotos]];
                imageVC.imageBlock = ^{
                    if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didSelectPhotosFromPhotoPickerController:result:finish:)]) {
                        [strongSelf.delegate didSelectPhotosFromPhotoPickerController:strongSelf result:[strongSelf selectPhotos] finish:YES];
                    }
                    // VC弹出规则可以由上一层VC控制
                    [strongSelf back:YES];
                };
                [strongSelf.navigationController pushViewController:imageVC animated:YES];
            }
        };
        _actionView.updateBlock = ^{
            [weakSelf.collectionView reloadData];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectPhotosFromPhotoPickerController:result:finish:)]) {
                [weakSelf.delegate didSelectPhotosFromPhotoPickerController:weakSelf result:[weakSelf selectPhotos] finish:YES];
            }
            
            // VC弹出规则可以由上一层VC控制
            [weakSelf back:YES];
        };
    }
    return _actionView;
}

- (YH_PhotoGroupPickerView *)groupPickerView
{
    if (!_groupPickerView) {
        _groupPickerView = [[YH_PhotoGroupPickerView alloc] initWithFrame:CGRectMake(0, 64.0f + kSafeAreaTopHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64.0f - kSafeAreaTopHeight - kSafeAreaBottomHeight)];
        _groupPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _groupPickerView.hidden = YES;
        
        WS(weakSelf);
        _groupPickerView.selectBlock = ^(id object, NSString *error){
            if (object) {
                weakSelf.currentGroup = (ALAssetsGroup *)object;
            }
            [weakSelf updateTitleView];
            if (object) {
                [ASSETHELPER getPhotoListOfGroup:weakSelf.currentGroup result:^(NSArray *photos) {
                    [weakSelf.collectionView reloadData];
                }];
            }
        };
    }
    return _groupPickerView;
}

@end
