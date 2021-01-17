//
//  TR_MyViewController.m
//  WXSystem
//
//  Created by candylee on 2019/2/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_MyViewController.h"
#import "TR_MyViewModel.h"
#import "TR_MyHeaderCell.h"
#import "TR_AccountCell.h"
#import "TR_LoginOutCell.h"
#import "TR_AboutViewController.h"
#import "TR_SettingViewController.h"
#import "TR_AccountViewController.h"
#import "TR_TabBarViewController.h"
#import "SDImageCache.h"
#import "TR_PersonBaseViewController.h"

static NSString *const kCellTypeAccount = @"kCellTypeAccount";//账户安全
static NSString *const kCellTypeNotice = @"kCellTypeNotice"; //新消息通知
static NSString *const kCellTypeAbout = @"kCellTypeAbout"; //关于
static NSString *const kCellTypeClear = @"kCellTypeClear"; //清除缓存
static NSString *const kCellTypeLoginOut = @"kCellTypeLoginOut"; //退出

@interface TR_MyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *cellArray;

@property (strong, nonatomic) TR_MyViewModel *myViewModel;

@end


@implementation TR_MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
   
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self getMyCellArray];
    WS(weakSelf);
    if (TR_LOGIN) {
        [self.myViewModel getMyDataWithBlock:^(BOOL flag, NSString *error) {
            [weakSelf.collectionView reloadData];
        }];
    }
}

- (NSMutableArray *)getMyCellArray
{
    [self.cellArray removeAllObjects];
    [self.cellArray addObject:@[kCellTypeAccount,kCellTypeNotice]];
    [self.cellArray addObject:@[kCellTypeAbout]];
    [self.cellArray addObject:@[kCellTypeLoginOut]];
    return self.cellArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.cellArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section < 0 || section >= self.cellArray.count) {
        return 0;
    }
    NSArray *cells = [self.cellArray objectAtIndex:section];
    return cells.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellType = self.cellArray[indexPath.section][indexPath.row];
    UICollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TR_MyCollectionCell" forIndexPath:indexPath];
    if ([cellType isEqualToString:kCellTypeLoginOut]) {
        NSString *cellIdent = @"TR_LoginOutCell";
        TR_LoginOutCell *loginOutCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
        return loginOutCell;
    } else {
        NSString *cellIdent = @"TR_AccountCell";
        TR_AccountCell *accountCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdent forIndexPath:indexPath];
        [accountCell updateAccountModel:self.myViewModel atIndexPath:indexPath cellType:cellType];
        return accountCell;
    }
    return myCell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TR_MyHeaderCell *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TR_MyHeaderCell" forIndexPath:indexPath];
        [headerCell updateMyHeader];
        WS(weakSelf);
        headerCell.showInfo = ^{
            TR_PersonBaseViewController * personInfoVC = [[TR_PersonBaseViewController alloc]init];
            [weakSelf.navigationController pushViewController:personInfoVC animated:YES hideBottomTabBar:YES];
        };
        return headerCell;
    }
   return [UICollectionReusableView new];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *cellType = self.cellArray[indexPath.section][indexPath.row];
    if ([cellType isEqualToString:kCellTypeAccount]) {
        TR_AccountViewController *accountVC = [[TR_AccountViewController alloc]initWithNibName:@"TR_AccountViewController" bundle:nil];
        [self.navigationController pushViewController:accountVC animated:YES hideBottomTabBar:YES];

    } else if ([cellType isEqualToString:kCellTypeNotice]) {
        TR_SettingViewController *settingVC = [[TR_SettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES hideBottomTabBar:YES];
    } else if ([cellType isEqualToString:kCellTypeAbout]) {
        TR_AboutViewController *aboutVC = [[TR_AboutViewController alloc]initWithNibName:@"TR_AboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES hideBottomTabBar:YES];
    } else if ([cellType isEqualToString:kCellTypeClear]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                TR_AccountCell *imageCell = (TR_AccountCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [[TR_YYCache shareCache]removeAllCache];
                [imageCell updatePersonView:@"0.00KB"];
            });
    } else if ([cellType isEqualToString:kCellTypeLoginOut]) {
        [self loginOut];
    }
}

- (void)loginOut
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"确认退出登录" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDictionary *dic = @{};
        WS(weakSelf);
        [[TR_LoadingHUD sharedHud]showInView:self.view];
        [self.myViewModel userLoginOut:dic completionBlock:^(BOOL flag, NSString *error) {
            [[TR_LoadingHUD sharedHud]dismissInView:weakSelf.view];
            if (flag) {
                [TRHUDUtil showMessageWithText:@"退出成功"];
                [weakSelf userLoginAction:^(BOOL loginSuccess) {
                }];
            } else {
                [TRHUDUtil showMessageWithText:error];
            }
        }];;
    }];
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [action setValue: UICOLOR_RGBA(251, 54, 63) forKey:@"_titleTextColor"];
    [alertController addAction:action];
    [alertController addAction:action2];
   [self presentViewController: alertController animated: YES completion: nil];

}
#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
       return CGSizeMake(KScreenWidth, 250.0f);
    } else {
       return CGSizeMake(KScreenWidth, 0.0f);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KScreenWidth, 54.0f);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSArray *cellTypes = self.cellArray[section];
    if ([cellTypes containsObject:kCellTypeClear]) {
         return UIEdgeInsetsMake(0, 0, 40, 0);
    }
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

#pragma mark - Getter
- (UICollectionView *)collectionView
{
    if (IsNilOrNull(_collectionView)) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-STATUS_TABBAT_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = TABLECOLOR;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TR_MyCollectionCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_AccountCell" bundle:nil] forCellWithReuseIdentifier:@"TR_AccountCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_LoginOutCell" bundle:nil] forCellWithReuseIdentifier:@"TR_LoginOutCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TR_MyHeaderCell" bundle:nil]forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TR_MyHeaderCell"];
    }
    return _collectionView;
}
//- (void)registerNib:(nullable UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (TR_MyViewModel *)myViewModel
{
    if (IsNilOrNull(_myViewModel)) {
        _myViewModel = [[TR_MyViewModel alloc]init];
    }
    return _myViewModel;
}

- (NSMutableArray *)cellArray
{
    if (IsNilOrNull(_cellArray)) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
