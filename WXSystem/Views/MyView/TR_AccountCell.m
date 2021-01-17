//
//  TR_AccountCell.m
//  WXSystem
//
//  Created by candy.chen on 2019/2/15.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_AccountCell.h"

@interface TR_AccountCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation TR_AccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updatePersonView:(NSString *)subtitle
{
    self.subTitleLabel.text = MakeStringNotNil(subtitle);
}

 - (void)updateAccountModel:(TR_MyViewModel *)model atIndexPath:(NSIndexPath *)indexPath cellType:(NSString *)cellType
{
    TR_MyViewModel *viewModel = (TR_MyViewModel *)model;
    NSArray *rowArray = viewModel.titleArray[indexPath.section];
    self.titleLabel.text = rowArray[indexPath.row];
    if ([cellType isEqualToString:@"kCellTypeAbout"]) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"版本%@",kBundleVersionString];;
    } else if ([cellType isEqualToString:@"kCellTypeClear"]){
        NSUInteger bytesCache = [[TR_YYCache shareCache]getCacheCount];
        NSUInteger cacheCount = bytesCache;
        CGFloat tmpSize = cacheCount / 1024;
        NSString *clearCacheName = tmpSize >= 1024 ? [NSString stringWithFormat:@"%.2f M",tmpSize/1024] : [NSString stringWithFormat:@"%.2fKB",tmpSize];
        self.subTitleLabel.text = clearCacheName;
    } else {
         self.subTitleLabel.text = @"";
    }
}

@end
