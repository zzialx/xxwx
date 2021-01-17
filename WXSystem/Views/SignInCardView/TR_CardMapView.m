//
//  TR_CardMapView.m
//  WXSystem
//
//  Created by admin on 2019/6/27.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_CardMapView.h"

@interface TR_CardMapView ()<MAMapViewDelegate>

@property(nonatomic,strong)NSArray * companyList;
@property(nonatomic,strong)UIButton * locationBtn;
@end

@implementation TR_CardMapView
- (instancetype)initWithFrame:(CGRect)frame withCompanyList:(NSArray*)companyList{
    self = [super initWithFrame:frame];
    if (self) {
        _companyList = companyList;
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    [self addSubview:self.mapView];
    [self locationBtn];
//    [self initAnnotations];
    //更新小蓝点
    if (_companyList==nil) {
          [self updateLoaction];
    }
}
- (void)setMapLocationLongitude:(NSString*)longitude  latitude:(NSString*)latitude level:(NSInteger)level{
     MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);
    a1.title=@"";
    self.mapView.zoomLevel=level;
    [self.mapView addAnnotation:a1];
    [self.mapView selectAnnotation:a1 animated:YES];
}

- (void)updateLoaction{
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = YES;
    r.showsHeadingIndicator = NO;
//    r.fillColor = [UIColor orangeColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
//    r.strokeColor = [UIColor blueColor];
    r.lineWidth = 0;///精度圈 边线宽度，默认0
    r.enablePulseAnnimation = YES;
    r.image = [UIImage imageNamed:@"mine_location"];
    [self.mapView updateUserLocationRepresentation:r];
}
/**
 设置大头针
 */
- (void)initAnnotations
{
    //添加多个点
//    for (int i = 0 ; i<self.companyList.count; i++) {

//    }
}
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame: self.bounds];
        _mapView.delegate=self;
        // 显示比例尺
        _mapView.showsScale = NO;
        // 显示指南针
        _mapView.showsCompass = NO;
        // 显示定位蓝点
        _mapView.showsUserLocation = YES;
        // 用户定位模式
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        // 设置缩放级别
        [_mapView setZoomLevel:17];
    }
    return _mapView;
}
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    CLLocationCoordinate2D coord = [userLocation coordinate];
//    NSLog(@"经度:%f,纬度:%f",coord.latitude,coord.longitude);
//}
/**
 获取地图中心点位置
 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MACoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    self.latitude = centerCoordinate.latitude;
    self.longitude = centerCoordinate.longitude;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            NSDictionary * location = [place addressDictionary];
            self.address=[NSString stringWithFormat:@"%@%@%@%@",[location objectForKey:@"State"],place.locality,place.subLocality,place.name];
            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
            NSLog(@"城市：%@",[location objectForKey:@"State"]);
            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            NSLog(@"位置：%@", place.name);
            NSLog(@"国家：%@", place.country);
            NSLog(@"城市：%@", place.locality);
            NSLog(@"区：%@", place.subLocality);
            NSLog(@"街道：%@", place.thoroughfare);
            NSLog(@"子街道：%@", place.subThoroughfare);
            }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(updateCurrentAddress:)]) {
            [self.delegate updateCurrentAddress:self.address];
        }
    }];
   
}
/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier1";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"mine_location"] ;
        UILabel *  titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, annotationView.width, annotationView.height)];
        titleLab.text = @"";
        titleLab.font=FONT_TEXT(12);
        titleLab.textColor=UIColor.whiteColor;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [annotationView addSubview:titleLab];
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        // 设置标记点的图片
         annotationView.image = [UIImage imageNamed:@"mine_location"] ;
        
        UILabel *  titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, annotationView.width, annotationView.height)];
        titleLab.text = annotation.title;
        titleLab.font=FONT_TEXT(12);
        titleLab.textColor=UIColor.whiteColor;
        titleLab.textAlignment=NSTextAlignmentCenter;
        [annotationView addSubview:titleLab];
        
//        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, annotationView.width+20, annotationView.height+20)];
//        bgView.backgroundColor=UICOLOR_RGBA(76, 159, 255);
//        bgView.alpha=0.2;
//        bgView.layer.cornerRadius=(annotationView.width+20)/2;
//        bgView.layer.masksToBounds=YES;
//        [annotationView addSubview:bgView];
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        // annotationView.centerOffse =
        
        return annotationView;
    }
    return nil;
}
- (UIButton*)locationBtn{
    if (IsNilOrNull(_locationBtn)) {
        _locationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_locationBtn];
        _locationBtn.sd_layout.rightSpaceToView(self, 7)
        .bottomSpaceToView(self, 7)
        .widthIs(40)
        .heightIs(40);
        _locationBtn.backgroundColor=UIColor.whiteColor;
        [_locationBtn setImage:[UIImage imageNamed:@"location_new"] forState:UIControlStateNormal];
        [_locationBtn setImageEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
        [_locationBtn addTarget:self action:@selector(againLoactionAction) forControlEvents:UIControlEventTouchUpInside];
        _locationBtn.layer.cornerRadius=4;
        _locationBtn.layer.masksToBounds=YES;
    }
    return _locationBtn;
}
- (void)againLoactionAction{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(getMapMineCenter)]) {
        [self.delegate getMapMineCenter];
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
