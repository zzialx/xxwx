//
//  CustomShareView.h
//  SuiYangApp
//
//  Created by isaac on 2017/12/22.
//  Copyright © 2017年 zzialx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomShareDelegate <NSObject>

-(void)cancelCustomView;
-(void)shareWithOtherApp:(NSInteger)appType;

@end

@interface CustomShareView : UIWindow
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, assign) id delegate;
@property(nonatomic,assign)BOOL isMinePublish;
@property(nonatomic,assign)id shareData;
- (void)setIsMinePublish:(BOOL)isMinePublish isHaveCollected:(BOOL)isCollected;
@end
