//
//  TR_EquipmentInfoCell.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_EquipmentInfoCell.h"
#import "TR_EquCellCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "UICollectionViewRightAlignedLayout.h"
#import "TR_EqumentModel.h"
@interface TR_EquipmentInfoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *firstEquInfoLab;
@property (weak, nonatomic) IBOutlet UIView *secondEquView;
@property (strong,nonatomic)NSMutableArray * equList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabWidth;
@property (strong, nonatomic)TR_RepairDetialModel * equModel;
@end


@implementation TR_EquipmentInfoCell

- (void)showCellEqumentModel:(TR_RepairDetialModel*)equmentModel{
    self.equModel = equmentModel;
    [self.equList removeAllObjects];
    TR_EqumentModel * model = equmentModel.equipmentList.firstObject;
    if (model!=nil) {
        [self.firstEquInfoLab setTitle:model.equipmentName forState:UIControlStateNormal];
        CGSize size = [model.equipmentName  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}];
        CGFloat properWidth = MIN(KScreenWidth - 77-32, size.width+4);
        self.firstLabWidth.constant = properWidth;
    }else{
        self.firstLabWidth.constant  =0;
    }
    if(equmentModel.equipmentList.count>1){
        for (int i =1; i<equmentModel.equipmentList.count; i++) {
            [self.equList addObject:equmentModel.equipmentList[i]];
        }
        [self.collectionView reloadData];
        [self.secondEquView layoutIfNeeded];
        CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        NSLog(@"高度123===%lf",height);
        self.secondViewHeight.constant = height;
    }else{
        self.secondViewHeight.constant = 0.0f;
        TR_EqumentModel * model = equmentModel.equipmentList.firstObject;
        [self.firstEquInfoLab setTitle:model.equipmentName forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.equList=[NSMutableArray arrayWithCapacity:0];
    self.secondViewWidth.constant = KScreenWidth-32;
    self.firstEquInfoLab.layer.borderColor=UICOLOR_RGBA(24, 144, 255).CGColor;
    self.firstEquInfoLab.layer.borderWidth=1.0;
    [self collectionView];
}
- (IBAction)showEquipmentInfoAction:(id)sender {
     TR_EqumentModel * model = self.equModel.equipmentList.firstObject;
    BLOCK_EXEC(self.showEquipmentInfo,model.equipmentId);
}
#pragma mark -- UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.equList.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak TR_EquCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    TR_EqumentModel * model = self.equList[indexPath.row];
    [cell showTeaName:model.equipmentName index:indexPath.row];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TR_EqumentModel *equmentModel = self.equList[indexPath.row];
    NSString * name = equmentModel.equipmentName;
    if (name==nil) {
        return CGSizeMake(60, 32);
    }
    CGSize size = [name  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]}];
    /// 30是左右各15，不至于Label贴边,有减号按钮，右侧又多了8
    //15是角标的宽度
    CGFloat properWidth = MIN(KScreenWidth - 8, size.width+4);
    return CGSizeMake((properWidth + 8), 32);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     TR_EqumentModel *equmentModel = self.equList[indexPath.row];
    BLOCK_EXEC(self.showEquipmentInfo,equmentModel.equipmentId);
}
#pragma mark UICOLLECTVIEW
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
//        UICollectionViewRightAlignedLayout
        UICollectionViewRightAlignedLayout *layout = [[UICollectionViewRightAlignedLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.secondEquView addSubview:_collectionView];
        _collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        _collectionView.backgroundColor=UIColor.whiteColor;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.secondEquView);
        }];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_EquCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
