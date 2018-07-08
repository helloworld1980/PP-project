//
//  MapManager.h
//  第三方导航_demo
//
//  Created by liman on 16/5/16.
//  Copyright © 2016年 liman. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIAlertView+Blocks.h"

@interface MapManager : NSObject

+ (MapManager *)sharedInstance;

/**
 *  跳转 苹果地图 (火星坐标)
 */
- (void)jumpToAppleMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate;

/**
 *  跳转 高德地图 (火星坐标)
 */
- (void)jumpToGaodeMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate isAuto:(BOOL)isAuto;

/**
 *  跳转 百度地图 (百度坐标)
 */
- (void)jumpToBaiduMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate;

/**
 *  跳转 腾讯地图 (火星坐标)
 */
- (void)jumpToQQMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate;

/**
 *  跳转 谷歌地图 (GPS坐标)
 */
- (void)jumpToGoogleMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate;

@end
