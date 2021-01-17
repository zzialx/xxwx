//
//  TR_NewsListHeader.h
//  HouseProperty
//
//  Created by isaac on 2018/9/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_NoticeColModel.h"
#import "TR_NoticeListViewModel.h"
@protocol ChangeTitleDelegate<NSObject>
-(void)getTitleColArray:(NSArray *)array;
-(void)changeTitleWithModel:(TR_NoticeColModel *)model selectIndex:(NSInteger)index;
@end

@interface TR_NewsListHeader : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, retain) TR_NoticeListViewModel *model;
@property (nonatomic, retain) NSMutableArray *arrayTitle;
@property (nonatomic, assign) id titleDelegate;
-(void)loadTitleWithArrayTitle:(NSArray *)array;
-(void)scrollGetSelectIndex:(NSInteger)index;
@end
