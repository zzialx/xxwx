//
//  YH_PhotoGroupPickerView.m
//  YH_Community
//
//  Created by candy.chen on 18/7/8.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import "YH_PhotoGroupPickerView.h"
#import "AssetHelper.h"

#pragma mark - YH_PhotoGroupPickerView

@interface YH_PhotoGroupPickerView()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString *groupId;

@end

@implementation YH_PhotoGroupPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)updateWithAssetsGroupId:(NSString *)groupId
{
    self.groupId = groupId;
    //更新相册数据
    WS(weakSelf);
    [ASSETHELPER getGroupList:^(NSArray *grouplist) {
        //展开动画
        [weakSelf openPickerView];
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    //隐藏页面
    [self closePickerView];
    BLOCK_EXEC(self.selectBlock, nil, nil);
}

- (void)openPickerView
{
    CGFloat height = [ASSETHELPER getGroupCount] * 62.5f;
    height = MIN(height, CGRectGetHeight(self.bounds));
    [self.tableView setFrame:CGRectMake(0, -height, CGRectGetWidth(self.bounds), height)];
    [self setHidden:NO];
    [self.backgroundView setAlpha:0];
    [self.tableView reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.tableView.frame = frame;
        [self.backgroundView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closePickerView
{
    [UIView animateWithDuration:0.25 animations:^{
//        [self.tableView yh_setY:-(CGRectGetHeight(self.tableView.frame))];
        CGRect frame = self.frame;
        frame.origin.y = -CGRectGetHeight(self.tableView.frame);
        self.tableView.frame = frame;
        [self.backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ASSETHELPER getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YH_PhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YH_PhotoGroupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *groupInfo = [ASSETHELPER getGroupInfo:indexPath.row];
    [cell updateWithAssetsGroupInfo:groupInfo];
    
    if ([self.groupId isEqualToString:[groupInfo objectForKey:@"groupid"]]) {
        cell.backgroundColor = [UIColor tr_colorwithHexString:@"#f0f0f0"];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *selectGroup = [ASSETHELPER getGroupAtIndex:indexPath.row];
    
    [self closePickerView];
    BLOCK_EXEC(self.selectBlock, selectGroup, nil);
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[YH_PhotoGroupCell class] forCellReuseIdentifier:@"YH_PhotoGroupCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.scrollsToTop = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    return _backgroundView;
}

@end

#pragma mark - YH_PhotoGroupCell

@interface YH_PhotoGroupCell()

@property (strong, nonatomic) UIImageView *postImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation YH_PhotoGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.postImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)updateWithAssetsGroupInfo:(NSDictionary *)groupInfo
{
    UIImage *postImage = [groupInfo objectForKey:@"post"];
    NSString *name = [groupInfo objectForKey:@"name"];
    NSInteger count = [[groupInfo objectForKey:@"count"] integerValue];
    self.postImageView.image = postImage;
    self.nameLabel.text = [NSString stringWithFormat:@"%@  (%ld)", name, (long)count];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.postImageView.frame = CGRectMake(10.0f, 6.0f, CGRectGetHeight(self.bounds)-12.0f, CGRectGetHeight(self.bounds)-12.0f);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.postImageView.frame) + 15.0f, 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.postImageView.frame) - 25.0f, CGRectGetHeight(self.bounds));
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5f, CGRectGetWidth(self.bounds), 0.5f);
}

#pragma mark - Getter

- (UIImageView *)postImageView
{
    if (!_postImageView) {
        _postImageView = [[UIImageView alloc] init];
    }
    return _postImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor tr_colorwithHexString:@"#e5e5e5"];
    }
    return _bottomLine;
}

@end
