//
//  MapManager.m
//  第三方导航_demo
//
//  Created by liman on 16/5/16.
//  Copyright © 2016年 liman. All rights reserved.
//


/**
 *  高德地图 http://lbs.amap.com/api/uri-api/ios-uri-explain/
 */
#define GaodeUrl_1  @"iosamap://navi?poiid=BGVIS&lat=%@&lon=%@&style=0&poiname=%@&sourceApplication=%@&dev=0&backScheme=myapp"//自动导航
#define GaodeUrl_2  @"iosamap://path?sid=BGVIS1&did=BGVIS2&dlat=%@&dlon=%@&m=0&t=0&dname=%@&sourceApplication=%@&dev=0&backScheme=myapp"//手动导航

/**
 *  百度地图 http://lbsyun.baidu.com/index.php?title=uri/api/ios
 */
#define BaiduUrl  @"baidumap://map/direction?origin=latlng:0,0|name:我的位置&destination=latlng:%@,%@|name:%@&mode=driving&src=%@&coord_type=bd09ll"//手动导航

/**
 *  腾讯地图 http://lbs.qq.com/uri_v1/guide-route.html
 */
#define QQUrl    @"qqmap://map/routeplan?type=drive&from=我的位置&tocoord=%@,%@&policy=0&to=%@&referer=%@&coord_type=2"//手动导航

/**
 *  谷歌地图 https://developers.google.com/maps/documentation/ios-sdk/urlscheme#_4
 */
#define GoogleUrl_1    @"comgooglemaps://?saddr=&directionsmode=driving&daddr=%@&x-source=%@&x-success=myapp"//手动导航(地址名)
#define GoogleUrl_2    @"comgooglemaps://?saddr=&directionsmode=driving&daddr=%@,%@&x-source=%@&x-success=myapp"//手动导航(经纬度)



#import "MapManager.h"

@implementation MapManager

+ (MapManager *)sharedInstance
{
    static MapManager *__singletion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    
    return __singletion;
}

#pragma mark - public
/**
 *  跳转 苹果地图 (火星坐标)
 */
- (void)jumpToAppleMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate
{
    /**
     MKLaunchOptionsDirectionsModeKey    路线模式，常量
     MKLaunchOptionsDirectionsModeDriving  驾车模式
     MKLaunchOptionsDirectionsModeWalking  步行模式
     MKLaunchOptionsDirectionsModeTransit  公交模式
     
     MKLaunchOptionsMapTypeKey    地图类型，枚举
     MKMapTypeStandard ：标准模式
     MKMapTypeSatellite ：卫星模式
     MKMapTypeHybrid  ：混合模式
     
     MKLaunchOptionsMapCenterKey 中心点坐标， CLLocationCoordinate2D类型
     MKLaunchOptionsMapSpanKey    地图显示跨度，MKCoordinateSpan 类型
     MKLaunchOptionsShowsTrafficKey    是否 显示交通状况，布尔型
     MKLaunchOptionsCameraKey    3D地图效果，MKMapCamera类型(注意：此属性从iOS7及以后可用，前面的属性从iOS6开始可用)
     */
    
    NSDictionary *launchOptions = @{
                                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                                    };
    
    CLLocationCoordinate2D endingCoord = addressCoordinate;
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    endingItem.name = addressName;
    
    //    [endingItem openInMapsWithLaunchOptions:nil];
    [endingItem openInMapsWithLaunchOptions:launchOptions];
}

/**
 *  跳转 高德地图 (火星坐标)
 */
- (void)jumpToGaodeMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate isAuto:(BOOL)isAuto
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [UIAlertView showWithMessage:@"尚未安装高德地图"];
        return;
    }
    //--------------------------------------------------------------------------------------------------
    
    //backScheme=myapp 这个参数也可以随便设置，如果用高德SDK的话，则需要按照api文档进行配置
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *urlString = nil;
    
    if (isAuto)
    {
        //自动导航
        urlString = [NSString stringWithFormat:GaodeUrl_1, [NSNumber numberWithDouble:addressCoordinate.latitude], [NSNumber numberWithDouble:addressCoordinate.longitude], addressName, app_Name];
    }
    else
    {
        //手动导航
        urlString = [NSString stringWithFormat:GaodeUrl_2, [NSNumber numberWithDouble:addressCoordinate.latitude], [NSNumber numberWithDouble:addressCoordinate.longitude], addressName, app_Name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [k_UIApplication openURL:[NSURL URLWithString:urlString]];
}

/**
 *  跳转 百度地图 (百度坐标)
 */
- (void)jumpToBaiduMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [UIAlertView showWithMessage:@"尚未安装百度地图"];
        return;
    }
    //--------------------------------------------------------------------------------------------------
    
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *urlString = nil;
    
    urlString = [NSString stringWithFormat:BaiduUrl, [NSNumber numberWithDouble:addressCoordinate.latitude], [NSNumber numberWithDouble:addressCoordinate.longitude], addressName, app_Name];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [k_UIApplication openURL:[NSURL URLWithString:urlString]];
}

/**
 *  跳转 腾讯地图 (火星坐标)
 */
- (void)jumpToQQMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"qqmap://"]])
    {
        [UIAlertView showWithMessage:@"尚未安装腾讯地图"];
        return;
    }
    //--------------------------------------------------------------------------------------------------
    
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *urlString = nil;
    
    urlString = [NSString stringWithFormat:QQUrl, [NSNumber numberWithDouble:addressCoordinate.latitude], [NSNumber numberWithDouble:addressCoordinate.longitude], addressName, app_Name];
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [k_UIApplication openURL:[NSURL URLWithString:urlString]];
}

/**
 *  跳转 谷歌地图 (GPS坐标)
 */
- (void)jumpToGoogleMapWithAddressName:(NSString *)addressName addressCoordinate:(CLLocationCoordinate2D)addressCoordinate
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        [UIAlertView showWithMessage:@"尚未安装谷歌地图"];
        return;
    }
    //--------------------------------------------------------------------------------------------------
    
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSString *urlString = nil;
    
    if (addressName)
    {
        //地址名
        urlString = [NSString stringWithFormat:GoogleUrl_1, addressName, app_Name];
    }
    else
    {
        //经纬度
        urlString = [NSString stringWithFormat:GoogleUrl_2, [NSNumber numberWithDouble:addressCoordinate.latitude], [NSNumber numberWithDouble:addressCoordinate.longitude], app_Name];
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [k_UIApplication openURL:[NSURL URLWithString:urlString]];
}

@end
