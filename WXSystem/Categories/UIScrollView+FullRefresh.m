//
//  UIScrollView+FullRefresh.m
//  MiloFoundation
//
//  Created by candy.chen on 2017/8/23.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import "UIScrollView+FullRefresh.h"

CGFloat const kLoadingAnimationDuration = 1.f;
static void sa_exchangeInstanceMethod1(SEL method1, SEL method2, id object)
{
    method_exchangeImplementations(class_getInstanceMethod(object, method1), class_getInstanceMethod(object, method2));
}


#pragma mark -

@interface RefreshProxy()
@property (weak ,nonatomic) UIScrollView *delegate;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSUInteger refreshCount;
@property (nonatomic) ScrollViewLoadingState loadingState;

@property (strong, nonatomic) UIView *emptyDataPlaceHolderView;

@property (strong, nonatomic) MJRefreshFooter *footer;
@property (copy, nonatomic) void (^refreshingBlock) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView);
@property (copy, nonatomic) void (^emptyDataCallback) (UIScrollView *scrollView, CGRect emptyViewPreferredFrame);
@property (nonatomic) BOOL automaticallyManageHUD;
@property (nonatomic) CGFloat percentForPagePreloading;
@property (nonatomic) CGSize recordContentSize;
@property (strong, nonatomic) NSCache *heightCache;


@property (copy, nonatomic) NSArray * (^preprocessData) (NSArray *dataArray, UIScrollView *sv);
@property (nonatomic) NSInteger defaultSection;


- (instancetype)initWithDelegate:(id)delegate;

@end

@implementation RefreshProxy

- (instancetype)initWithDelegate:(id)delegate {
    _delegate = delegate;
    _currentPage = 0;
    _pageSize = 10;
    _loadingState = ScrollViewLoadingState_Idle;
    _automaticallyManageHUD = NO;
    
    _recordContentSize = CGSizeZero;
    self.percentForPagePreloading = 0.1f;// Default
    return self;
}

@end

static void *RefreshProxyKey = &RefreshProxyKey;

@implementation UIScrollView (FullRefresh)
+ (void)load {
    sa_exchangeInstanceMethod1(NSSelectorFromString(@"dealloc"), @selector(sa_dealloc), self);
}

#pragma mark - Swizzle Methods
- (void)sa_dealloc {
    // 释放KVO
    [self sa_dealloc];
}


//- (instancetype)init {
//    self.loadingState = ScrollViewLoadingState_Idle;
//    return self;
//}
#pragma mark - Public
#pragma mark - Public
- (void)enableRefreshHeader:(void (^) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView))doLoading {
    __weak typeof(self) weakSelf = self;
    
    self.proxy.refreshingBlock = doLoading;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (doLoading
            && weakSelf.proxy.loadingState == ScrollViewLoadingState_Idle) {
            // 这里重置footer
            [weakSelf resetNoMoreData];
            
            weakSelf.proxy.loadingState = ScrollViewLoadingState_LoadingNew;
            weakSelf.proxy.refreshCount++;
            
            [weakSelf.proxy.heightCache removeAllObjects];
            
            doLoading(1, weakSelf.pageSize, weakSelf);
        } else {
            if (weakSelf.mj_footer.isRefreshing) {
                [weakSelf.mj_header endRefreshing];
            }
        }
    }];
    
    [header setImages:[[TR_Global sharedInstance] pullingAnimationImages] forState:MJRefreshStateIdle];
    [header setImages:[[TR_Global sharedInstance] refreshAnimationImages] duration:kLoadingAnimationDuration forState:MJRefreshStateRefreshing];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
    
}

- (void)enableRefreshFooter:(void (^) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView))doLoading {
    __weak typeof(self) weakSelf = self;
    
    if (!self.proxy.refreshingBlock) {
        self.proxy.refreshingBlock = doLoading;
    }
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        
//    }];
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (doLoading
            && weakSelf.proxy.loadingState == ScrollViewLoadingState_Idle) {
            
            weakSelf.proxy.loadingState = ScrollViewLoadingState_LoadingMore;
            doLoading(weakSelf.currentPage+1, weakSelf.pageSize, weakSelf);
        } else {
            if (weakSelf.mj_header.isRefreshing) {
                [weakSelf.mj_footer endRefreshing];
            }
        }
    }];
    
//    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [footer setImages:[[TR_Global sharedInstance] pullingAnimationImages] forState:MJRefreshStateIdle];
    [footer setImages:[[TR_Global sharedInstance] refreshAnimationImages] duration:kLoadingAnimationDuration forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.automaticallyHidden = YES;
    self.proxy.footer = footer;
    self.mj_footer = footer;
}

- (void)loadNew:(BOOL)backgroundMode {
    
    // 如果开启了自动管理HUD
    if (self.automaticallyManageHUD && self.dataCount==0 && self.refreshCount==0) {
        
        if (self.proxy.refreshingBlock
            && self.proxy.loadingState == ScrollViewLoadingState_Idle) {
            
            // 这里重置footer
            [self resetNoMoreData];
            
            [self clearEmptyDataView];
            
            self.proxy.loadingState = ScrollViewLoadingState_LoadingNew;
            self.proxy.refreshCount++;
            
            [[TR_LoadingHUD make] showInView:self positionScale:.5f];
            
            self.scrollEnabled = NO;
            self.proxy.refreshingBlock(1, self.pageSize, self);
            
        } else {
            if (self.mj_footer.isRefreshing) {
                [self.mj_header endRefreshing];
            }
        }
    } else {
        
        if (self.mj_header) {
            if (backgroundMode && self.mj_header.refreshingBlock) {
                self.mj_header.refreshingBlock();
            } else {
                [self.mj_header beginRefreshing];
            }
            
        } else {
            [self.mj_footer beginRefreshing];
        }
    }
}

- (void)loadNew {
    [self loadNew:NO];
}

- (void)loadMore:(BOOL)backgroundMode {
    if (self.mj_footer && self.mj_footer.alpha > FLT_EPSILON) {
        if (backgroundMode) {
            !self.mj_footer.refreshingBlock ?: self.mj_footer.refreshingBlock();
        } else {
            [self.mj_footer beginRefreshing];
        }
    }
}

- (void)addRefreshHeader:(void (^) (UIScrollView *scrollView))refreshingBlock {
    __weak typeof(self) weakSelf = self;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        if (weakSelf.proxy.loadingState == ScrollViewLoadingState_Idle) {
            weakSelf.proxy.refreshCount++;
            [weakSelf resetNoMoreData];
            weakSelf.proxy.loadingState = ScrollViewLoadingState_LoadingNew;
            refreshingBlock(weakSelf);
        } else {
            [weakSelf.mj_header endRefreshing];
        }
    }];
    
    [header setImages:[[TR_Global sharedInstance] pullingAnimationImages] forState:MJRefreshStateIdle];
    [header setImages:[[TR_Global sharedInstance] refreshAnimationImages] duration:kLoadingAnimationDuration forState:MJRefreshStateRefreshing];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
}

- (void)addRefreshFooter:(void (^) (UIScrollView *scrollView))refreshingBlock {
    __weak typeof(self) weakSelf = self;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 如果有DataLoader,要以DataLoader为准
            if (weakSelf.proxy.loadingState == ScrollViewLoadingState_Idle) {
                weakSelf.proxy.loadingState = ScrollViewLoadingState_LoadingMore;
                refreshingBlock(weakSelf);
            } else {
                [weakSelf.mj_footer endRefreshing];
            }
    }];
    
//    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    footer.stateLabel.textColor = [UIColor whiteColor];
    [footer setImages:[[TR_Global sharedInstance] pullingAnimationImages] forState:MJRefreshStateIdle];
    [footer setImages:[[TR_Global sharedInstance] refreshAnimationImages] duration:kLoadingAnimationDuration forState:MJRefreshStateRefreshing];
    footer.refreshingTitleHidden = YES;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.automaticallyHidden = YES;
    self.mj_footer = footer;
    self.proxy.footer = footer;
}

- (void)resetNoMoreData {
    self.scrollEnabled = YES;
    [self.mj_footer resetNoMoreData];
}

- (void)endRefreshing {
    
    self.scrollEnabled = YES;
    
    [self yh_dismissHud];
    
    if (self.mj_header.isRefreshing) {
        
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
    
    self.proxy.loadingState = ScrollViewLoadingState_Idle;
}

- (void)endRefreshingWithNoMoreData {
    
    self.scrollEnabled = YES;
    
    self.proxy.loadingState = ScrollViewLoadingState_Idle;
    [self.mj_footer endRefreshingWithNoMoreData];
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    self.mj_footer.alpha = 0.f;
    [self yh_dismissHud];  
}

- (void)placeEmptyView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [self clearEmptyDataView];
    
    [self addSubview:view];
    self.proxy.emptyDataPlaceHolderView = view;
}

- (void)resetPlaceEmptyView {
    // No Data
    CGRect validRect = CGRectMake(0, 0, CGRectGetWidth(self.frame),
                                  CGRectGetHeight(self.frame));
    
    !self.emptyDataCallback ?: self.emptyDataCallback(self, validRect);
}


- (void)clearEmptyDataView {
    if (self.emptyDataPlaceHolderView.superview) {
        [self.emptyDataPlaceHolderView removeFromSuperview];
    }
}

#pragma mark - Private

- (RefreshProxy *)proxy {
    RefreshProxy *p = objc_getAssociatedObject(self, RefreshProxyKey);
    if (!p) {
        p = [[RefreshProxy alloc] initWithDelegate:self];
        objc_setAssociatedObject(self, RefreshProxyKey, p, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return p;
}
#pragma mark - Setters
- (void)setPageSize:(NSInteger)pageSize {
    self.proxy.pageSize = pageSize;
}


- (void)setPreprocessData:(NSArray *(^)(NSArray *, UIScrollView *))preprocessData {
    self.proxy.preprocessData = preprocessData;
}

- (void)setEmptyDataCallback:(void (^)(UIScrollView *, CGRect))emptyDataCallback {
    self.proxy.emptyDataCallback = emptyDataCallback;
}
- (void)setAutomaticallyManageHUD:(BOOL)automaticallyManageHUD {
    self.proxy.automaticallyManageHUD = automaticallyManageHUD;
}

- (void)setPercentForPagePreloading:(CGFloat)percentForPagePreloading {
    self.proxy.percentForPagePreloading = percentForPagePreloading;
}
#pragma mark - Getters
- (NSInteger)pageSize {
    return self.proxy.pageSize;
}
- (NSUInteger)refreshCount {
    return self.proxy.refreshCount;
}

- (NSInteger)currentPage {
    return self.proxy.currentPage;
}

- (void (^)(UIScrollView *, CGRect))emptyDataCallback {
    return self.proxy.emptyDataCallback;
}

//- (MJRefreshAutoNormalFooter *)yh_footer {
//    return (MJRefreshAutoNormalFooter*)self.mj_footer;
//}
- (MJRefreshAutoGifFooter *)yh_footer {
    return (MJRefreshAutoGifFooter*)self.mj_footer;
}

- (BOOL)automaticallyManageHUD {
    return self.proxy.automaticallyManageHUD;
}

- (CGFloat)percentForPagePreloading {
    return self.proxy.percentForPagePreloading;
}


@end
