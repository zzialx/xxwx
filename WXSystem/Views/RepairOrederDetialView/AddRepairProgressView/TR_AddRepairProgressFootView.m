//
//  TR_AddRepairProgressFootView.m
//  WXSystem
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_AddRepairProgressFootView.h"

@implementation TR_AddRepairProgressFootView
- (IBAction)saveServiceAction:(id)sender {
    BLOCK_EXEC(self.footAction,999);
}
- (IBAction)finishServiceAction:(id)sender {
    BLOCK_EXEC(self.footAction,1000);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
