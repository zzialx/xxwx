//
//  TR_NoticeListViewController.m
//  OASystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_NoticeListViewController.h"
#import "TR_NewsListHeader.h"
#import "TR_NoticeColModel.h"
#import "TR_NoticeListViewModel.h"
#import "TR_NoticeListCollectionViewCell.h"
@interface TR_NoticeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChangeTitleDelegate>
{
    NSInteger selectIndex;
    NSMutableArray *arrayIdentity;
    NSMutableArray *arrayModel;
}
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) TR_NewsListHeader *headerCollection;
@end

@implementation TR_NoticeListViewController

-(TR_NewsListHeader *)headerCollection{
    if (!_headerCollection) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _headerCollection = [[TR_NewsListHeader alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, 45) collectionViewLayout:layout];
        _headerCollection.titleDelegate = self;
    }
    return _headerCollection;
}
-(void)getTitleColArray:(NSArray *)array{
    arrayModel = [NSMutableArray arrayWithArray:array];
    
    [self.view addSubview:self.collectionView];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45+KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT -45) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        arrayIdentity = [[NSMutableArray alloc]init];
        for (int i = 0; i < arrayModel.count; i++) {
            NSString *identity = [NSString stringWithFormat:@"cell%d",i];
            [arrayIdentity addObject:identity];
            [_collectionView registerClass:[TR_NoticeListCollectionViewCell class] forCellWithReuseIdentifier:identity];
        }
        
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:@"公告"];
    selectIndex = 0;
    [self.view addSubview:self.headerCollection];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrayModel.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_NoticeListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:arrayIdentity[indexPath.item] forIndexPath:indexPath];
    TR_NoticeColModel *model = (TR_NoticeColModel *)[arrayModel objectAtIndex:indexPath.item];
    if (indexPath.item == selectIndex) {
        [cell loadWithColCode:model.typeId];
    }
    return cell;
}
-(void)changeTitleWithModel:(TR_NoticeColModel *)model selectIndex:(NSInteger)index{
    self.collectionView.contentOffset = CGPointMake(KScreenWidth*index, 0);
    selectIndex = index;
    [self.collectionView reloadData];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    selectIndex = scrollView.contentOffset.x/KScreenWidth;
    [self.headerCollection scrollGetSelectIndex:selectIndex];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KScreenWidth, KScreenHeight-KNAV_HEIGHT-45);
}
@end
