//
//  TR_NewsListHeader.m
//  HouseProperty
//
//  Created by isaac on 2018/9/11.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "TR_NewsListHeader.h"
#import "NewsHeaderCollectionViewCell.h"
#import "TR_OrderHeadModel.h"

@implementation TR_NewsListHeader

{
    NSInteger selectIndex;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        selectIndex = 0;
        _haveLoad = NO;
        _arrayTitle = [[NSMutableArray alloc]init];
        _arrayTitle=@[@"全部",@"待接单",@"待服务",@"服务中",@"已完成",@"待回访",@"已取消"].mutableCopy;
        _arrayNumber=@[@"",@"",@"",@"",@"",@"",@""].mutableCopy;
        _arrayType=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6"].mutableCopy;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[NewsHeaderCollectionViewCell class] forCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell"];
    }
    return self;
}
#pragma mark-----Data数据源
- (void)getHeadData:(BOOL)isReponsCell{
    WS(weakSelf);
    [self.viewModel getOrderHeadNumberCompletionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [weakSelf.arrayNumber removeAllObjects];
            for (NSInteger i=0; i<weakSelf.arrayTitle.count; i++) {
                NSString * headTitle = weakSelf.arrayTitle[i];
                if ([headTitle isEqualToString:@"全部"]) {
                    [weakSelf.arrayNumber  addObject:@""];
                }if ([headTitle isEqualToString:@"待接单"]) {
                    if ([weakSelf.viewModel.headModel.waitMeReceipt isEqualToString:@"0"]) {
                        [weakSelf.arrayNumber  addObject:@""];
                    }else{
                        [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.waitMeReceipt];
                    }
                }if ([headTitle isEqualToString:@"待服务"]) {
                    if ([weakSelf.viewModel.headModel.waitMeService isEqualToString:@"0"]) {
                        [weakSelf.arrayNumber  addObject:@""];
                    }else{
                        [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.waitMeService];
                    }
                    
                }if ([headTitle isEqualToString:@"服务中"]) {
                    if ([weakSelf.viewModel.headModel.waitMeComplete isEqualToString:@"0"]) {
                        [weakSelf.arrayNumber  addObject:@""];
                    }else{
                        [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.waitMeComplete];
                    }
                }if ([headTitle isEqualToString:@"已完成"]) {
                    if ([weakSelf.viewModel.headModel.completed isEqualToString:@"0"]) {
                        [weakSelf.arrayNumber  addObject:@""];
                    }else{
                           [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.completed];
                    }
                }if ([headTitle isEqualToString:@"待回访"]) {
                    if ([weakSelf.viewModel.headModel.returnVisit isEqualToString:@"0"]) {
                         [weakSelf.arrayNumber  addObject:@""];
                    }else{
                         [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.returnVisit];
                    }
                }if ([headTitle isEqualToString:@"已取消"]) {
                    if ([weakSelf.viewModel.headModel.canceled isEqualToString:@"0"]) {
                        [weakSelf.arrayNumber  addObject:@""];
                    }else{
                        [weakSelf.arrayNumber  addObject:weakSelf.viewModel.headModel.canceled];
                    }
                }
            }
            [weakSelf reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
    if (isReponsCell) {
        if ([self.titleDelegate respondsToSelector:@selector(getTitleColArray:)]) {
            [self.titleDelegate getTitleColArray:self.arrayType];
        }
    }
}
-(void)getTitleColArray:(NSArray *)array{
    _haveLoad = YES;
    [self.arrayTitle addObjectsFromArray:array];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrayTitle.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell" forIndexPath:indexPath];
    NSString * number = self.arrayNumber[indexPath.row];
    if (indexPath.item == selectIndex) {
        cell.lblTitle.textColor = UICOLOR_RGBA(76, 159, 255);
        cell.lblLine.backgroundColor = UICOLOR_RGBA(76, 159, 255);
    }else{
        cell.lblTitle.textColor = UICOLOR_RGBA(102, 102, 102);
        cell.lblLine.backgroundColor = [UIColor clearColor];
    }
    if (number.length>0) {
        NSString * title = [NSString stringWithFormat:@"%@ %@",self.arrayTitle[indexPath.row],self.arrayNumber[indexPath.row]];
        cell.lblTitle.attributedText = [self cellTitleLabText:title keyWords:self.arrayNumber[indexPath.row]];
    }else{
        cell.lblTitle.text =self.arrayTitle[indexPath.row] ;
    }
   
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    selectIndex = indexPath.item;
    NSString * title = self.arrayTitle[selectIndex];
    [self reloadData];
    if ([_titleDelegate respondsToSelector:@selector(changeTitleWithModel:selectIndex:)]) {
        [_titleDelegate changeTitleWithModel:title selectIndex:selectIndex];
    }
}
-(void)scrollGetSelectIndex:(NSInteger)index{
    selectIndex = index;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self reloadData];
    NSString * title = self.arrayTitle[selectIndex];
    if ([_titleDelegate respondsToSelector:@selector(changeTitleWithModel:selectIndex:)]) {
        [_titleDelegate changeTitleWithModel:title selectIndex:selectIndex];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = self.arrayTitle[indexPath.row];
    NSString * number = self.arrayNumber[indexPath.row];
    if (number.length>0) {
         title = [NSString stringWithFormat:@"%@ %@",self.arrayTitle[indexPath.row],self.arrayNumber[indexPath.row]];
    }
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 45)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                     context:nil];
    return CGSizeMake(rect.size.width, 45);
}
- (NSAttributedString *)cellTitleLabText:(NSString *)title keyWords:(NSString*)keyWords{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
    //匹配搜索关键字，并且改变颜色
    if(keyWords.length >0)
    {
        [title enumerateStringsMatchedByRegex:keyWords usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            [attributeString addAttribute:NSForegroundColorAttributeName value:UICOLOR_RGBA(251, 54, 63) range:*capturedRanges];
            
        }];
    }
    return attributeString;
}
- (TR_RepairViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel=[[TR_RepairViewModel alloc]init];
    }
    return _viewModel;
}
@end
