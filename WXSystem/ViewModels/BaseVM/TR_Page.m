//
//  TR_Page.m
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_Page.h"

@implementation TR_Page

/**
 * 增加页数
 */
- (void) increasePage {
    self.currentPage ++;
}

/**
 * 重置
 */
- (void) reset {
    self.currentPage = 1;
}

- (BOOL) isFirstPage {
    return (self.currentPage == 1);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<YH_Page>(total=%ld, countPages=%zd, pageNo=%zd, size:%zd)", (long)self.totalCount, self.totalPageCount, self.currentPage, self.pageSize];
}

- (id)copyWithZone:(NSZone *)zone
{
    TR_Page *page = [(TR_Page *)[[self class] allocWithZone:zone] init];
    page.totalCount = self.totalCount;
    page.totalPageCount = self.totalPageCount;
    page.currentPage = self.currentPage;
    page.pageSize = self.pageSize;
    return page;
}


@end
