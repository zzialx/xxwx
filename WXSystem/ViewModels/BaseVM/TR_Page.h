//
//  TR_Page.h
//  Traceability
//
//  Created by candy.chen on 2019/2/12/3.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TR_Page : NSObject <NSCopying>
/**
 * 总条数
 */
@property(nonatomic) NSInteger totalCount;
/**
 * 总分页数
 */
@property(nonatomic) NSInteger totalPageCount;
/**
 * 当前页码
 *
 * 从1开始
 */
@property(nonatomic) NSInteger currentPage;

/**
 * 每页显示数
 */
@property(nonatomic) NSInteger pageSize;

/**
 * 增加页数
 */
- (void) increasePage;

/**
 * 重置
 */
- (void) reset;

/**
 * 是否是第一页
 *
 * @return YES or NO
 */
- (BOOL) isFirstPage;
@end
