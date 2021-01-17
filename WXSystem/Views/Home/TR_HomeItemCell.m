//
//  TR_HomeItemCell.m
//  WXSystem
//
//  Created by admin on 2019/11/11.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_HomeItemCell.h"

@interface TR_HomeItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation TR_HomeItemCell
- (void)showCellItem:(NSString*)item number:(NSString*)number{
    self.titleLab.text = item;
    if([item isEqualToString:@"待我接单"]){
        self.numberLab.text=number;
        self.bgView.image=[UIImage imageNamed:@"wait_order"];
    }else if ([item isEqualToString:@"待我服务"]){
        self.numberLab.text=number;
        self.bgView.image=[UIImage imageNamed:@"wait_service"];
    }else if ([item isEqualToString:@"待我完成"]){
        self.bgView.image=[UIImage imageNamed:@"wait_finish"];
        self.numberLab.text=number;
    }else if ([item isEqualToString:@"逾期工单"]){
        self.numberLab.text=number;
        self.bgView.image=[UIImage imageNamed:@"wait_out"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
