//
//  TR_ViewModel.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_ViewModel.h"

@implementation TR_ViewModel

- (instancetype)init
{
    if (self = [super init]) {
        self.infoArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithType:(NSInteger)type
{
    if (self = [super init]) {
        self.infoArray = [NSMutableArray array];
        self.hasMoreContent = YES;
        self.isRefreshing = NO;
        self.isLoadingMore = NO;
    }
    return self;
}

- (NSInteger)lastPageString:(TR_DataLoadingType)type
{
    switch (type) {
        case TR_DataLoadingTypeRefresh: {
            self.page.currentPage = 1;
            [self.infoArray removeAllObjects];
        }
            break;
            
        case TR_DataLoadingTypeInfinite: {
            self.page.currentPage ++;
            break;
        }
        default:
            break;
    }
    return self.page.currentPage;
}

- (TR_Model *)marketModelViewModelAtIndex:(NSInteger)index
{
    if (self.infoArray.count == 0) {
        return nil;
    }
    if (index < 0 || index >= self.infoArray.count) {
        return nil;
    }
    return [self.infoArray objectAtIndex:index];
}

- (BOOL)hasMoreQuestion
{
    return self.hasMoreContent;
}

- (NSUInteger)numberOfRowsCount
{
    if (self.infoArray.count == 0) {
        return 0;
    }
    return [self.infoArray count];
}


- (TR_Model *)getMyModelWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.infoArray.count == 0) {
        return nil;
    }
    if (indexPath.section > self.infoArray.count) {
        return nil;
    }
    NSArray *array = [self.infoArray objectAtIndex:indexPath.section];
    if (array.count == 0) {
        return nil;
    }
    if (indexPath.row > array.count) {
        return nil;
    }
    return [array objectAtIndex:indexPath.row];
}
- (TR_Page *)page
{
    if (IsNilOrNull(_page)) {
        _page = [[TR_Page alloc]init];
        _page.currentPage = 0;
        _page.pageSize = kpageOfSize;
    }
    return _page;
}

@end
