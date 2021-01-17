//
//  TR_NoticeListViewController.m
//  WXSystem
//
//  Created by isaac on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_RepairListViewController.h"
#import "TR_NewsListHeader.h"
#import "TR_RepairListCollectionViewCell.h"
#import "TR_RepairSearchVC.h"
#import "TR_RepairOrderRootVC.h"
@interface TR_RepairListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChangeTitleDelegate,UIActionSheetDelegate,RepairCellSelectDeledate>
@property(nonatomic,assign)NSInteger selectIndex;
@property (strong, nonatomic) NSMutableArray *arrayIdentity;;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TR_NewsListHeader *headerCollection;
@property (strong, nonatomic) NSMutableArray *arrayModel;

@end

@implementation TR_RepairListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:@"工单"];
    self.selectIndex = 0;
    self.arrayIdentity=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = TABLECOLOR;
    self.navView.rightImg.image = [UIImage imageNamed:@"search"];
    [self.navView.rightImg addClickEvent:self action:@selector(search)];
    [self.view addSubview:self.headerCollection];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.headerCollection getHeadData:YES];
}
-(void)search{
    TR_RepairSearchVC * vc = [[TR_RepairSearchVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES hideBottomTabBar:YES];
}
#pragma mark---------HeadDeleate--
-(void)getTitleColArray:(NSArray *)array{
    self.arrayModel = [NSMutableArray arrayWithArray:array];
    [self.view addSubview:self.collectionView];
}
#pragma mark-----------CellDidSelectDeledate
-(void)didSelectRepairCell:(NSString*)repairId orderType:(RepairOD_Type)orderType{
    TR_RepairOrderRootVC * vc = [[TR_RepairOrderRootVC alloc]init];
    vc.repairType = orderType;
    vc.repairOrderId = repairId;
    WS(weakSelf);
    vc.reloadOrderList = ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathWithIndex:weakSelf.selectIndex];
        TR_RepairListCollectionViewCell * cell = [weakSelf.collectionView dequeueReusableCellWithReuseIdentifier:self.arrayIdentity[indexPath.item] forIndexPath:indexPath];
        [cell loadWithColCode:weakSelf.arrayModel[self.selectIndex] title:@""];
    };
    [self.navigationController pushViewController:vc animated:YES hideBottomTabBar:YES];
}
#pragma mark----刷新抬头
- (void)reloadHeadTitle{
    [self.headerCollection getHeadData:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.arrayModel.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_RepairListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.arrayIdentity[indexPath.item] forIndexPath:indexPath];
    cell.cellDelegate = self;
    NSString *title =[self.arrayModel objectAtIndex:indexPath.item];
    if (indexPath.item == self.selectIndex) {
        if (!cell.haveLoad) {
            [cell loadWithColCode:title title:@""];
        }
    }
    return cell;
}
-(void)changeTitleWithModel:(NSString *)title selectIndex:(NSInteger)index{
    self.collectionView.contentOffset = CGPointMake(KScreenWidth*index, 0);
    self.selectIndex = index;
    [self.collectionView reloadData];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.selectIndex = scrollView.contentOffset.x/KScreenWidth;
    [self.headerCollection scrollGetSelectIndex:self.selectIndex];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KScreenWidth, KScreenHeight-KNAV_HEIGHT-45);
}

-(TR_NewsListHeader *)headerCollection{
    if (!_headerCollection) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 40;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _headerCollection = [[TR_NewsListHeader alloc] initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, 45) collectionViewLayout:layout];
        _headerCollection.titleDelegate = self;
    }
    return _headerCollection;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 40;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 45+KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT -45) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = TABLECOLOR;
        for (int i = 0; i < self.arrayModel.count; i++) {
            NSString *identity = [NSString stringWithFormat:@"cell%d",i];
            [self.arrayIdentity addObject:identity];
            [_collectionView registerClass:[TR_RepairListCollectionViewCell class] forCellWithReuseIdentifier:identity];
        }
    }
    return _collectionView;
}
@end
