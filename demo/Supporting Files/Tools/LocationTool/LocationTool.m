//
//  LocationTool.m
//  定位_demo
//
//  Created by liman on 1/14/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import "LocationTool.h"

@implementation LocationTool

+ (LocationTool *)sharedInstance
{
    static LocationTool *__singletion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
        [__singletion setCLLocationManager];
    });
    
    return __singletion;
}

#pragma mark - tool
//设置定位参数
- (void)setCLLocationManager
{
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
    }
    if (!_locationManager.delegate) {
        _locationManager.delegate = self;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];//设置定位权限 仅ios8有意义
    }
    
    
    /*
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;/// 设定定位精度。默认为kCLLocationAccuracyBest。
    _locationManager.headingFilter = 1;/// 设定最小更新角度。默认为1度，设定为kCLHeadingFilterNone会提示任何角度改变。
    _locationManager.activityType = CLActivityTypeOther;
    _locationManager.distanceFilter = 10;/// 设定定位的最小更新距离。默认为kCLDistanceFilterNone
    _locationManager.pausesLocationUpdatesAutomatically = NO;/// 指定定位是否会被系统自动暂停。默认为YES。只在iOS 6.0之后起作用。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _locationManager.allowsBackgroundLocationUpdates = YES;///指定定位：是否允许后台定位更新。默认为NO。只在iOS 9.0之后起作用。设为YES时，Info.plist中 UIBackgroundModes 必须包含 "location"
    }
     */
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];//提示:采用默认的定位精度（kCLLocationAccuracyBest），获取到的定位点偏差较小，但是请求耗时较多（10s左右），建议按照业务需求设置定位精度，推荐:kCLLocationAccuracyHundredMeter，偏差在100米以内，耗时在2-3s。
    [_locationManager setDistanceFilter:100];//提示:通过设置distance filter可以实现当位置改变超出一定范围时Location Manager才调用相应的代理方法。这样可以达到省电的目的。
}

#pragma mark - public

/**
 *  开始定位
 */
- (void)startUpdatingLocation:(id<LocationToolDelegate>)delegate
{
    if (![CLLocationManager locationServicesEnabled]) {
        return;//定位不可用
    }
    
    _delegate = delegate;
    
    [self setCLLocationManager];
    [_locationManager startUpdatingLocation];
}

/**
 *  停止定位
 */
- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

/**
 *  百度地图 逆地理编码
 */
/*
- (void)baiduReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(BMKReverseGeoCodeResult *result))successBlock failure:(void (^)(BMKSearchErrorCode errorCode))failureBlock
{
    CLLocation *location2 = nil;
    if (type == CoordType_WGS84) {//GPS坐标
        location2 = [[location locationEarthToMars] locationMarsToBaidu];
    }
    if (type == CoordType_GCJ02) {//火星坐标
        location2 = [location locationMarsToBaidu];
    }
    if (type == CoordType_BD09) {//百度坐标
        location2 = location;
    }
    
    
    if (!_baiduGeoCodeSearch) {
        _baiduGeoCodeSearch = [BMKGeoCodeSearch new];
    }
    if (!_baiduGeoCodeSearch.delegate) {
        _baiduGeoCodeSearch.delegate = self;
    }
    
    
    if (!_baiduReverseGeoCodeOption) {
        _baiduReverseGeoCodeOption = [BMKReverseGeoCodeOption new];
    }
    _baiduReverseGeoCodeOption.reverseGeoPoint = location2.coordinate;
    [_baiduGeoCodeSearch reverseGeoCode:_baiduReverseGeoCodeOption];
    
    
    _baiduSuccessBlock = successBlock;
    _baiduFailureBlock = failureBlock;
}
 */

/**
 *  高德地图 逆地理编码
 */
- (void)gaodeReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(AMapReGeocodeSearchResponse *response))successBlock failure:(void (^)(NSError *error))failureBlock
{
    CLLocation *location2 = nil;
    if (type == CoordType_WGS84) {//GPS坐标
        location2 = [location locationEarthToMars];
    }
    if (type == CoordType_GCJ02) {//火星坐标
        location2 = location;
    }
    if (type == CoordType_BD09) {//百度坐标
        location2 = [location locationBaiduToMars];
    }
    
    
    if (!_gaodeSearchAPI) {
        _gaodeSearchAPI = [AMapSearchAPI new];
        _gaodeSearchAPI.language = AMapSearchLanguageZhCN;
    }
    if (!_gaodeSearchAPI.delegate) {
        _gaodeSearchAPI.delegate = self;
    }
    
    
    if (!_gaodeReGeocodeSearchRequest) {
        _gaodeReGeocodeSearchRequest = [AMapReGeocodeSearchRequest new];
    }
    _gaodeReGeocodeSearchRequest.location = [AMapGeoPoint locationWithLatitude:location2.coordinate.latitude longitude:location2.coordinate.longitude];
    [_gaodeSearchAPI AMapReGoecodeSearch:_gaodeReGeocodeSearchRequest];
    
    
    _gaodeSuccessBlock = successBlock;
    _gaodeFailureBlock = failureBlock;
}

/**
 *  苹果地图 逆地理编码
 */
- (void)appleReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(NSArray<CLPlacemark *> *placemarks))successBlock failure:(void (^)(NSError *error))failureBlock
{
    CLLocation *location2 = nil;
    if (type == CoordType_WGS84) {//GPS坐标
        location2 = location;
    }
    if (type == CoordType_GCJ02) {//火星坐标
        NSError *error = [NSError errorWithDomain:@""
                                             code:0
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey:@"苹果地图 只支持GPS坐标, 不支持火星坐标"
                                                    }];
        failureBlock(error);
        return;
    }
    if (type == CoordType_BD09) {//百度坐标
        NSError *error = [NSError errorWithDomain:@""
                                             code:0
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey:@"苹果地图 只支持GPS坐标, 不支持百度坐标"
                                                    }];
        failureBlock(error);
        return;
    }
    
    
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    
    
    [_geocoder reverseGeocodeLocation:location2 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error)
        {
            failureBlock(error);
        }
        else
        {
            successBlock(placemarks);
        }
    }];
}

/**
 *  谷歌地图 逆地理编码
 */
/*
- (void)googleReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(GMSReverseGeocodeResponse *response))successBlock failure:(void (^)(NSError *error))failureBlock
{
    CLLocation *location2 = nil;
    if (type == CoordType_WGS84) {//GPS坐标
        location2 = location;
    }
    if (type == CoordType_GCJ02) {//火星坐标
        NSError *error = [NSError errorWithDomain:@""
                                             code:0
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey:@"谷歌地图 只支持GPS坐标, 不支持火星坐标"
                                                    }];
        failureBlock(error);
        return;
    }
    if (type == CoordType_BD09) {//百度坐标
        NSError *error = [NSError errorWithDomain:@""
                                             code:0
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey:@"谷歌地图 只支持GPS坐标, 不支持百度坐标"
                                                    }];
        failureBlock(error);
        return;
    }
    
    
    if (!_googleGeocoder) {
        _googleGeocoder = [GMSGeocoder new];
    }
    
    
    [_googleGeocoder reverseGeocodeCoordinate:location2.coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error)
        {
            failureBlock(error);
        }
        else
        {
            successBlock(response);
        }
    }];
}
 */

/**
 *  判断国内外 
 *  港澳台取决于用的是高德还是tomtom
 */
- (void)judge:(CLLocation *)location result:(void (^)(BOOL isChina))resultBlock
{
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error)
        {
            resultBlock(NO);
        }
        else
        {
            CLPlacemark *placemark = [placemarks firstObject];
            if (placemark)
            {
                NSString *countryCode = placemark.addressDictionary[@"CountryCode"];
                if ([countryCode isEqualToString:@"CN"])
                {
                    resultBlock(YES);
                }
                else
                {
                    resultBlock(NO);
                }
            }
            else
            {
                resultBlock(NO);
            }
        }
    }];
}

/**
 *  设置 百度地图,高德地图,谷歌地图 APIKEY
 */
- (void)setMapAPIKEY
{
//    [[BMKMapManager new] start:kBaiduMapKey generalDelegate:nil];//百度地图
//    [GMSServices provideAPIKey:@"AIzaSyARQyC2Il7pc30qTU45CQsmAxcayzLtpsM"];//谷歌地图
//    [AMapSearchServices sharedServices].apiKey = kGaodeMapKay;//高德地图
    
    [AMapServices sharedServices].apiKey = kMapKay;
}

/**
 *  检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
 */
- (void)setSearchDelegateNil
{
//    _baiduGeoCodeSearch.delegate = nil;
    _gaodeSearchAPI.delegate = nil;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = [error localizedDescription];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        errorMsg = @"用户禁用了定位";
    }
    
    if ([_delegate respondsToSelector:@selector(locationTool:didFailWithErrorMsg:)]) {
        [_delegate locationTool:self didFailWithErrorMsg:errorMsg];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    
    if (location)
    {
        if ([_delegate respondsToSelector:@selector(locationTool:didUpdateLocation:)]) {
            [_delegate locationTool:self didUpdateLocation:location];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(locationTool:didFailWithErrorMsg:)]) {
            [_delegate locationTool:self didFailWithErrorMsg:@"定位失败"];
        }
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
/*
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)errorCode;
{
    if (errorCode == BMK_SEARCH_NO_ERROR)
    {
        _baiduSuccessBlock(result);
    }
    else
    {
        _baiduFailureBlock(errorCode);
    }
}
 */

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    _gaodeFailureBlock(error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    _gaodeSuccessBlock(response);
}

#pragma mark - dealloc
- (void)dealloc
{
    //检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
    [self setSearchDelegateNil];
}

@end
