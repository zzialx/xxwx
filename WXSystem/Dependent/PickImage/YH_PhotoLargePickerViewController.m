//
//  YH_PhotoLargePickerViewController.m
//  YH_Community
//
//  Created by candy.chen on 18/7/15.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoLargePickerViewController.h"
#import "YH_PhotoFullScreenPickerCell.h"
#import "AssetHelper.h"


static void *kObservingContentOffsetChangesContext = &kObservingContentOffsetChangesContext;

@interface YH_PhotoLargePickerViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *selectAssets;

@property (assign, nonatomic) NSInteger maxSelectNum;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) BOOL isPageScrollingFlag;

@property (strong, nonatomic) UIButton *backBtn;    //返回按钮

@property (strong, nonatomic) UIView *topView;      //顶部伪导航栏

@property (strong, nonatomic) UIButton *selectBtn;  //图片选择按钮

@property (strong, nonatomic) UICollectionView *collectionView; //图片浏览器

@end

@implementation YH_PhotoLargePickerViewController

- (instancetype)initWithSelectAssets:(NSMutableArray *)selectAssets maxSelectNum:(NSInteger)number currentIndex:(NSInteger)index
{
    if (self = [super init]) {
        self.selectAssets = selectAssets;
        self.maxSelectNum = number;
        self.currentIndex = index;
        self.isPageScrollingFlag = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)dealloc
{
    [self removeObserer];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Action

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAction:(id)sender
{
    if (self.isPageScrollingFlag) {
        return;
    }
    
    ALAsset *currentAsset = [ASSETHELPER getAssetAtIndex:self.currentIndex];
    NSUInteger selectIndex = [self.selectAssets indexOfObject:currentAsset];
    if (selectIndex == NSNotFound) {
        if ([self.selectAssets count] >= self.maxSelectNum) {
            [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"最多可选择%ld张图片",(long)self.maxSelectNum]];
        } else {
            [self.selectAssets addObject:currentAsset];
            [self.selectBtn setTitle:[NSString stringWithFormat:@"%ld", (unsigned long)self.selectAssets.count] forState:UIControlStateSelected];
            [self.selectBtn setSelected:YES];
        }
    } else {
        [self.selectAssets removeObject:currentAsset];
        [self.selectBtn setSelected:NO];
    }
}

#pragma mark - KVO

- (void)addObserver
{
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:kObservingContentOffsetChangesContext];
}

- (void)removeObserer
{
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:kObservingContentOffsetChangesContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingContentOffsetChangesContext) {
        CGPoint newPoint = [change[NSKeyValueChangeNewKey] CGPointValue];
        int index = newPoint.x / KScreenWidth;
        if (newPoint.x - index * KScreenWidth == 0) {
            self.currentIndex = index;
            ALAsset *currentAsset = [ASSETHELPER getAssetAtIndex:index];
            NSUInteger selectIndex = [self.selectAssets indexOfObject:currentAsset];
            if (selectIndex != NSNotFound) {
                [self.selectBtn setTitle:[NSString stringWithFormat:@"%u", selectIndex+1] forState:UIControlStateSelected];
                [self.selectBtn setSelected:YES];
            } else {
                [self.selectBtn setSelected:NO];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YH_PhotoFullScreenPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoFullScreenPickerCell" forIndexPath:indexPath];
    UIImage *image;
    image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE];
    if (!image) {
         image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE];
    }
    [cell updateWithImage:image];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isPageScrollingFlag = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isPageScrollingFlag = NO;
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = KScreenRect.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[YH_PhotoFullScreenPickerCell class] forCellWithReuseIdentifier:@"YH_PhotoFullScreenPickerCell"];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topView.backgroundColor = [UIColor tr_colorwithHexString:@"#444444"];
        _topView.alpha = 0.6f;
        [_topView addSubview:self.backBtn];
        [_topView addSubview:self.selectBtn];
    }
    return _topView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 10.0f, 44.0f, 44.0f);
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setExclusiveTouch:YES];
        [_backBtn setImage:[UIImage imageNamed:@"product_back_white"] forState:UIControlStateNormal];
        
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(self.view.frame.size.width - 30.0f - 12.0f, (64.0f - 30.0f)/2, 30.0f, 30.0f);
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn setExclusiveTouch:YES];
        [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"" forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"cmt_choose_icon"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"cmt_number_icon"] forState:UIControlStateSelected];
        
        [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
