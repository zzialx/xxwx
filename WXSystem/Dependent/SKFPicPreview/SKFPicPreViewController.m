//
//  SKFPicPreViewController.m
//  SKFPicPreview
//
//  Created by 孙凯峰 on 2017/3/15.
//  Copyright © 2017年 wubianxiaoxian. All rights reserved.
//

#import "SKFPicPreViewController.h"
//#import "NewkPhotoPreviewCell.h"
#import "SKFPreviweCell.h"
#import "UIView+layoutnew.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SKFPreViewNavController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
@interface SKFPicPreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    //    UICollectionView *self.SKFPiccollectionView;
    BOOL _isHideNaviBar;
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel *_displayLabel;
    UIView *_toolBar;
    UIButton *_okButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
}
@property(nonatomic,strong)UICollectionView *SKFPiccollectionView;
@end

@implementation SKFPicPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configCustomNaviBar];
    if (self.SKFPiccurrentIndex)
    {[self.SKFPiccollectionView setContentOffset:CGPointMake((self.view.kf_width) * self.SKFPiccurrentIndex, 0) animated:NO];}
    //添加长按保存图片手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(actionButtonPressed:)];
    [self.view addGestureRecognizer:longPressGesture];
}

- (void)actionButtonPressed:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    }
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            NSString *tips = NSLocalizedString(@"please goto“setting->private->photo”\n allow YOHO access to the album。", nil);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"can't save", nil) message:tips delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        } else {
            
            UIImageView *currentImageView = [[UIImageView alloc]init];
            NSString *image = self.photos[self.SKFPiccurrentIndex];
            if (self.IsNative) {
                currentImageView.image = [UIImage imageNamed:image];
            } else {
                [currentImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"拍照"]];
            }
            
            // 这里再一次判断是否
            if ([currentImageView respondsToSelector:@selector(image)]) {
                [[TR_LoadingHUD sharedHud]showInView:self.view];
                UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            } else {
                // 取不到图片，不保存
            }
        }
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [[TR_LoadingHUD sharedHud]dismissInView:self.view];
    if (!error){
        [TRHUDUtil showMessageWithText:@"保存成功"];
    } else {
        [TRHUDUtil showMessageWithText:@"保存失败"];
    }
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    self.photosTemp = photos;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    
    //    [self refreshNaviBarAndBottomBarState];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)configCustomNaviBar {
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.kf_width, 64)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    _naviBar.alpha = 0.7;
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 15, 22)];
    //    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    //    NSString *bundleName = [currentBundle.infoDictionary[@"CFBundleName"] stringByAppendingString:@".bundle"];
    //    NSString *path = [currentBundle pathForResource:@"back_white.png" ofType:nil inDirectory:bundleName];
    
    //    [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    //    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //    _displayLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.kf_width/2-25, 20, 50, 18)];
    //    _displayLabel.text=[NSString stringWithFormat:@"%ld/%zd",self.SKFPiccurrentIndex+1,self.photos.count];
    //
    //    _displayLabel.textAlignment = NSTextAlignmentCenter;
    //    _displayLabel.textColor=[UIColor whiteColor];
    //    _displayLabel.font=[UIFont systemFontOfSize:18];
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.kf_width - 54, 10, 42, 42)];
    [_selectButton setTitle:@"删除" forState:UIControlStateNormal];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar addSubview:_selectButton];
    if (!self.SKFPicisDelete) {
        _selectButton.hidden=YES;
    }
    else if (self.SKFPicisDelete) {
        _selectButton.hidden=NO;
    }
    [_naviBar addSubview:_backButton];
    //    [_naviBar addSubview:_displayLabel];
    [self.view addSubview:_naviBar];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.kf_width, self.view.kf_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.SKFPiccollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.kf_width , self.view.kf_height) collectionViewLayout:layout];
    self.SKFPiccollectionView.backgroundColor = [UIColor blackColor];
    self.SKFPiccollectionView.dataSource = self;
    self.SKFPiccollectionView.delegate = self;
    self.SKFPiccollectionView.pagingEnabled = YES;
    self.SKFPiccollectionView.scrollsToTop = NO;
    self.SKFPiccollectionView.showsHorizontalScrollIndicator = NO;
    self.SKFPiccollectionView.contentOffset = CGPointMake(0, 0);
    self.SKFPiccollectionView.contentSize = CGSizeMake(self.view.kf_width * _photos.count, self.view.kf_height);
    [self.view addSubview:self.SKFPiccollectionView];
    [self.SKFPiccollectionView registerClass:[SKFPreviweCell class] forCellWithReuseIdentifier:@"SKFPreviweCell"];
}

#pragma mark - Click Event
- (IBAction)PushQuestionBack:(id)sender {
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"我点击了取消");
    }
    else if (buttonIndex==1){
        NSLog(@"删除前self.photos %@ self.photosTemp[self.SKFPiccurrentIndex]%@  self.SKFPiccurrentIndex %ld",self.photos,self.photosTemp[self.SKFPiccurrentIndex],(long)self.SKFPiccurrentIndex);
        [self.photos removeObject:self.photosTemp[self.SKFPiccurrentIndex]];
        
        [self okButtonClick];
        
        
    }
}
- (void)select:(UIButton *)selectButton {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你确实要删除这张图片吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)okButtonClick {
    if (self.photos.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    if (self.okButtonClickBlockWithPreviewType) {
        
        self.okButtonClickBlockWithPreviewType(self.photos);
        //        _displayLabel.text=[NSString stringWithFormat:@"%ld/%zd",self.SKFPiccurrentIndex+1,self.photos.count];
        [self.SKFPiccollectionView reloadData];
        
    }
    
}



- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch{
    [self disMissTap:nil];
}

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    [self disMissTap:nil];
}

#pragma mark - disMissTap
- (void) disMissTap:(UITapGestureRecognizer *)tap{
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    NSLog(@"当前页self.SKFPiccurrentIndex %ld",(long)self.SKFPiccurrentIndex);
    
    self.SKFPiccurrentIndex = (offSet.x + (self.view.kf_width * 0.5)) / self.view.kf_width;
    NSLog(@"offSet.x%f self.view.kf_width %f %f",offSet.x,self.view.kf_width,self.view.frame.size.width);
    //    _displayLabel.text=[NSString stringWithFormat:@"%ld/%zd",self.SKFPiccurrentIndex+1,self.photos.count];
    
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SKFPreviweCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SKFPreviweCell" forIndexPath:indexPath];
    if (self.IsNative) {
        NSLog(@"加载本地图片");
        [cell setKNativeImageview:self.photos[indexPath.row]];
    }
    
    else{
        NSLog(@"加网络图片");
        
        [cell setKImageView:self.photos[indexPath.row]];
        
    }
    //
    //    __block BOOL _weakIsHideNaviBar = _isHideNaviBar;
    //    __weak typeof(_naviBar) weakNaviBar = _naviBar;
    //    __weak typeof(_toolBar) weakToolBar = _toolBar;
    WS(weakSelf);
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            //            // show or hide naviBar / 显示或隐藏导航栏
            //            _weakIsHideNaviBar = !_weakIsHideNaviBar;
            //            weakNaviBar.hidden = _weakIsHideNaviBar;
            //            weakToolBar.hidden = _weakIsHideNaviBar;
            if (weakSelf.picDismiss) {
                weakSelf.picDismiss();
            }
            if (self.navigationController.childViewControllers.count < 2) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
           
        };
    }
    return cell;
}


@end
