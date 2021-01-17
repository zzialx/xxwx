//
//  TR_FormAddViewController.m
//  OASystem
//
//  Created by candy.chen on 2019/4/12.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_FormAddViewController.h"
#import "SWFormItem.h"
#import "SWFormSectionItem.h"
#import "SWFormHandler.h"
#import "SWFormCompat.h"
#import "TR_FormSelectDateView.h"
#import "TR_FormSelectTimeView.h"
#import "TR_FormSelectSingleView.h"
#import "TR_FormSelectMultiView.h"
#import "TR_FormSelectModel.h"
#import "TR_FormDarpartMentVC.h"
#import "TR_AddressBookModel.h"
#import "TR_FormMultiPeopleVC.h"
#import "TR_AddressBookViewModel.h"
#import "TR_FormViewModel.h"

@interface TR_FormAddViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) SWFormItem *rule;
@property (nonatomic, strong) SWFormItem *input;
@property (nonatomic, strong) SWFormItem *textViewInput;
@property (nonatomic, strong) SWFormItem *money;
@property (nonatomic, strong) SWFormItem *number;
@property (nonatomic, strong) SWFormItem *date;
@property (nonatomic, strong) SWFormItem *startEnd;
@property (nonatomic, strong) SWFormItem *singleSelect;
@property (nonatomic, strong) SWFormItem *muchSelect;
@property (nonatomic, strong) SWFormItem *userSelect;
@property (nonatomic, strong) SWFormItem *departmentSelect;
@property (nonatomic, strong) SWFormItem *design;
@property (nonatomic, strong) SWFormItem *detailSelect;
@property (nonatomic, strong) SWFormItem *CCListSelect;
@property (nonatomic, strong) SWFormItem *image;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) TR_FormSelectDateView *selectDateView;
@property (nonatomic, strong) TR_FormSelectTimeView *selectTimeView;
@property (nonatomic, strong) TR_FormSelectSingleView *selectSingleView;
@property (nonatomic, strong) TR_FormSelectMultiView *selectMultiView;
@end

@implementation TR_FormAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView setTitle:@"申请"];
    self.formTableView.frame = CGRectMake(0, CGRectGetMaxY(self.navView.frame), KScreenWidth, KScreenHeight - STATUS_AND_NAVIGATION_HEIGHT - 50-kSafeAreaBottomHeight - 60);
    // Do any additional setup after loading the view.
    self.genders = @[@"男",@"女"];
    [self datas];
    NSDictionary *dic = @{@"id":@"43449d70-b3a9-4509-a827-fc41ed68ce87"};
    [[TR_FormViewModel defaultFormVM]formDetail:dic completionBlock:^(BOOL flag, NSString *error) {
        if (flag) {
            
        } else {
        }
    }];
}

/**
 数据源处理
 */
- (void)datas {
    WS(weakSelf);
    NSMutableArray *items = [NSMutableArray array];
    self.rule = SWFormItem_Add(@"", @"填表说明  \n (1)请假1天以内（含），经部门经理审批 \n (2)请假2天-3天以内（含），经分管领导、子分公司，办事处 第一负责人审批 \n (3)请假4天及以上，经董事长审批 \n (4)病假：需出示三甲以上医院就诊病历或休假证明", SWFormItemTypeRule, NO, NO, UIKeyboardTypeDefault);
    self.rule.showLength = YES;
    [items addObject:self.rule];
    
    self.input = SWFormItem_Add(@"标题", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeDefault);
    self.input.maxInputLength = 200;
    [items addObject:self.input];
    
    self.textViewInput = SWFormItem_Add(@"内容", nil, SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    self.textViewInput.maxInputLength = 400;
    [items addObject:self.textViewInput];
    
    self.money = SWFormItem_Add(@"金额", nil, SWFormItemTypeMoney, YES, YES, UIKeyboardTypeNumberPad);
    self.money.maxInputLength = 16;
    [items addObject:self.money];
    
    self.number = SWFormItem_Add(@"数字输入", nil, SWFormItemTypeNumber, YES, YES, UIKeyboardTypeNumberPad);
    self.number.maxInputLength = 16;
    [items addObject:self.number];
    
    self.date = SWFormItem_Add(@"日期", nil, SWFormItemTypeDate, NO, YES, UIKeyboardTypeDefault);
    self.date.itemSelectCompletion = ^(SWFormItem *item) {
        [weakSelf.selectDateView showChannelChooseView:[NSArray array]];
        weakSelf.selectDateView.selectDateBlock = ^(NSString *info, NSString *error) {
             weakSelf.date.info = info;
             [weakSelf.formTableView reloadData];
        };
    };
    [items addObject:self.date];
    
    self.startEnd = SWFormItem_Add(@"开始时间", nil, SWFormItemTypeStartEnd, YES, YES, UIKeyboardTypeDefault);
    self.startEnd.itemSelectCompletion = ^(SWFormItem *item) {
        [weakSelf.formTableView reloadData];
    };
    [items addObject:self.startEnd];
    TR_FormSelectModel *model1 = [[TR_FormSelectModel alloc]init];
    model1.label = @"南京归途晒跑1";
    model1.value = @"1";
    model1.formSelect = @"0";
    TR_FormSelectModel *model2 = [[TR_FormSelectModel alloc]init];
    model2.label = @"南京归途晒跑2";
    model2.value = @"2";
    model2.formSelect = @"0";
    TR_FormSelectModel *model3 = [[TR_FormSelectModel alloc]init];
    model3.label = @"南京归途晒跑3";
    model3.value = @"3";
    model3.formSelect = @"0";
    NSMutableArray *array = [NSMutableArray arrayWithObjects:model1,model2,model3, nil];
    self.singleSelect = SWFormItem_Add(@"单选", nil, SWFormItemTypeSingleSelect, YES, YES, UIKeyboardTypeDefault);
    self.singleSelect.itemSelectCompletion = ^(SWFormItem *item) {
        [weakSelf.selectSingleView showChannelChooseView:array];
        weakSelf.selectSingleView.singleBlock = ^(TR_Model *model, NSString *error) {
            TR_FormSelectModel *selectModel = (TR_FormSelectModel *)model;
            weakSelf.singleSelect.info = selectModel.label;
            [weakSelf.formTableView reloadData];
        };
     };
    [items addObject:self.singleSelect];
    
    self.muchSelect = SWFormItem_Add(@"多选", nil, SWFormItemTypeMuchSelect, YES, YES, UIKeyboardTypeDefault);
    TR_FormSelectModel *model11 = [[TR_FormSelectModel alloc]init];
    model11.label = @"南京归途晒跑1";
    model11.value = @"11";
    model11.formSelect = @"0";
    TR_FormSelectModel *model12 = [[TR_FormSelectModel alloc]init];
    model12.label = @"南京归途晒跑2";
    model12.value = @"12";
    model12.formSelect = @"0";
    TR_FormSelectModel *model13 = [[TR_FormSelectModel alloc]init];
    model13.label = @"南京归途晒跑3";
    model13.value = @"13";
    model13.formSelect = @"0";
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:model11,model12,model13, nil];
    self.muchSelect.itemSelectCompletion = ^(SWFormItem *item) {
         [weakSelf.selectMultiView showChannelChooseView:array1];
        weakSelf.selectMultiView.blockCity = ^(NSMutableArray *models, NSString *error) {
            weakSelf.muchSelect.info = [models componentsJoinedByString:@";"];
            [weakSelf.formTableView reloadData];
        };
    };
    [items addObject:self.muchSelect];
    
    self.userSelect = SWFormItem_Add(@"用户", nil, SWFormItemTypeUserSelect, YES, YES, UIKeyboardTypeDefault);
    self.userSelect.itemSelectCompletion = ^(SWFormItem *item) {
        TR_AddressBookViewModel *viewModel = [TR_AddressBookViewModel shareViewModel];
        [viewModel clearAllSelectInfo];
        TR_FormMultiPeopleVC *people = [[TR_FormMultiPeopleVC alloc]init];
        people.finishSelectMember = ^(NSArray * _Nonnull selectMemberArray) {
             weakSelf.userSelect.images = [NSMutableArray arrayWithArray:selectMemberArray];
             [weakSelf.formTableView reloadData];
        };
         [weakSelf presentViewController:people animated:YES completion:nil];
    };
    [items addObject:self.userSelect];
    
    self.departmentSelect = SWFormItem_Add(@"部门", nil, SWFormItemTypeDepartmentSelect, YES, YES, UIKeyboardTypeDefault);
    [items addObject:self.departmentSelect];
    self.departmentSelect.itemSelectCompletion = ^(SWFormItem *item) {
        TR_FormDarpartMentVC * mentVC = [[TR_FormDarpartMentVC alloc]init];
        mentVC.type = TR_DARPARTMENTHEAD_TYPE_MORE;
        mentVC.darpartBlock = ^(NSMutableArray *models, NSString *error) {
            NSMutableArray *array = [NSMutableArray array];
            for (TR_AddressBookModel *bookModel in models) {
                [array addObject:bookModel.name];
            }
            NSString *string = [array componentsJoinedByString:@";"];
            weakSelf.departmentSelect.info = string;
            [weakSelf.formTableView reloadData];
        };
        [weakSelf presentViewController:mentVC animated:YES completion:nil];
    };
    self.design = SWFormItem_Add(@"计算公式", nil, SWFormItemTypeDesign, YES, NO, UIKeyboardTypeDefault);
    [items addObject:self.design];
    self.detailSelect = SWFormItem_Add(@"明细", nil, SWFormItemTypeDetailSelect, YES, YES, UIKeyboardTypeDefault);
    [items addObject:self.detailSelect];
    
   
    
    self.image = SWFormItem_Add(@"上传附件", nil, SWFormItemTypeImage, YES, NO, UIKeyboardTypeDefault);
//    self.image.images = @[@"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg", @"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg",@"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg", @"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg"@"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg", @"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg"];
    self.image.images = @[].mutableCopy;
    [items addObject:_image];
    
    self.CCListSelect = SWFormItem_Add(@"添加抄送人", nil, SWFormItemTypeCCListSelect, YES, NO, UIKeyboardTypeDefault);
    //    self.CCListSelect.images = @[@"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg", @"http://192.168.2.11:19080/tea/3/1/d286069b-1797-49db-82c9-7cdc6905d192.jpg"];
    self.CCListSelect.images = @[].mutableCopy;
    [items addObject:self.CCListSelect];
    
    SWFormSectionItem *sectionItem = SWSectionItem(items);
        sectionItem.headerHeight = 0.01;
    //    sectionItem.footerView = [self footerView];
    //    sectionItem.footerHeight = 80;
    [self.mutableItems addObject:sectionItem];
}

- (void)chooseAction:(UIButton *)sender
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10) {
        if (buttonIndex != 0) {
            self.singleSelect.info = self.genders[buttonIndex-1];
            [self.formTableView reloadData];
        }
    }
}

- (UIButton *)sureButton
{
    if (IsNilOrNull(_sureButton)) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(16,CGRectGetMaxY(self.formTableView.frame), KScreenWidth - 32,60);
        _sureButton.backgroundColor = [UIColor tr_colorwithHexString:@"#4C9FFF"];
        [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (TR_FormSelectDateView *)selectDateView
{
    if(IsNilOrNull(_selectDateView)) {
        _selectDateView = [[TR_FormSelectDateView alloc]initWithFrame:self.view.frame];
    }
    return _selectDateView;
}

- (TR_FormSelectTimeView *)selectTimeView
{
    if(IsNilOrNull(_selectTimeView)) {
        _selectTimeView = [[TR_FormSelectTimeView alloc]initWithFrame:self.view.frame];
    }
    return _selectTimeView;
}

- (TR_FormSelectSingleView *)selectSingleView
{
    if(IsNilOrNull(_selectSingleView)) {
        _selectSingleView = [[TR_FormSelectSingleView alloc]initWithFrame:self.view.frame];
    }
    return _selectSingleView;
}

- (TR_FormSelectMultiView *)selectMultiView
{
    if(IsNilOrNull(_selectMultiView)) {
        _selectMultiView = [[TR_FormSelectMultiView alloc]initWithFrame:self.view.frame];
    }
    return _selectMultiView;
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
