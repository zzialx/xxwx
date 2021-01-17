//
//  TR_NODateView.h
//  HouseProperty
//
//  Created by zzialx on 2019/2/12/13.
//  Copyright © 2018年 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TR_NODateView : UIView
@property(nonatomic,strong)UIImageView *noDataImg;
@property(nonatomic,strong)UILabel *noDataLab;
- (instancetype)initWithFrame:(CGRect)frame type:(NO_DATATYPE)type;
- (instancetype)setNoDataType:(NO_DATATYPE )type;
@end
