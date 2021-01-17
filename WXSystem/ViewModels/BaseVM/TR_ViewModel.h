//
//  TR_ViewModel.h
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TR_Model.h"
#import "TR_Page.h"
#import "TR_HttpClient.h"

@interface TR_ViewModel : NSObject

//Http request callback blocks
typedef void (^VoidBlock)(void);
typedef void (^StringBlock)(NSString *info, NSString *error);
typedef void (^BoolBlock)(BOOL flag,NSString *error);
typedef void (^ModelBlock)(TR_Model *model, NSString *error);
typedef void (^ObjectBlock)(id object, NSString *error);

typedef void (^ArrayBlock)(NSMutableArray *models, NSString *error);
typedef void (^DictionaryBlock)(NSMutableDictionary *infoDict, NSString *error);
typedef void (^IntegerBlock)(NSInteger index, NSString *error);
typedef void (^ErrorBlock)(NSError *error);

@property (strong, nonatomic) NSMutableArray *infoArray;

@property (assign, nonatomic) BOOL hasMoreContent;

@property (assign, nonatomic) BOOL isRefreshing;

@property (assign, nonatomic) BOOL isLoadingMore;

@property (strong, nonatomic) TR_Page *page;

- (instancetype)initWithType:(NSInteger)type;

/**
 从数组中直接取model对象
 
 @param index model在数组中的索引
 @return 返回指定的model，记得需要强制类型转换
 */
- (TR_Model *)marketModelViewModelAtIndex:(NSInteger)index;


/**
 从元祖中取需要的model(即infoarray中存有多个数组,数组中存有model)
 
 @param indexPath model对应的区行
 @return 指定的model对象
 */
- (TR_Model *)getMyModelWithIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfRowsCount;

- (BOOL)hasMoreQuestion;

- (NSInteger)lastPageString:(TR_DataLoadingType)type;

@end
