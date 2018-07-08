//
//  MapViewController.h
//  demo
//
//  Created by liman on 3/6/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchViewController.h"
#import "QRScanViewController.h"

typedef enum : NSUInteger {
    LocationType_myLocation = 0, /**< 我的位置 */
    LocationType_fromSearchVC = 1, /**< 搜索 */
} LocationType;//位置类型

@interface MapViewController : BaseViewController <LocationToolDelegate, SearchViewControllerDelegate, QRScanViewControllerDelegate, AMapSearchDelegate, MKMapViewDelegate>

// mapView
@property (strong, nonatomic) MKMapView *mapView;

// 定位按钮
@property (strong, nonatomic) UIButton *locationButton;
// 刷新按钮
@property (strong, nonatomic) UIButton *refreshBtn;
// 客服按钮
@property (strong, nonatomic) UIButton *kfButton;
// 附近按钮
@property (strong, nonatomic) UIButton *nearbyBtn;

//扫码借button
@property (strong, nonatomic) UIButton *borrowBtn;
//扫码还button
@property (strong, nonatomic) UIButton *returnBtn;

//高德路线规划API
@property (strong, nonatomic) AMapSearchAPI *searchAPI;

@end
