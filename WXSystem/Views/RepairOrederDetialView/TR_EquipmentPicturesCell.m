//
//  TR_EquipmentPicturesCell.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_EquipmentPicturesCell.h"
#import "TR_RerpairPictureCollectionViewCell.h"

@interface TR_EquipmentPicturesCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)UILabel *titleLab;
@property (strong, nonatomic)UIView * collectionContainer;
@end
static NSString * cellID = @"cellID";
@implementation TR_EquipmentPicturesCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self titleLab];
        [self collectionContainer];
        [self collectionView];
    }
    return self;
}
- (void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    if (_picArray.count>0) {
        [self.collectionView reloadData];
        //立即layoutIfNeeded获取contentSize
        [self.collectionContainer layoutIfNeeded];
        CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        NSLog(@"高度123===%lf",height);
        [self.collectionContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }else{
        [self.collectionContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_RerpairPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSString * picUrl = self.picArray[indexPath.row];
    [cell.equmentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,picUrl]] placeholderImage: [UIImage imageNamed:@"拍照"]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BLOCK_EXEC(self.showPic,indexPath.row);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 60);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (KScreenWidth-32-300)/4;
}

- (UIView*)collectionContainer{
    if (_collectionContainer==nil) {
        _collectionContainer = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_collectionContainer];
        [_collectionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(12);
            make.left.equalTo(self.contentView).offset(16);
            make.width.mas_equalTo(KScreenWidth-32);
            make.height.mas_equalTo(60);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
    }
    return _collectionContainer;
}
- (UICollectionView*)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_RerpairPictureCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
        [self.collectionContainer addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.collectionContainer);
        }];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
- (UILabel*)titleLab{
    if (IsNilOrNull(_titleLab)) {
        _titleLab=[UILabel new];
        _titleLab.font=FONT_TEXT(15);
        _titleLab.textColor=COLOR_153;
        _titleLab.text=@"图片描述：";
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(120);
        }];
    }
    return _titleLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
