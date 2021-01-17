//
//  TR_AddRepairProgressVC.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddRepairProgressVC.h"
#import "TR_AddRepairContentCell.h"
#import "TR_AddRepairImgCell.h"
#import "TR_AddRepairProgressFootView.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_FormImageModel.h"
#import "LocationManager.h"
#import "TR_LocationModel.h"
@interface TR_AddRepairProgressVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *writeTableView;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *content_before;
@property (strong, nonatomic) NSString *content_after;
@property (strong, nonatomic) NSMutableArray *service_array_before;///<服务前
@property (strong, nonatomic) NSMutableArray *service_array_before_mini;///<服务前
@property (strong, nonatomic) NSMutableArray *service_array_after;///<服务后
@property (strong, nonatomic) NSMutableArray *service_array_after_mini;///<服务hou
@property (strong, nonatomic) NSMutableArray *service_array_before_cell;///<服务前
@property (strong, nonatomic) NSMutableArray *service_array_after_cell;///<服务前
@property (strong, nonatomic)TR_AddRepairProgressFootView * footView;
@property (strong, nonatomic)TR_RepairDetialViewModel * viewModel;
@property(nonatomic, strong)TR_LocationModel *locationModel;///<定位对象存储在

@end
static NSString *textViewInput_cell_id = @"TR_AddRepairContentCell";
static NSString *image_cell_id = @"TR_AddRepairImgCell";

@implementation TR_AddRepairProgressVC
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navView setTitle:@"添加进度"];
    self.service_array_before=[NSMutableArray arrayWithCapacity:0];
    self.service_array_before_mini=[NSMutableArray arrayWithCapacity:0];
    self.service_array_after=[NSMutableArray arrayWithCapacity:0];
    self.service_array_after_mini=[NSMutableArray arrayWithCapacity:0];
    self.service_array_before_cell=[NSMutableArray arrayWithCapacity:0];
    self.service_array_after_cell=[NSMutableArray arrayWithCapacity:0];
    [[LocationManager shareInstance] addObserver:self forKeyPath:@"locationModel" options:NSKeyValueObservingOptionNew context:nil];

    [self setUI];
    [self footView];
    [self getServiceDearft];
}
#pragma mark---------监听定位地址变化------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.locationModel = [change objectForKey:@"new"];
    NSLog(@"监听地址====%@",self.locationModel.addr);
}
#pragma mark -- TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            TR_AddRepairContentCell *cell = [tableView contentProgressCellWithId:textViewInput_cell_id];
            [cell updateContentItem:self.content_before section:indexPath.section];
            cell.contentBlock = ^(NSString *text,NSString *error) {
                    weakSelf.content_before = text;
            };
            return cell;
        } if (indexPath.row == 1) {
            TR_AddRepairImgCell *cell = [tableView dailyImageCellWithId:image_cell_id];
            [cell updateImageArray:self.service_array_before_cell section:indexPath.section];
            cell.imageCompletion = ^(NSArray *images, NSString *error) {
                [weakSelf.service_array_before_cell removeAllObjects];
                [weakSelf.service_array_before removeAllObjects];
                [weakSelf.service_array_before_mini removeAllObjects];
                    for (TR_FormImageModel * model in images) {
                        [weakSelf.service_array_before_cell addObject:model];
                        [weakSelf.service_array_before addObject:model.url];
                        [weakSelf.service_array_before_mini addObject:model.miniurl];
                    }
                    [UIView performWithoutAnimation:^{
                        NSInteger row = indexPath.row;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
            };
            
            return cell;
        }
    }if (indexPath.section==1) {
            if (indexPath.row == 0) {
                TR_AddRepairContentCell *cell = [tableView contentProgressCellWithId:textViewInput_cell_id];
                [cell updateContentItem:self.content_after section:indexPath.section];
                cell.contentBlock = ^(NSString *text,NSString *error) {
                        weakSelf.content_after = text;
                };
                return cell;
            } if (indexPath.row == 1) {
                TR_AddRepairImgCell *cell = [tableView dailyImageCellWithId:image_cell_id];
                [cell updateImageArray:self.service_array_after_cell section:indexPath.section];
                cell.imageCompletion = ^(NSArray *images, NSString *error) {
                    [weakSelf.service_array_after_cell removeAllObjects];
                    [weakSelf.service_array_after removeAllObjects];
                    [weakSelf.service_array_after_mini removeAllObjects];
                        for (TR_FormImageModel * model in images) {
                            [weakSelf.service_array_after_cell addObject:model];
                            [weakSelf.service_array_after addObject:model.url];
                            [weakSelf.service_array_after_mini addObject:model.miniurl];
                        }
                        [UIView performWithoutAnimation:^{
                            NSInteger row = indexPath.row;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        }];
                };
                return cell;
            }
        }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            return [TR_AddRepairContentCell heightWithItem];
        }
        return [TR_AddRepairImgCell heightWithItem:self.service_array_before_cell];
    }else{
        if (indexPath.row == 0) {
            return [TR_AddRepairContentCell heightWithItem];
        }
        return [TR_AddRepairImgCell heightWithItem:self.service_array_after_cell];
    }
    
}
#pragma mark---------获取工单进度草稿----
- (void)getServiceDearft{
    WS(weakSelf);
    [self.viewModel showServicePgrDraftWithOrderId:self.orderId completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            weakSelf.content_before = weakSelf.viewModel.servicePgrDeiModel.beforeService;
            weakSelf.content_after = weakSelf.viewModel.servicePgrDeiModel.afterService;
            if (weakSelf.viewModel.servicePgrDeiModel.beforePicUrls!=nil) {
                weakSelf.service_array_before=weakSelf.viewModel.servicePgrDeiModel.beforePicUrls.mutableCopy;
                weakSelf.service_array_before_mini=weakSelf.viewModel.servicePgrDeiModel.beforeMiniPicUrls.mutableCopy;
                weakSelf.service_array_after=weakSelf.viewModel.servicePgrDeiModel.afterPicUrls.mutableCopy;
                weakSelf.service_array_after_mini=weakSelf.viewModel.servicePgrDeiModel.afterMiniPicUrls.mutableCopy;
            }
            for (int i=0; i<weakSelf.service_array_before.count; i++) {
                TR_FormImageModel * imgageModel = [TR_FormImageModel new];
                imgageModel.url = weakSelf.service_array_before[i];
                imgageModel.miniurl = weakSelf.service_array_before_mini[i];
                imgageModel.base= [GVUserDefaults standardUserDefaults].fileUrl;
                [weakSelf.service_array_before_cell addObject:imgageModel];
            }for (int i=0; i<weakSelf.service_array_after.count; i++) {
                TR_FormImageModel * imgageModel = [TR_FormImageModel new];
                imgageModel.url = weakSelf.service_array_after[i];
                imgageModel.miniurl = weakSelf.service_array_after_mini[i];
                imgageModel.base= [GVUserDefaults standardUserDefaults].fileUrl;
                [weakSelf.service_array_after_cell addObject:imgageModel];
            }
            
            [weakSelf.writeTableView reloadData];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
#pragma mark---------保存进度草稿-----
- (void)saveAction{
    NSDictionary * paramete=@{@"orderId": MakeStringNotNil(self.orderId),
                              @"beforeService": MakeStringNotNil(self.content_before),
                              @"afterService": MakeStringNotNil(self.content_after),
                              @"beforePicUrls": self.service_array_before,
                              @"beforeMiniPicUrls": self.service_array_before_mini,
                              @"afterPicUrls":self.service_array_after,
                              @"afterMiniPicUrls": self.service_array_after_mini
                              };
    WS(weakSelf);
    [self.viewModel saveServiceProgress:paramete completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [TRHUDUtil showMessageWithText:@"保存服务进度成功"];
            BLOCK_EXEC(weakSelf.reloadVC);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
#pragma mark---------完成任务-----
- (void)finishAction{
    if(self.locationModel.addr.length==0){
        [TRHUDUtil showMessageWithText:@"正在获取定位信息，请稍后"];
        return;
    }
    if (self.content_before.length==0) {
        [TRHUDUtil showMessageWithText:@"服务前情况不可为空"];
        return;
    } if (self.content_after.length==0) {
        [TRHUDUtil showMessageWithText:@"服务后情况不可为空"];
        return;
    }if (self.service_array_before.count==0) {
        [TRHUDUtil showMessageWithText:@"服务前图片不可为空"];
        return;
    }if (self.service_array_after.count==0) {
        [TRHUDUtil showMessageWithText:@"服务前图片不可为空"];
        return;
    }
    NSDictionary * paramete=@{@"orderId": MakeStringNotNil(self.orderId),
                              @"beforeService": MakeStringNotNil(self.content_before),
                              @"afterService": MakeStringNotNil(self.content_after),
                              @"beforePicUrls": self.service_array_before,
                              @"beforeMiniPicUrls": self.service_array_before_mini,
                              @"afterPicUrls":self.service_array_after,
                              @"afterMiniPicUrls": self.service_array_after_mini,
                              @"addr":MakeStringNotNil(self.locationModel.addr),
                              @"longitude":MakeStringNotNil(self.locationModel.longitude),
                              @"latitude":MakeStringNotNil(self.locationModel.latitude)
                              };
    WS(weakSelf);
    [self.viewModel finishServicePgrParameter:paramete completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            BLOCK_EXEC(weakSelf.reloadVC);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
#pragma mark -- TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)setUI{
    [self writeTableView];
    if (@available(iOS 11.0, *)) {
        _writeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (UITableView*)writeTableView{
    if (IsNilOrNull(_writeTableView)) {
        _writeTableView = [[UITableView alloc]init];
        _writeTableView.frame = CGRectMake(0, KNAV_HEIGHT, KScreenWidth, KScreenHeight - kSafeAreaBottomHeight - KNAV_HEIGHT-60);
        [self.view addSubview:_writeTableView];
        _writeTableView.dataSource = self;
        _writeTableView.delegate = self;
        _writeTableView.showsVerticalScrollIndicator = NO;
        _writeTableView.showsHorizontalScrollIndicator = NO;
        _writeTableView.backgroundColor = [UIColor whiteColor];
        _writeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _writeTableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height + 44 + 20, 0);
    }
    return _writeTableView;
}
- (TR_AddRepairProgressFootView*)footView{
    if (IsNilOrNull(_footView)) {
        _footView=(TR_AddRepairProgressFootView*)[[[NSBundle mainBundle]loadNibNamed:@"TR_AddRepairProgressFootView" owner:self options:nil]lastObject];
        [self.view addSubview:_footView];
        _footView.sd_layout.leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(60)
        .bottomSpaceToView(self.view, kSafeAreaBottomHeight);
        WS(weakSelf);
        _footView.footAction = ^(NSInteger index) {
            if (index==999) {
                NSLog(@"保存进度");
                [weakSelf saveAction];
            } if (index==1000) {
                NSLog(@"完成服务");
                [weakSelf finishAction];
            }
        };
    }
    return _footView;
}
- (void)dealloc{
    [[LocationManager shareInstance] removeObserver:self forKeyPath:@"locationModel" context:nil];
    // Dispose of any resources that can be recreated.
}
@end
