//
//  TR_NewsListHeader.m
//  HouseProperty
//
//  Created by isaac on 2018/9/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_NewsListHeader.h"
#import "NewsHeaderCollectionViewCell.h"
#import "TR_NoticeListViewModel.h"

@implementation TR_NewsListHeader

{
    NSInteger selectIndex;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        selectIndex = 0;
        _arrayTitle = [[NSMutableArray alloc]init];
        _haveLoad = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[NewsHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell"];
        
        self.model = [[TR_NoticeListViewModel alloc]init];
        WS(weakSelf);
        [[TR_LoadingHUD sharedHud] showInView:self];
        [self.model fetchNoticeColsList:nil completionBlock:^(BOOL flag, NSString *error) {
            SS(strongSelf);
            [[TR_LoadingHUD sharedHud] dismissInView:strongSelf];
            if (flag) {
                if ([strongSelf.model numberOfRowsCount] == 0) {

                }else{
                    if ([strongSelf.titleDelegate respondsToSelector:@selector(changeTitleWithModel:selectIndex:)]) {
                        [strongSelf.titleDelegate getTitleColArray:self.model.infoArray];
                    }
                }
                if (error) {
                    [TRHUDUtil showMessageWithText:error];
                }
            }
            [strongSelf reloadData];
        }];
    }
    return self;
}
-(void)loadTitleWithArrayTitle:(NSArray *)array{
    _haveLoad = YES;
    [self.arrayTitle addObjectsFromArray:array];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.model numberOfRowsCount];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_NoticeColModel *myModel = (TR_NoticeColModel *)[self.model marketModelViewModelAtIndex:indexPath.item];
    NewsHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell" forIndexPath:indexPath];
    cell.model = myModel;
    if (indexPath.item == selectIndex) {
        cell.lblTitle.textColor = UICOLOR_RGBA(0, 166, 100);
        cell.lblLine.backgroundColor = UICOLOR_RGBA(0, 151, 63);
    }else{
        cell.lblTitle.textColor = UICOLOR_RGBA(33, 33, 33);
        cell.lblLine.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    selectIndex = indexPath.item;
    TR_NoticeColModel *model = self.model.infoArray[selectIndex];
    [self reloadData];
    if ([_titleDelegate respondsToSelector:@selector(changeTitleWithModel:selectIndex:)]) {
        [_titleDelegate changeTitleWithModel:model selectIndex:selectIndex];
    }
}
-(void)scrollGetSelectIndex:(NSInteger)index{
    selectIndex = index;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self reloadData];
    TR_NoticeColModel *model = self.model.infoArray[selectIndex];
    if ([_titleDelegate respondsToSelector:@selector(changeTitleWithModel:selectIndex:)]) {
        [_titleDelegate changeTitleWithModel:model selectIndex:selectIndex];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(KScreenWidth/3.5, 45);
}

@end
