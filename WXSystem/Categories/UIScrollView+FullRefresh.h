//
//  UIScrollView+FullRefresh.h
//  MiloFoundation
//
//  Created by candy.chen on 2017/8/23.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MJRefresh/MJRefresh.h>

extern CGFloat const kLoadingAnimationDuration;

@interface RefreshProxy : NSProxy
@property (readonly, weak ,nonatomic) UIScrollView *delegate;

@property (nonatomic) NSInteger pageSize;
@property (readonly, nonatomic) NSInteger dataCount;
@property (readonly, nonatomic) NSUInteger refreshCount;
@property (readonly, nonatomic) NSInteger currentPage;

- (instancetype)initWithDelegate:(id)delegate;

@end


@interface UIScrollView  (FullRefresh)

@property (copy, nonatomic) void (^refreshingBlock) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView);

@property (nonatomic,assign) ScrollViewLoadingState loadingState;

@property (strong, nonatomic) NSCache *heightCache;

// 当前第几页
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL automaticallyManageHUD;

// 自动刷新的页数据大小
@property (nonatomic,assign) NSInteger pageSize;
// 数据源的数据条目
@property (nonatomic,assign) NSInteger dataCount;
// 被刷新数据次数
@property (nonatomic,assign) NSUInteger refreshCount;

@property (strong, nonatomic) UIView *emptyDataPlaceHolderView;

@property (strong, nonatomic) MJRefreshFooter *footer;

@property (copy, nonatomic) void (^emptyDataCallback) (UIScrollView *scrollView, CGRect emptyViewPreferredFrame);
/**
 @brief  开启下拉刷新
 
 @param doLoading 下拉刷新触发时的回调
 
 page 从1开始
 
 @since 1.0.0
 */
- (void)enableRefreshHeader:(void (^) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView))doLoading;
/**
 @brief  上拉加载
 
 @param doLoading 上拉加载触发时的回调
 
 page 从1开始
 
 @since 1.0.0
 */
- (void)enableRefreshFooter:(void (^) (NSInteger page, NSInteger pageSize, UIScrollView *scrollView))doLoading;

/**
 @brief  手动触发加载最新数据
 
 @since 1.0.0
 */
- (void)loadNew;
/**
 @brief 刷新最新数据
 
 @param backgroundMode 后台模式
 
 @since 1.1.0
 */
- (void)loadNew:(BOOL)backgroundMode;

/**
 @brief 加载更多数据
 
 @param backgroundMode 是否后台模式
 
 @since 1.1.0
 */
- (void)loadMore:(BOOL)backgroundMode;
/**
 @brief  放置无数据页面
 
 @param view 无数据页面
 
 @since 1.0.0
 */
- (void)placeEmptyView:(UIView *)view;
#pragma mark - 自由模式

- (void)addRefreshHeader:(void (^) (UIScrollView *scrollView))refreshingBlock;
- (void)addRefreshFooter:(void (^) (UIScrollView *scrollView))refreshingBlock;
- (void)resetNoMoreData;
- (void)endRefreshing;
- (void)endRefreshingWithNoMoreData;
- (void)resetPlaceEmptyView;

@end
