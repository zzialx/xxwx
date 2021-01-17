//
//  TR_HomeOrderCell.m
//  WXSystem
//
//  Created by admin on 2019/11/11.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_HomeOrderCell.h"
#import "TR_HomeItemCell.h"

@interface TR_HomeOrderCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (copy, nonatomic)NSString * cellType;
@property (strong,nonatomic)NSArray * titleList;
@property (strong,nonatomic)NSArray * numberList;
@end

static NSString * cellID = @"cellID";

@implementation TR_HomeOrderCell
- (void)setHomeModel:(TR_HomeModel *)homeModel{
    _homeModel = homeModel;
    if(!IsNilOrNull(_homeModel)){
        if (self.cellType.integerValue==1) {
            self.numberList = @[_homeModel.waitMeReceipt,_homeModel.waitMeService,_homeModel.waitMeComplete];
        }else{
            self.numberList = @[_homeModel.overdue];
        }
        [self.collectionView reloadData];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString*)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellType = type;
        if (self.cellType.integerValue==1) {
            self.titleList=@[@"待我接单",@"待我服务",@"待我完成"];
            self.numberList=@[@"0",@"0",@"0"];

        }else{
            self.titleList=@[@"逾期工单"];
            self.numberList=@[@"0"];
        }
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(5, 7.5, 5, 7.5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth,120) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_HomeItemCell" bundle:nil] forCellWithReuseIdentifier:cellID];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cellType.integerValue==1?3:1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TR_HomeItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell showCellItem:self.titleList[indexPath.row] number:self.numberList[indexPath.row]];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(120, 120);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (KScreenWidth-15-360)/2;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellType.integerValue==1) {
        if (indexPath.row==0) {
            BLOCK_EXEC(self.clickHomeItem,OrderType_Receive);

        }else if (indexPath.row==1){
            BLOCK_EXEC(self.clickHomeItem,OrderType_Service);

        }else if (indexPath.row==2){
            BLOCK_EXEC(self.clickHomeItem,OrderType_Finish);

        }
    }else{
        BLOCK_EXEC(self.clickHomeItem,OrderType_OutTime);
    }
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
