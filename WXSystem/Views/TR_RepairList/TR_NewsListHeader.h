//
//  TR_NewsListHeader.h
//  HouseProperty
//
//  Created by isaac on 2018/9/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_RepairViewModel.h"

typedef void(^TitleColsBlock)(NSArray *array);

@protocol ChangeTitleDelegate<NSObject>
-(void)getTitleColArray:(NSArray *)array;
-(void)changeTitleWithModel:(NSString *)title selectIndex:(NSInteger)index;
@end

@interface TR_NewsListHeader : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, assign) BOOL haveLoad;
@property (nonatomic, strong)TR_RepairViewModel * viewModel;
@property (nonatomic, strong) NSMutableArray *arrayTitle;
@property (nonatomic, strong) NSMutableArray *arrayNumber;
@property (nonatomic, strong) NSMutableArray *arrayType;
@property (nonatomic, assign) id titleDelegate;
@property (nonatomic, copy) TitleColsBlock arrayModel;
- (void)loadTitleWithArrayTitle:(NSArray *)array;
- (void)scrollGetSelectIndex:(NSInteger)index;
- (void)getHeadData:(BOOL)isReponsCell;
@end
