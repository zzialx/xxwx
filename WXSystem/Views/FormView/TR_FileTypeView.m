//
//  TR_FileTypeView.m
//  WXSystem
//
//  Created by admin on 2019/8/12.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_FileTypeView.h"


@implementation TR_FileTypeView
- (IBAction)openApp:(id)sender {
    if (self.openOtherFile) {
        self.openOtherFile();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
