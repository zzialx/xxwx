//
//  TR_SearchBar.m
//  WXSystem
//
//  Created by zzialx on 2019/2/13.
//  Copyright © 2019年 candy.chen. All rights reserved.
//

#import "TR_SearchBar.h"

@interface TR_SearchBar ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBg;

@end

@implementation TR_SearchBar
- (void)awakeFromNib{
    [super awakeFromNib];
    self.searchBg.layer.cornerRadius = 16;
    self.searchBg.clipsToBounds=YES;
    self.searchTF.delegate=self;
    self.searchTF.returnKeyType=UIReturnKeySearch;
     [ self.searchTF addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)cancleSearchAction:(UIButton *)sender {
    if (self.back) {
        self.back();
    }
}
-(void)textContentChanged:(UITextField*)textFiled{
    UITextRange * selectedRange = [textFiled markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        if (self.searchPerson) {
            self.searchPerson(textFiled.text);
        }
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.searchTF resignFirstResponder];
//    if (self.searchPerson) {
//        self.searchPerson(textField.text);
//    }
//    return YES;
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
