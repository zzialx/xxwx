//
//  YH_PhotoLargeImageViewController.m
//  WXSystem
//
//  Created by candy.chen on 2019/4/23.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "YH_PhotoLargeImageViewController.h"
#import "YH_PhotoFullScreenPickerCell.h"
#import "YH_PhotoBottomImageCollectionCell.h"

static void *kObservingContentOffsetChangesContext = &kObservingContentOffsetChangesContext;

@interface YH_PhotoLargeImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *selectAssets;

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) BOOL isPageScrollingFlag;

@property (strong, nonatomic) UIButton *backBtn;    //返回按钮

@property (strong, nonatomic) UIView *topView;      //顶部伪导航栏

@property (strong, nonatomic) UIButton *selectBtn;  //图片选择按钮

@property (strong, nonatomic) UICollectionView *collectionView; //图片浏览器

@property (strong, nonatomic) UICollectionView *bottomCollectionView;

@property (strong, nonatomic) UIView *menuBackgroundView;

@property (strong, nonatomic) UILabel *numberLabel;      //当前图片顺序

@end

@implementation YH_PhotoLargeImageViewController

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets
{
    if (self = [super init]) {
        self.selectAssets = [NSMutableArray arrayWithArray:selectAssets];
        self.isPageScrollingFlag = NO;
        [self.selectBtn setTitle:[NSString stringWithFormat:@"完成(%ld)", (unsigned long)self.selectAssets.count] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.menuBackgroundView];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (void)dealloc
{
    [self removeObserer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
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
    [self.navigationController popViewControllerAnimated:NO];
    BLOCK_EXEC(self.imageBlock);
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
            NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
            self.numberLabel.text = [NSString stringWithFormat:@"%lu", self.currentIndex+1];
            [self.bottomCollectionView scrollToItemAtIndexPath:indexpath  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.bottomCollectionView reloadData];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        YH_PhotoFullScreenPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoFullScreenPickerCell" forIndexPath:indexPath];
        [cell updateWithImage:[self.selectAssets objectAtIndex:indexPath.row]];
        return cell;
    } else {
        YH_PhotoBottomImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PhotoBottomImageCollectionCell" forIndexPath:indexPath];
        if (self.currentIndex == indexPath.row) {
            [cell updateWithImage:[self.selectAssets objectAtIndex:indexPath.row] isSelect:YES];
        } else {
            [cell updateWithImage:[self.selectAssets objectAtIndex:indexPath.row] isSelect:NO];
        }
        return cell;
    }
    return [UICollectionViewCell new];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.bottomCollectionView]) {
        LogInfo(@"Select Section %ld", (long)indexPath.row);
        if (self.currentIndex != indexPath.row) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            self.numberLabel.text = [NSString stringWithFormat:@"%lu",indexPath.row +1];
        }
    } else {
        if (!self.isPageScrollingFlag) {
            self.menuBackgroundView.hidden = YES;
            self.topView.hidden = YES;
            self.isPageScrollingFlag = YES;
        } else {
            self.menuBackgroundView.hidden = NO;
            self.topView.hidden = NO;
            self.isPageScrollingFlag = NO;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

#pragma mark - Getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight - 64.0f - 120);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0f, KScreenWidth, KScreenHeight - 64.0f - 120) collectionViewLayout:layout];
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

- (UICollectionView *)bottomCollectionView
{
    if (IsNilOrNull(_bottomCollectionView)) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectionViewLayout setItemSize:CGSizeMake(60,60)];
        [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10, 10.f, 10);
        
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 10.0f, 80) collectionViewLayout:collectionViewLayout];
        
        [_bottomCollectionView registerClass:[YH_PhotoBottomImageCollectionCell class] forCellWithReuseIdentifier:@"YH_PhotoBottomImageCollectionCell"];
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        [_bottomCollectionView setShowsVerticalScrollIndicator:YES];
        _bottomCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        
        if ([self.collectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) {
            [_bottomCollectionView performSelector:@selector(setPrefetchingEnabled:) withObject:0]; //NO - 0, YES - @YES
        }
        
    }
    return _bottomCollectionView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 60, 30, 26, 26)];
        _numberLabel.font = [UIFont systemFontOfSize:11];
        _numberLabel.layer.cornerRadius = 13.0f;
        _numberLabel.clipsToBounds = YES;
        _numberLabel.backgroundColor = BLUECOLOR;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
    }
    return _numberLabel;
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topView.backgroundColor = [UIColor blackColor];
        [_topView addSubview:self.backBtn];
        [_topView addSubview:self.numberLabel];
    }
    return _topView;
}

- (UIView *)menuBackgroundView
{
    if (!_menuBackgroundView) {
        _menuBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 120 - kSafeAreaTopHeight, KScreenWidth, 120.0f)];
        _menuBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _menuBackgroundView.backgroundColor = [UIColor blackColor];
        [_menuBackgroundView addSubview:self.bottomCollectionView];
        [_menuBackgroundView addSubview:self.selectBtn];
    }
    return _menuBackgroundView;
}
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 20.0f, 44.0f, 44.0f);
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
            _selectBtn.frame = CGRectMake(CGRectGetWidth(self.menuBackgroundView.frame) - 71.0f, CGRectGetHeight(self.menuBackgroundView.frame)- 28.0f, 55.0f, 28.0f);
            _selectBtn.backgroundColor = BLUECOLOR;
            [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
            [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_selectBtn setTitle:@"完成0" forState:UIControlStateNormal];
            [_selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    return _selectBtn;
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
