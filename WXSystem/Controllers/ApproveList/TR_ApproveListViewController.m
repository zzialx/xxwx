//
//  TR_ApproveListViewController.m
//  OASystem
//
//  Created by isaac on 2019/2/18.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_ApproveListViewController.h"
#import "TR_ApproveListCollectionViewCell.h"
@interface TR_ApproveListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UICollectionView *collectionView;
@end

@implementation TR_ApproveListViewController
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight - KNAV_HEIGHT -STATUS_TABBAT_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TR_ApproveListCollectionViewCell class] forCellWithReuseIdentifier:@"TR_ApproveListCollectionViewCell"];
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:@"审批"];
    [self.view addSubview:self.collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 3;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_ApproveListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TR_ApproveListCollectionViewCell" forIndexPath:indexPath];
   
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-50)/4.0, 80);
}
@end
