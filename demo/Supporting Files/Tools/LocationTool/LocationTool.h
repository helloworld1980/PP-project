//
//  LocationTool.h
//  定位_demo
//
//  Created by liman on 1/14/16.
//  Copyright © 2016 liman. All rights reserved.
//

//@import GoogleMaps;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CLLocation+YCLocation.h"
//#import <MapKit/MapKit.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

typedef enum : NSUInteger {
    CoordType_WGS84 = 0, /**< GPS坐标 */
    CoordType_GCJ02 = 1, /**< 火星坐标 */
    CoordType_BD09  = 2, /**< 百度坐标 */
} CoordType;

typedef void(^LocationSuccessBlock)(CLLocation *location);//定位
typedef void(^LocationFailureBlock)(NSString *errorMsg);

//typedef void(^BaiduSuccessBlock)(BMKReverseGeoCodeResult *result);//百度地图
//typedef void(^BaiduFailureBlock)(BMKSearchErrorCode errorCode);

typedef void(^GaodeSuccessBlock)(AMapReGeocodeSearchResponse *response);//高德地图
typedef void(^GaodeFailureBlock)(NSError *error);

@class LocationTool;
@protocol LocationToolDelegate <NSObject>

//定位成功
- (void)locationTool:(LocationTool *)locationTool didUpdateLocation:(CLLocation *)location;
//定位失败
- (void)locationTool:(LocationTool *)locationTool didFailWithErrorMsg:(NSString *)errorMsg;

@end

//@interface LocationTool : NSObject <CLLocationManagerDelegate, BMKGeoCodeSearchDelegate, AMapSearchDelegate>
@interface LocationTool : NSObject <CLLocationManagerDelegate, AMapSearchDelegate>

@property (strong, nonatomic)   CLLocationManager   *locationManager;//定位
@property (copy, nonatomic)     LocationSuccessBlock locationSuccessBlock;
@property (copy, nonatomic)     LocationFailureBlock locationFailureBlock;
@property (weak, nonatomic)     id <LocationToolDelegate> delegate;

//@property (strong, nonatomic)   BMKMapManager              *baiduMapManager;//百度地图
//@property (strong, nonatomic)   BMKGeoCodeSearch           *baiduGeoCodeSearch;
//@property (copy, nonatomic)     BaiduSuccessBlock           baiduSuccessBlock;
//@property (copy, nonatomic)     BaiduFailureBlock           baiduFailureBlock;
//@property (strong, nonatomic)   BMKReverseGeoCodeOption    *baiduReverseGeoCodeOption;

@property (strong, nonatomic)   AMapSearchAPI              *gaodeSearchAPI;//高德地图
@property (copy, nonatomic)     GaodeSuccessBlock           gaodeSuccessBlock;
@property (copy, nonatomic)     GaodeFailureBlock           gaodeFailureBlock;
@property (strong, nonatomic)   AMapReGeocodeSearchRequest *gaodeReGeocodeSearchRequest;

@property (strong, nonatomic)   CLGeocoder                 *geocoder;//苹果地图

//@property (strong, nonatomic)   GMSGeocoder                *googleGeocoder;//谷歌地图

@property (assign, nonatomic) CoordType coordType;//坐标类型

+ (LocationTool *)sharedInstance;

/**
 *  开始定位
 */
- (void)startUpdatingLocation:(id<LocationToolDelegate>)delegate;

/**
 *  停止定位
 */
- (void)stopUpdatingLocation;

/**
 *  百度地图 逆地理编码
 */
//- (void)baiduReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(BMKReverseGeoCodeResult *result))successBlock failure:(void (^)(BMKSearchErrorCode errorCode))failureBlock;

/**
 *  高德地图 逆地理编码
 */
- (void)gaodeReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(AMapReGeocodeSearchResponse *response))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  苹果地图 逆地理编码
 */
- (void)appleReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(NSArray<CLPlacemark *> *placemarks))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  谷歌地图 逆地理编码
 */
//- (void)googleReverseGeoCode:(CLLocation *)location type:(CoordType)type success:(void (^)(GMSReverseGeocodeResponse *response))successBlock failure:(void (^)(NSError *error))failureBlock;

/**
 *  判断国内外
 */
- (void)judge:(CLLocation *)location result:(void (^)(BOOL isChina))resultBlock;

/**
 *  设置 百度地图,高德地图,谷歌地图 APIKEY
 */
- (void)setMapAPIKEY;

/**
 *  检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
 */
- (void)setSearchDelegateNil;

@end
