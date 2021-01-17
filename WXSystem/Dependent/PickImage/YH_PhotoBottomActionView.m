//
//  YH_PhotoBottomActionView.m
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoBottomActionView.h"
#import "AssetHelper.h"

#pragma mark - YH_PhotoBottomActionView

@interface YH_PhotoBottomActionView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *chooseBtn;

@property (strong, nonatomic) UIView *topLine;

@property (strong, nonatomic) UIButton *countBtn;

@property (strong, nonatomic) NSMutableArray *assets;

@end

@implementation YH_PhotoBottomActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.chooseBtn];
        [self addSubview:self.countBtn];
        [self addSubview:self.topLine];
    }
    return self;
}

- (void)updateWithAssets:(NSMutableArray *)assets
{
    self.assets = assets;
    
    [self.collectionView reloadData];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    //更新按钮的图标
    [self updateCountBtn];
    
    self.chooseBtn.enabled = [assets count];
}

- (void)updateCountBtn
{
    if (self.assets.count == 0) {
        self.countBtn.hidden = YES;
    } else {
        self.countBtn.hidden = NO;
        [self.countBtn setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)self.assets.count] forState:UIControlStateNormal];
    }
}

- (void)chooseAction:(UIButton *)sender
{
    BLOCK_EXEC(self.chooseBlock);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger number = [self.assets count] + 1;
    return MAX(MIN(number, self.imageMaxNum), 1); // 可变
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger number = [self.assets count];
    if (number < self.imageMaxNum && indexPath.row == number) {
        YH_PhotoBottomSpaceCell *spaceCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoBottomSpaceCell" forIndexPath:indexPath];
        return spaceCell;
    } else {
        if (indexPath.row < number) {
            YH_PhotoBottomImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoBottomImageCell" forIndexPath:indexPath];;
            [imageCell updateWithAsset:self.assets[indexPath.row]];

            return imageCell;
        } else {
            return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        }
    }
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[YH_PhotoBottomSpaceCell class]]) {
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.assets removeObjectAtIndex:indexPath.row];
    [collectionView reloadData];
    [self updateCountBtn];
    
    BLOCK_EXEC(self.updateBlock);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = floorf(CGRectGetHeight(self.frame) - 15.0f);
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7.5f, 5.0f, 7.5f, 5.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 100.0f, CGRectGetHeight(self.frame)) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[YH_PhotoBottomImageCell class] forCellWithReuseIdentifier:@"YH_PhotoBottomImageCell"];
        [_collectionView registerClass:[YH_PhotoBottomSpaceCell class] forCellWithReuseIdentifier:@"YH_PhotoBottomSpaceCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (UIButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 68.0f+6.0f, 7.5f, 60.0f, CGRectGetHeight(self.frame)-15.0f);
        _chooseBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _chooseBtn.backgroundColor = [UIColor clearColor];
        [_chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor tr_colorwithHexString:@"8b8b8b"] forState:UIControlStateHighlighted];
        [_chooseBtn setTitleColor:[UIColor tr_colorwithHexString:@"8b8b8b"] forState:UIControlStateDisabled];
        [_chooseBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

- (UIButton *)countBtn
{
    if (!_countBtn) {
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 78.0f+6.0f, (CGRectGetHeight(self.frame)-19.0f)/2, 19.0f, 19.0f);
        _countBtn.userInteractionEnabled = NO;
        [_countBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countBtn setTitle:@"1" forState:UIControlStateNormal];
        [_countBtn setBackgroundImage:[UIImage imageNamed:@"cmt_number_bg"] forState:UIControlStateNormal];
    }
    return _countBtn;
}

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f)];
        _topLine.backgroundColor = [UIColor tr_colorwithHexString:@"#e5e5e5"];
        _topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _topLine;
}

@end

@interface YH_PhotoBottomImageCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation YH_PhotoBottomImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)updateWithAsset:(ALAsset *)asset
{
    self.imageView.image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_THUMBNAIL];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.backgroundColor = [UIColor tr_colorwithHexString:@"#f0f0f0"];
    }
    return _imageView;
}

@end

@interface YH_PhotoBottomSpaceCell()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation YH_PhotoBottomSpaceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.image = [UIImage imageNamed:@"cmt_kuang_bg"];
    }
    return _imageView;
}

@end

