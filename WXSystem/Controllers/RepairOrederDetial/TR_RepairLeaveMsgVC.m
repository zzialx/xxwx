//
//  TR_RepairLeaveMsgVC.m
//  WXSystem
//
//  Created by admin on 2019/11/15.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairLeaveMsgVC.h"
#import "TR_WriteDailyContentCell.h"
#import "TR_WriteDailyImageCell.h"
#import "TR_RepairDetialViewModel.h"
#import "TR_FormImageModel.h"

@interface TR_RepairLeaveMsgVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *writeTableView;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic)TR_RepairDetialViewModel * viewModel;
@end


@implementation TR_RepairLeaveMsgVC
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navView setTitle:@"留言"];
    self.view.backgroundColor=UIColor.whiteColor;
    self.imageArray = [[NSMutableArray alloc]init];
    _writeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _writeTableView.dataSource = self;
    _writeTableView.delegate = self;
    _writeTableView.showsVerticalScrollIndicator = NO;
    _writeTableView.showsHorizontalScrollIndicator = NO;
    _writeTableView.backgroundColor = [UIColor whiteColor];
    _writeTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_writeTableView];
    _writeTableView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.navView, 0)
    .heightIs(KScreenHeight-KNAV_HEIGHT-52);
    [self.view addSubview:self.sureButton];
    if (@available(iOS 11.0, *)) {
        _writeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark -- TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    if (indexPath.section == 0) {
        static NSString *textViewInput_cell_id = @"TR_WriteDailyContentCell";
        TR_WriteDailyContentCell *cell = [tableView contentCellWithId:textViewInput_cell_id];
        [cell updateContentItem:self.content];
        cell.contentBlock = ^(NSString *text,NSString *error) {
            weakSelf.content = text;
            [weakSelf updateFootState];
        };
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *image_cell_id = @"TR_WriteDailyImageCell";
        TR_WriteDailyImageCell *cell = [tableView leavelImageCellWithId:image_cell_id];
        [cell updateImageArray:self.imageArray];
        cell.imageCompletion = ^(NSArray *images, NSString *error) {
            weakSelf.imageArray = [NSMutableArray arrayWithArray:images];
             [weakSelf updateFootState];
            [UIView performWithoutAnimation:^{
                NSInteger row = indexPath.row;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        return cell;
    }
    return [UITableViewCell new];
}
- (void)updateFootState{
    if (self.content.length>0||self.imageArray.count>0) {
        self.sureButton.backgroundColor = BLUECOLOR;
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled=YES;
    }else{
        self.sureButton.backgroundColor = UICOLOR_RGBA(242, 242, 242);
        [self.sureButton setTitleColor:UICOLOR_RGBA(153, 153, 153) forState:UIControlStateNormal];
        self.sureButton.userInteractionEnabled=NO;
    }
    
}
#pragma mark -- TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [TR_WriteDailyContentCell heightWithItem];
    } else{
        return [TR_WriteDailyImageCell heightWithItem:self.imageArray];
    }
}

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

- (void)chooseAction:(BOOL)isAddDraft{
    NSLog(@"完成留言");
    NSMutableArray * picUrls = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * miniPicUrls = [NSMutableArray arrayWithCapacity:0];
    for (TR_FormImageModel * imgModel in self.imageArray) {
        [picUrls addObject:imgModel.url];
        [miniPicUrls addObject:imgModel.miniurl];
    }
    NSDictionary * parameter = @{@"orderId":MakeStringNotNil(self.repairOrderID),
                                 @"messageInfo":MakeStringNotNil(self.content),
                                 @"picUrls":picUrls,
                                 @"miniPicUrls":miniPicUrls
                                 };
    WS(weakSelf);
    [self.viewModel addRepairLeavelMessage:parameter completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            [TRHUDUtil showMessageWithText:@"留言成功"];
            BLOCK_EXEC(weakSelf.reloadVC);
            [weakSelf.navigationController popViewControllerAnimated:YES];
           
        }else{
            [TRHUDUtil showMessageWithText:error];
        }
    }];
}
- (UIButton *)sureButton
{
    if (IsNilOrNull(_sureButton)) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(16,KScreenHeight - 44-kSafeAreaBottomHeight - 10 , KScreenWidth - 32,44);
        _sureButton.backgroundColor=UICOLOR_RGBA(242, 242, 242);
        [_sureButton setTitleColor:UICOLOR_RGBA(153, 153, 153) forState:UIControlStateNormal];
        _sureButton.userInteractionEnabled=NO;
        [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        _sureButton.layer.cornerRadius = 4.0f;
        [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.timeInterval = 2.0f;
    }
    return _sureButton;
}
- (TR_RepairDetialViewModel*)viewModel{
    if (IsNilOrNull(_viewModel)) {
        _viewModel = [[TR_RepairDetialViewModel alloc]init];
    }
    return _viewModel;
}
@end
