//
//  TR_AddEquipmentInfoVC.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddEquipmentInfoVC.h"
#import "TR_AddRepairContentCell.h"
#import "TR_AddRepairImgCell.h"
#import "TR_AddEquTitleCell.h"
#import "TR_AddEquInfoCell.h"
#import "TR_AddEquFootView.h"
#import "TR_AddEquMapVC.h"
#import "ZHFAddTitleAddressView.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_EqumentModel.h"
#import "TR_FormImageModel.h"

@interface TR_AddEquipmentInfoVC ()<UITableViewDelegate,UITableViewDataSource,ZHFAddTitleAddressViewDelegate>;
@property(nonatomic,strong)UITableView * table;
@property(nonatomic,strong)NSMutableArray * imgArray;
@property(nonatomic,copy)NSString * content;///<设备描述
@property(nonatomic,strong)TR_AddEquFootView * footView;
@property(nonatomic,strong)NSArray * infoList;
@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;
@property (nonatomic, copy) NSString * select_address;///<选择设备地址
@property (nonatomic, copy) NSString * select_longitude;
@property (nonatomic, copy) NSString * select_latitude;
@property (nonatomic, copy) NSString * areaCode;///<地区编码
@property (nonatomic,strong)TR_EqumentModel * equmentModel;///<设备
@property (nonatomic, copy) TR_RepairDetialViewModel * addEquVM;
@property (nonatomic,assign)BOOL isSelectAreaType;
@end
static NSString * cell_title = @"cell_title";
static NSString  * cell_info = @"cell_info";
static NSString  * cell_img = @"cell_img";
static NSString  * cell_content = @"cell_content";


@implementation TR_AddEquipmentInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:@"补充设备信息"];
    self.imgArray=[NSMutableArray arrayWithCapacity:0];
    self.infoList=@[@"",@"设备名称",@"设备编号",@"品牌",@"设备型号",@"设备位置",@"详细地址"];
    self.equmentModel=[TR_EqumentModel new];
    self.isSelectAreaType=
    [self table];
    [self footView];
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
#pragma mark----提交设备信息
- (void)commitEqumentAction{
    //addrType 0地图  1下拉选择地区
    if (self.equmentModel.equipmentName.length==0) {
        [TRHUDUtil showMessageWithText:@"设备名称不能为空"];
        return;
    }if (self.equmentModel.equipmentNum.length==0) {
        [TRHUDUtil showMessageWithText:@"设备编号不能为空"];
        return;
    }
    NSMutableDictionary * parameter = @{@"orderId": MakeStringNotNil(self.orderId),
                                 @"equipmentName": MakeStringNotNil(self.equmentModel.equipmentName),
                                 @"addrType": self.isSelectAreaType?@"1":@"0",
                                 @"equipmentBrand":MakeStringNotNil(self.equmentModel.equipmentBrand),
                                 @"equipmentNum": MakeStringNotNil(self.equmentModel.equipmentNum),
                                 @"equipmentModel": MakeStringNotNil(self.equmentModel.equipmentModel),
                                 @"criInfo": MakeStringNotNil(self.equmentModel.serviceAddr),
                                 @"longitude":MakeStringNotNil(self.equmentModel.longitude),
                                 @"latitude":MakeStringNotNil(self.equmentModel.latitude),
                                 @"level": @"10",
                                 @"addr": MakeStringNotNil(self.equmentModel.addr),
                                @"picUrls": self.equmentModel.fileUrls.count>0?self.equmentModel.fileUrls:@[],
                                @"miniPicUrls": self.equmentModel.miniPicUrls.count>0?self.equmentModel.miniPicUrls:@[],
                                 @"equipmentSituation":MakeStringNotNil(self.content)}.mutableCopy;
    if (self.isSelectAreaType) {
        [parameter setObject:MakeStringNotNil(self.areaCode) forKey:@"criCode"];
    }
    WS(weakSelf);
    [self.addEquVM addEqumentInfo:parameter completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            BLOCK_EXEC(weakSelf.reloadVC);
             [TRHUDUtil showMessageWithText:@"添加设备成功"];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==8){
        return [TR_AddRepairContentCell heightWithItem];
    }if (indexPath.row==7) {
        return [TR_AddRepairImgCell heightWithItem:self.imgArray];
    }
    return 55.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    if (indexPath.row==0) {
        TR_AddEquTitleCell * titleCell = [tableView dequeueReusableCellWithIdentifier:cell_title];
        if (titleCell==nil) {
            titleCell=[[TR_AddEquTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_title];
        }
        return titleCell;
    }if (indexPath.row==7) {
        TR_AddRepairImgCell *cell_equ_img = [tableView dailyImageCellWithId:cell_img];
        [cell_equ_img updateAddEquImageArray:self.imgArray];
        cell_equ_img.imageCompletion = ^(NSArray *images, NSString *error) {
            //上传图片
            weakSelf.imgArray = [NSMutableArray arrayWithArray:images];
            NSMutableArray * picUrlsList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray * mini_picUrlsList = [NSMutableArray arrayWithCapacity:0];
            //清楚原有的数据
            weakSelf.equmentModel.fileUrls = [NSArray arrayWithArray:picUrlsList];
            weakSelf.equmentModel.miniPicUrls = [NSArray arrayWithArray:mini_picUrlsList];
            for (TR_FormImageModel * imgModel in images) {
                [picUrlsList addObject:imgModel.url];
                [mini_picUrlsList addObject:imgModel.miniurl];
            }
            weakSelf.equmentModel.fileUrls = [NSArray arrayWithArray:picUrlsList];
            weakSelf.equmentModel.miniPicUrls = [NSArray arrayWithArray:mini_picUrlsList];

                [UIView performWithoutAnimation:^{
                    NSInteger row = indexPath.row;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            
        };
        return cell_equ_img;
    }if (indexPath.row==8) {
        TR_AddRepairContentCell *cell_equ_content = [tableView contentProgressCellWithId:cell_content];
        [cell_equ_content updateAddEquContentItem:self.content];
        cell_equ_content.contentBlock = ^(NSString *text,NSString *error) {
            weakSelf.content = text;
        };
        return cell_equ_content;
    }
    TR_AddEquInfoCell * cell_equ_info = [tableView dequeueReusableCellWithIdentifier:cell_info];
    if (cell_equ_info==nil) {
        cell_equ_info=[[TR_AddEquInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_info];
    }
    [cell_equ_info showCellInfo:self.infoList[indexPath.row]  address:self.select_address isShowAddressLogo:indexPath.row==5?YES:NO];
    cell_equ_info.showMapAddress = ^(NSString * _Nonnull latitude, NSString * _Nonnull longitude) {
        TR_AddEquMapVC * vc  = [[TR_AddEquMapVC alloc]init];
        vc.getAddress = ^(NSString * _Nonnull address, NSString * _Nonnull longitude, NSString * _Nonnull latitude) {
            weakSelf.isSelectAreaType=NO;
            weakSelf.select_address=@"";
            weakSelf.equmentModel.serviceAddr=@"";
            weakSelf.equmentModel.longitude=@"";
            weakSelf.equmentModel.latitude = @"";
            weakSelf.select_address=address;
            weakSelf.equmentModel.serviceAddr = address;
            weakSelf.equmentModel.longitude=longitude;
            weakSelf.equmentModel.latitude = latitude;
            [UIView performWithoutAnimation:^{
                NSInteger row = indexPath.row;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell_equ_info.showInputText = ^(NSString * _Nonnull input) {
        NSLog(@"输入框内容===%@",input);
        if (indexPath.row==1) {
            weakSelf.equmentModel.equipmentName=input;
        }if (indexPath.row==2) {
            weakSelf.equmentModel.equipmentNum=input;
        }if (indexPath.row==3) {
            weakSelf.equmentModel.equipmentBrand=input;
        }if (indexPath.row==4) {
            weakSelf.equmentModel.equipmentModel=input;
        }if (indexPath.row==6) {
            weakSelf.equmentModel.addr=input;
        }
    };
    cell_equ_info.showAddressView = ^{
        NSLog(@"地址选择起");
        [weakSelf showAddressSelectView];
    };
    return cell_equ_info;
}
#pragma mark-----下拉选择体质
- (void)showAddressSelectView{
    self.areaCode=@"";
    [self.view endEditing:YES];
    self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = 350;
    self.addTitleAddressView.titleScrollViewH = 37;
    if (self.addTitleAddressView.titleIDMarr.count > 0) {
        self.addTitleAddressView.isChangeAddress = true;
    }
    else{
        self.addTitleAddressView.isChangeAddress = false;
    }
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
    [self.addTitleAddressView addAnimate];
}
#pragma mark-------下拉选择地区-----
-(void)finishBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID longitude:(NSString*)longitude latitude:(NSString*)latitude{
    if (titleAddress.length>0) {
        self.isSelectAreaType=YES;
        self.select_address=@"";
        self.equmentModel.serviceAddr=@"";
        self.equmentModel.longitude=@"";
        self.equmentModel.latitude = @"";
        self.select_address=titleAddress;
        self.equmentModel.serviceAddr = titleAddress;
        self.equmentModel.longitude=longitude;
        self.equmentModel.latitude = latitude;
        self.areaCode = titleID;
        [UIView performWithoutAnimation:^{
            NSInteger row = 5;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

- (UITableView*)table{
    if (IsNilOrNull(_table)) {
        _table=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_table];
        _table.rowHeight=UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 30;
        _table.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .topSpaceToView(self.navView, 0)
        .bottomSpaceToView(self.view, 60);
        [_table registerNib:[UINib nibWithNibName:@"TR_AddEquTitleCell" bundle:nil] forCellReuseIdentifier:cell_title];
        [_table registerNib:[UINib nibWithNibName:@"TR_AddEquInfoCell" bundle:nil] forCellReuseIdentifier:cell_info];

    }
    return _table;
}
- (TR_AddEquFootView*)footView{
    if (IsNilOrNull(_footView)) {
        _footView =(TR_AddEquFootView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_AddEquFootView" owner:self options:nil]lastObject];
        [self.view addSubview:_footView];
        _footView.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(60)
        .bottomSpaceToView(self.view, kSafeAreaBottomHeight);
        WS(weakSelf);
        _footView.commitEqumentInfo = ^{
            [weakSelf commitEqumentAction];
        };
    }
    return _footView;
}
- (TR_RepairDetialViewModel*)addEquVM{
    if (IsNilOrNull(_addEquVM)) {
        _addEquVM=[[TR_RepairDetialViewModel alloc]init];
    }
    return _addEquVM;
}




@end
