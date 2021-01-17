//
//  NewsHeaderCollectionViewCell.h
//  SuiYangApp
//
//  Created by isaac on 2018/1/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TR_NoticeColModel.h"

@interface NewsHeaderCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblLine;
@property (nonatomic, retain) TR_NoticeColModel *model;
@end
