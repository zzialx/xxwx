//
//  CustomShareView.m
//  SuiYangApp
//
//  Created by isaac on 2017/12/22.
//  Copyright © 2017年 zzialx. All rights reserved.
//

#import "CustomShareView.h"
#import "CustomShareCollectionViewCell.h"
@interface CustomShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) NSArray *titles;

@end


@implementation CustomShareView

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,280) collectionViewLayout:layout];
//        layout.minimumLineSpacing = 10;
//        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CustomShareCollectionViewCell class] forCellWithReuseIdentifier:@"CustomShareCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}
- (void)setShareData:(id)shareData
{
    if (shareData) {
        _shareData = shareData;
    }
}
-(id)init{
    self = [super init];
    if (self) {
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self addSubview:view];
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageBottom = [[UIImageView alloc]init];
        imageBottom.frame = [UIScreen mainScreen].bounds;
        imageBottom.backgroundColor = [UIColor blackColor];
        imageBottom.alpha = 0.5;
        [self addClickEvent:self action:@selector(cancelView) owner:imageBottom];
        [view addSubview:imageBottom];
        
        self.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"QQ空间",@"收藏",@"举报"];
        self.images = @[@"微信",@"朋友圈",@"QQ",@"微博",@"收藏",@"举报"];
        [view addSubview:self.collectionView];
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomShareCollectionViewCell" forIndexPath:indexPath];
    cell.lblTitle.text = self.titles[indexPath.item];
    cell.imageTitle.image = [UIImage imageNamed:self.images[indexPath.item]];
    if (indexPath.row>3) {
        cell.imageTitle.sd_layout.centerXEqualToView(cell.contentView)
        .topSpaceToView(cell.contentView,10)
        .widthIs(25)
        .heightIs(25);
    }
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    UILabel *lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(0, 0, KScreenWidth, 50);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"分享至";
    lblTitle.font = [UIFont boldSystemFontOfSize:18];
    [reusableView addSubview:lblTitle];
    
    UILabel *lblCancel = [[UILabel alloc]init];
    lblCancel.frame = CGRectMake(KScreenWidth-80,0, 80, 50);
    lblCancel.text = @"取消";
    lblCancel.textColor = UICOLOR_RGBA(0, 122, 228);
    lblCancel.textAlignment = NSTextAlignmentCenter;
    
    [self addClickEvent:self action:@selector(cancelView) owner:lblCancel];
    lblCancel.font = [UIFont systemFontOfSize:15];
    [reusableView addSubview:lblCancel];
    
    UILabel *lblLine = [[UILabel alloc]init];
    lblLine.frame = CGRectMake(0, 49.5, KScreenWidth, 0.5);
    lblLine.backgroundColor = UICOLOR_RGBA(220, 220, 220);
    [reusableView addSubview:lblLine];
    return reusableView;
}

- (void) addClickEvent:(id)target action:(SEL)action owner:(UIView *)view{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    gesture.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:gesture];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(shareWithOtherApp:)]) {
        [_delegate shareWithOtherApp:indexPath.item];
    }
    [self cancelView];
}
- (void)setIsMinePublish:(BOOL)isMinePublish isHaveCollected:(BOOL)isCollected
{
    if (isMinePublish) {
        _isMinePublish = isMinePublish;
        self.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"QQ空间",@"收藏"];
        self.images = @[@"微信",@"朋友圈",@"QQ",@"微博",isCollected?@"collection_2":@"收藏"];
        [self.collectionView reloadData];
    }else{
        _isMinePublish = isMinePublish;
        self.titles = @[@"微信好友",@"微信朋友圈",@"QQ好友",@"QQ空间",@"收藏",@"举报"];
        self.images = @[@"微信",@"朋友圈",@"QQ",@"微博",isCollected?@"collection_2":@"收藏",@"举报"];
        [self.collectionView reloadData];
    }
}
#pragma mark -- 取消
-(void)cancelView{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.frame = CGRectMake(0, KScreenHeight, KScreenWidth,280);
    } completion:^(BOOL finished) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(cancelCustomView)]) {
            [weakSelf.delegate cancelCustomView];
        }
    }];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-50)/4.0,110);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KScreenWidth, 50);
}
-(void)drawRect:(CGRect)rect{
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionView.frame = CGRectMake(0, KScreenHeight-280, KScreenWidth,280);
    } completion:^(BOOL finished) {
        
    }];
}
@end
