//
//  TR_CardMapView.h
//  WXSystem
//
//  Created by admin on 2019/6/27.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TR_CardMapViewDelegate<NSObject>
@optional
- (void)updateCurrentAddress:(NSString*)currentAddress;
//回归定位中心
- (void)getMapMineCenter;

@end



@interface TR_CardMapView : UIView
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)NSString * address;///<地理位置
@property (nonatomic, assign) CGFloat latitude;///<纬度
@property (nonatomic, assign) CGFloat longitude;///<经度
@property (nonatomic, weak) id<TR_CardMapViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withCompanyList:(NSArray*)companyList;

- (void)setMapLocationLongitude:(NSString*)longitude  latitude:(NSString*)latitude level:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
