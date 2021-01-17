//
//  YH_ImagePickerViewController.m
//  YH_Mall
//
//  Created by candy.chen on 18/9/13.
//  Copyright (c) 2018年 candy.chen. All rights reserved.
//

#import "YH_ImagePickerViewController.h"
#import "YH_ImagePickerCell.h"
#import "YH_PreviewImageCell.h"

#define kImagePickerBottomViewHeight    44.0f
#define kImagePickerCellSpace           3.0f

static NSString *kPropertyToObserve = @"contentOffset";
static void *kObservingContentOffsetChangesContext = &kObservingContentOffsetChangesContext;

@interface YH_ImagePickerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// picker view
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) UIButton *selectButton;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *previewButton;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UIButton *chooseButton;

@property (strong, nonatomic) UIToolbar *toolBarView;

// preview view
@property (strong, nonatomic) UICollectionView *previewCollectionView;

@property (assign, nonatomic) BOOL previewMode;

@property (copy, nonatomic) NSDictionary *previewDic;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (assign, nonatomic) UIStatusBarStyle  previousStatueBarStyle;

@property (assign, nonatomic) UIBarStyle previousNavigationBarStyle;

@property (assign, nonatomic) UIBarStyle previousToolBarStyle;

// select photos
@property (strong, nonatomic) NSMutableDictionary   *selectedMDic;

@property (strong, nonatomic) NSIndexPath   *lastAccessed;

// init select assets
@property (copy, nonatomic) NSArray *selectAssets;

@end

@implementation YH_ImagePickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nMaxCount = YH_NO_LIMIT_SELECT;
        self.nInitCount = 0;
        self.nColumnCount = 4;
        self.nResultType = YH_PICKER_RESULT_UIIMAGE;
        self.previewMode = NO;
    }
    return self;
}

- (instancetype)initWithSelectAssets:(NSArray *)selectAssets
{
    self = [self init];
    if (self) {
        self.selectAssets = selectAssets;
    }
    return self;
}

- (void)dealloc
{
    [self removeObserer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    
    // new photo is located at the first of array
    ASSETHELPER.bReverse = YES;
    
    WS(weakSelf);
    [ASSETHELPER getSavedPhotoList:^(NSArray *savePhotos) {
        LogInfo(@"Get %ld Saved Photos.", (long)[savePhotos count]);
        [weakSelf updateSelectedDic];
        [weakSelf updateCountLabel];
        [weakSelf.collectionView reloadData];
    } error:^(NSError *error) {
        LogError(@"Get Saved Photos failed:%@", error.localizedDescription);
    }];
    
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.navigationController isKindOfClass:[UINavigationController class]] && [self.navigationController.viewControllers objectAtIndex:0] == self) {
        [self.backButton setHidden:YES];
    }
    
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!iOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatueBarStyle];
        [self.navigationController.navigationBar setBarStyle:self.previousNavigationBarStyle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property get

- (NSMutableDictionary *)selectedMDic
{
    if (!_selectedMDic) {
        _selectedMDic = [NSMutableDictionary dictionary];
    }
    return _selectedMDic;
}

- (UIButton *)backButton{
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton setExclusiveTouch:YES];
        [_backButton setImage:[UIImage imageNamed:@"shared_back_icon"] forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setExclusiveTouch:YES];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIButton *)selectButton{
    
    if (!_selectButton) {
        
        _selectButton = [[UIButton alloc] init];
        _selectButton.frame = CGRectMake(0, 0, 44, 44);
        _selectButton.backgroundColor = [UIColor clearColor];
        [_selectButton setExclusiveTouch:YES];
        
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kImagePickerBundleName];
        NSString *selectedPath = [bundlePath stringByAppendingPathComponent:@"imagepickercell_selected.png"];
        UIImage *selectedImage = [UIImage imageWithContentsOfFile:selectedPath];
        NSString *unselectPath = [bundlePath stringByAppendingPathComponent:@"imagepickercell_unselect.png"];
        UIImage *unselectImage = [UIImage imageWithContentsOfFile:unselectPath];
        
        [_selectButton setImage:unselectImage forState:UIControlStateNormal];
        [_selectButton setImage:selectedImage forState:UIControlStateHighlighted];
        [_selectButton setImage:selectedImage forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButton;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGRect frame = CGRectZero;
        if (iOS7_OR_LATER) {
            frame = CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.view.frame) - kImagePickerBottomViewHeight);
        } else {
            frame = CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.view.frame));
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[YH_ImagePickerCell class] forCellWithReuseIdentifier:@"YH_ImagePickerCell"];
    }
    return _collectionView;
}

- (UICollectionView *)previewCollectionView
{
    if (!_previewCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
        _previewCollectionView.backgroundColor = [UIColor blackColor];
        _previewCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _previewCollectionView.dataSource = self;
        _previewCollectionView.delegate = self;
        _previewCollectionView.alwaysBounceHorizontal = YES;
        _previewCollectionView.showsHorizontalScrollIndicator = NO;
        _previewCollectionView.pagingEnabled = YES;
        _previewCollectionView.scrollsToTop = NO;
        
        [_previewCollectionView registerClass:[YH_PreviewImageCell class] forCellWithReuseIdentifier:@"YH_PreviewImageCell"];
    }
    return _previewCollectionView;
}

- (UIButton *)previewButton
{
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.backgroundColor = [UIColor clearColor];
        _previewButton.frame = CGRectMake(0, 0, 60.0f, 44.0f);
        [_previewButton setExclusiveTouch:YES];
        [_previewButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        if (iOS7_OR_LATER) {
            [_previewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [_previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(handleTapPreviewButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewButton;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.font = [UIFont systemFontOfSize:14.0f];
        if (iOS7_OR_LATER) {
            _countLabel.textColor = [UIColor blackColor];
        } else {
            _countLabel.textColor = [UIColor whiteColor];
        }
        
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIButton *)chooseButton
{
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.backgroundColor = [UIColor clearColor];
        _chooseButton.frame = CGRectMake(0, 0, 60.0f, 44.0f);
        [_chooseButton setExclusiveTouch:YES];
        [_chooseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        if (iOS7_OR_LATER) {
            [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [_chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }

        [_chooseButton setTitle:@"选择" forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(handleTapChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}

- (UIToolbar *)toolBarView
{
    if (!_toolBarView) {
        _toolBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, KScreenHeight - kImagePickerBottomViewHeight, KScreenHeight, kImagePickerBottomViewHeight)];
        _toolBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        if (!iOS7_OR_LATER) {
            _toolBarView.barStyle = UIBarStyleBlackTranslucent;
        }
    }
    return _toolBarView;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        _tapGesture.cancelsTouchesInView = NO;
    }
    return _tapGesture;
}

#pragma mark - Private Methods

- (void)initViews
{
    self.title = @"相机胶卷";
    // left and right navigation item
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    // collectionview
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.previewCollectionView];
    self.previewCollectionView.hidden = YES;
    [self.previewCollectionView addGestureRecognizer:self.tapGesture];
    
    // preview button
    UIBarButtonItem *previewItem = [[UIBarButtonItem alloc] initWithCustomView:self.previewButton];
    
    // count label
    UIBarButtonItem *countItem = [[UIBarButtonItem alloc] initWithCustomView:self.countLabel];
    
    // choose button
    UIBarButtonItem *chooseItem = [[UIBarButtonItem alloc] initWithCustomView:self.chooseButton];
    
    // space item
    UIBarButtonItem *spaceLeftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceLeftItem.width = -15.0f;
    UIBarButtonItem *spaceMiddleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spaceLabelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceLabelItem.width = -20.0f;
    UIBarButtonItem *spaceRightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceRightItem.width = -15.0f;
    
    // toolbar view
    self.toolBarView.items = @[spaceLeftItem, previewItem, spaceMiddleItem, countItem, spaceLabelItem, chooseItem, spaceRightItem];
    [self.view addSubview:self.toolBarView];

    [self updateCountLabel];
}

- (void)updateCountLabel
{
    NSString *countStr = nil;
    if (self.nMaxCount != YH_NO_LIMIT_SELECT) {
        countStr = [NSString stringWithFormat:@"%ld/%ld", (long)[self.selectedMDic count] + self.nInitCount, (long)self.nMaxCount];
    } else {
        countStr = [NSString stringWithFormat:@"(%ld)", (long)[self.selectedMDic count] + self.nInitCount];
    }
    [self.countLabel setText:countStr];
    
    // 当选取一个以上图片时，才可以进入预览模式
    if (self.previewButton.hidden == NO) {
        [self.previewButton setEnabled:self.selectedMDic.count > 0];
    }
}

- (void)updateSelectedDic
{
    if ([self.selectAssets count] == 0) {
        return;
    }
    
    for (ALAsset *asset in self.selectAssets) {
        NSUInteger index = [ASSETHELPER indexOfAsset:asset];
        
        if (index != NSNotFound) {
            LogInfo(@"init select index = %ld", (long)index);
            self.selectedMDic[@(index)] = asset;
        }
    }
    
}

- (NSArray *)selectPhotos
{
    if (self.nResultType == YH_PICKER_RESULT_UIIMAGE) {
        NSArray *assets = [self.selectedMDic allValues];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:assets.count];
        for (ALAsset *asset in assets) {
            UIImage *image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_SCREEN_SIZE]; //ASSET_PHOTO_ASPECT_THUMBNAIL
            if (!image) {
                image = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_ASPECT_THUMBNAIL];
            }
            if (image) {
                [images addObject:image];
            }
        }
        
        return images;
    } else {
       return [self.selectedMDic allValues];
    }
}

- (void)updateCollectionViewLayout
{
    if (self.previewMode) {
        NSString *indexString = [NSString stringWithFormat:@"1/%ld", (long)self.previewDic.count];
        self.title = indexString;
        
        if ([self.navigationController isKindOfClass:[UINavigationController class]] && [self.navigationController.viewControllers objectAtIndex:0] == self) {
            [self.backButton setHidden:NO];
        }
        
        if (iOS7_OR_LATER) {
            self.previousToolBarStyle = self.toolBarView.barStyle;
            self.toolBarView.translucent = YES;
            self.toolBarView.barStyle = UIBarStyleBlack;
        }
        
        UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
        self.navigationItem.rightBarButtonItem = selectItem;
        [self.selectButton setSelected:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            if (iOS7_OR_LATER) {
                self.countLabel.textColor = [UIColor whiteColor];
                [self.chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }

            [self.previewButton setHidden:self.previewMode];
            
            [self.collectionView setHidden:YES];
            [self.previewCollectionView setHidden:NO];
        } completion:^(BOOL finished) {
            [self.previewCollectionView reloadData];
        }];
        
    } else {
        self.title = @"相机胶卷";
        
        if ([self.navigationController isKindOfClass:[UINavigationController class]] && [self.navigationController.viewControllers objectAtIndex:0] == self) {
            [self.backButton setHidden:YES];
        }
        
        if (iOS7_OR_LATER) {
            self.toolBarView.translucent = NO;
            self.toolBarView.barStyle = self.previousToolBarStyle;
        }
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
        self.navigationItem.rightBarButtonItem = cancelItem;
        
        [UIView animateWithDuration:0.3 animations:^{
            if (iOS7_OR_LATER) {
                self.countLabel.textColor = [UIColor blackColor];
                [self.chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [self.previewButton setHidden:self.previewMode];
            
            [self.collectionView setHidden:NO];
            [self.previewCollectionView setHidden:YES];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
    }
}

- (void)hideNavigationAndToolBar
{
    //Check the current state of the navigation bar...
    BOOL navBarState = [self.navigationController isNavigationBarHidden];
    
    // hide statusBar
    [[UIApplication sharedApplication] setStatusBarHidden:!navBarState withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [self.navigationController.navigationBar setAlpha:(navBarState ? 1.0f : 0)];
        [self.toolBarView setAlpha:(navBarState ? 1.0f : 0)];
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:!navBarState];
        [self.toolBarView setHidden:!navBarState];
    }];
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

- (void)backAction:(id)sender
{
    if (self.previewMode) {
        self.previewMode = NO;
        [self updateCollectionViewLayout];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotosFromYHImagePickerController:result:finish:)]) {
            [self.delegate didSelectPhotosFromYHImagePickerController:self result:[self selectPhotos] finish:NO];
        }
        
        [self back:YES];
    }
}

- (void)rightAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelYHImagePickerController:)]) {
        [self.delegate didCancelYHImagePickerController:self];
    }
    
    [self back:YES];
}

- (void)selectAction:(id)sender
{
    if (self.previewMode) {
        NSArray *indexArr = [self.previewCollectionView indexPathsForVisibleItems];
        if ([indexArr count]  == 1) {
            NSIndexPath *indexPath = (NSIndexPath *)indexArr[0];
            
            id key = [self.previewDic.allKeys objectAtIndex:indexPath.row];
            if (self.selectedMDic[key]) {
                [self.selectedMDic removeObjectForKey:key];
                
                [self.selectButton setSelected:NO];
            } else {
                self.selectedMDic[key] = self.previewDic[key];
                
                [self.selectButton setSelected:YES];
            }
            [self updateCountLabel];
        }
    }
}

- (void)handleTapPreviewButton:(id)sender
{
    // 打开图像预览，可编辑选中状态
    self.previewDic = self.selectedMDic;
    self.previewMode = YES;
    [self updateCollectionViewLayout];
    
}

- (void)handleTapChooseButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPhotosFromYHImagePickerController:result:finish:)]) {
        [self.delegate didSelectPhotosFromYHImagePickerController:self result:[self selectPhotos] finish:YES];
    }
    
    // VC弹出规则可以由上一层VC控制
    [self back:YES];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)gesture
{
    if (self.previewMode) {
        [self hideNavigationAndToolBar];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.previewCollectionView]) {
        return [self.previewDic count];
    } else {
        return [ASSETHELPER getPhotoCountOfCurrentGroup];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.previewCollectionView]) {
        YH_PreviewImageCell *previewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_PreviewImageCell" forIndexPath:indexPath];
        
        ALAsset *asset = (ALAsset *)[self.previewDic.allValues objectAtIndex:indexPath.row];
        UIImage *previewImage = [ASSETHELPER getImageFromAsset:asset type:ASSET_PHOTO_SCREEN_SIZE];
//        NSUInteger index = [[self.selectedMDic.allKeys objectAtIndex:indexPath.row] unsignedIntegerValue];
//        UIImage *previewImage = [ASSETHELPER getImageAtIndex:index type:ASSET_PHOTO_ASPECT_THUMBNAIL];
        [previewCell.imageView setImage:previewImage];
        
        
        return previewCell;
    } else {
        YH_ImagePickerCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YH_ImagePickerCell" forIndexPath:indexPath];
        
        if (self.nColumnCount >=4) {
            imageCell.imageView.image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_THUMBNAIL];
        } else {
            imageCell.imageView.image = [ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_ASPECT_THUMBNAIL];
        }
        
        if (self.selectedMDic[@(indexPath.row)]) {
            [imageCell showSelectedView:YES];
        } else {
            [imageCell showSelectedView:NO];
        }
        
        return imageCell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (![collectionView isEqual:self.previewCollectionView]) {
        YH_ImagePickerCell *imageCell = (YH_ImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.selectedMDic[@(indexPath.row)]) {
            
            [self.selectedMDic removeObjectForKey:@(indexPath.row)];
            
            [imageCell showSelectedView:NO];
            [self updateCountLabel];
        } else {
            if ([self.selectedMDic count] + self.nInitCount < self.nMaxCount) {
                self.selectedMDic[@(indexPath.row)] = [ASSETHELPER getAssetAtIndex:indexPath.row];
                self.lastAccessed = indexPath;
                
                [imageCell showSelectedView:YES];
                [self updateCountLabel];
            } else {
                // 单选情况，点击其他图片，可取消之前的选中状态
                if (self.nMaxCount == 1) {
                    [self.selectedMDic removeAllObjects];
                    self.selectedMDic[@(indexPath.row)] = [ASSETHELPER getAssetAtIndex:indexPath.row];
                    self.lastAccessed = indexPath;
                    
                    [collectionView reloadData];
                    
                    [self updateCountLabel];
                } else {
                    // 超出最大选择个数
                    [TRHUDUtil showMessageWithText:[NSString stringWithFormat:@"最多可选择%ld张图片", (long)self.nMaxCount]];
//                    [YH_Tool alertMessage:[NSString stringWithFormat:@"最多可选择%ld张图片", (long)self.nMaxCount]];
                }
            }
        }
    } else {
    
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.previewCollectionView]) {
        return self.previewCollectionView.frame.size;
    } else {
        CGFloat width = floorf((KScreenWidth - kImagePickerCellSpace*(self.nColumnCount-1))/self.nColumnCount);
        return CGSizeMake(width, width);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (!iOS7_OR_LATER && [collectionView isEqual:self.collectionView]) {
        return UIEdgeInsetsMake(64.0f, 0, 44.0f, 0);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.previewCollectionView]) {
        return 0;
    } else {
        return kImagePickerCellSpace;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:self.previewCollectionView]) {
        return 0;
    } else {
        return kImagePickerCellSpace;
    }
}

#pragma mark - KVO

- (void)addObserver
{
    [self.previewCollectionView addObserver:self forKeyPath:kPropertyToObserve options:NSKeyValueObservingOptionNew context:kObservingContentOffsetChangesContext];
}

- (void)removeObserer
{
    [self.previewCollectionView removeObserver:self forKeyPath:kPropertyToObserve];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kObservingContentOffsetChangesContext) {
        if (self.previewMode) {
            CGPoint newPoint = [change[NSKeyValueChangeNewKey] CGPointValue];
            int index = newPoint.x / KScreenWidth;
            if (newPoint.x - index * KScreenWidth == 0) {
                NSString *indexString = [NSString stringWithFormat:@"%d/%lu", index+1, (unsigned long)(self.previewDic.count)];
                self.title = indexString;
                
                id key = [self.previewDic.allKeys objectAtIndex:index];
                if (self.selectedMDic[key]) {
                    [self.selectButton setSelected:YES];
                } else {
                    [self.selectButton setSelected:NO];
                }
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}

@end
