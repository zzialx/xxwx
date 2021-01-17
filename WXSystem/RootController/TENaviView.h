//
//  TENaviView.h
//  TeaExchange
//
//  Created by isaac on 2019/2/12.
//  Copyright © 2018年 isaac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TENaviView : UIView
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIImageView *leftImg,*rightImg;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *titleImg;
@property (strong,nonatomic) UILabel *lblLeft;
@property (strong,nonatomic) UILabel *lblBottom;
-(void)setLeftImg:(NSString *)leftImg rightImg:(NSString *)rigthImg title:(NSString *)title;
-(void)setLeftImg:(NSString *)leftImg title:(NSString *)title bgColor:(UIColor *)navColor;
-(void)setLeftImg:(NSString *)leftImg title:(NSString *)title rightBtnName:(NSString *)name;
-(void)setLeftImg:(NSString *)leftImg title:(NSString *)title;
-(void)setTitle:(NSString *)title;
@end
