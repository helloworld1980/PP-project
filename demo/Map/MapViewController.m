//
//  MapViewController.m
//  demo
//
//  Created by liman on 3/6/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 10
#define kRefreshTime 0.73

#import "MapViewController.h"
#import "CustomAnnotation.h"
#import "MeViewController.h"
#import "TroubleViewController.h"
#import "PayViewController.h"
#import "CreditViewController.h"
#import "PayDepositViewController.h"
#import "WalletViewController.h"
#import "LoginViewController.h"
#import "MyFriendViewController.h"
#import "MessageViewController.h"
#import "RecordViewController.h"
#import "NearbyViewController.h"
#import "InviteFriendViewController.h"

@implementation MapViewController
{
    //进入时, 地图定位到特定点(火星坐标)
    LocationObject *_locationObjectFromSearchVC;
    CustomAnnotation *_annotationFromSearchVC;
    
    //是否已获取过附近电桩
    BOOL _didGetStations;
    
    //充电桩数组
    NSArray *_stationObjects;
    
    //高德路线规划
    NSArray *_pathPolylines;
}

- (void)test
{
//    [self.navigationController pushViewController:[[QRScanViewController alloc] initWithNaviBarHidden:NO scanType:ScanType_borrow] animated:YES];
//    [self.navigationController pushViewController:[SearchViewController new] animated:YES];
//    [self.navigationController pushViewController:[TroubleViewController new] animated:YES];
//    [self.navigationController pushViewController:[MeViewController new] animated:YES];
//    [self.navigationController pushViewController:[NearbyViewController new] animated:YES];
//    [self.navigationController pushViewController:[PayViewController new] animated:YES];
//    [self.navigationController pushViewController:[CreditViewController new] animated:YES];
//    [self.navigationController pushViewController:[PayDepositViewController new] animated:YES];
//    [self.navigationController pushViewController:[WalletViewController new] animated:YES];
//    [self.navigationController pushViewController:[InviteFriendViewController new] animated:YES];
    
    
    
    
    //0.获取token
    [[APIService sharedInstance] getToken_userId:@"4" success:^(NSString *token) {
        
        DLog(token);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    
    //24.判断充电桩详情
    [[APIService sharedInstance] getStationConnectType_stationCode:@"10010" success:^(NSString *connectType, NSString *stationId) {
        
        DLog(connectType);
        DLog(stationId);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    //3.更新用户的百度推送channel
    [[APIService sharedInstance] updateBaiduChannelId:@"1123213123" success:^(NSString *message) {
        
        DLog(message);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    
    
    PositionObject *obj1 = [PositionObject new];
    obj1.stationCode = @"10015";
    obj1.code = @"10015_1";
    obj1.capacity = @"0.5";
    obj1.canBorrow = YES;
    
    PositionObject *obj2 = [PositionObject new];
    obj2.stationCode = @"10015";
    obj2.code = @"10015_2";
    obj2.capacity = @"0.6";
    obj2.canBorrow = NO;
    
    //10.上传充电桩详细信息
    [[APIService sharedInstance] synch_stationCode:@"10015" positionObjects:@[obj1,obj2] success:^(StationObject *stationObject){
        
        DLog(stationObject);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    
    //17.还充电宝
    [[APIService sharedInstance] return_stationCode:@"10015" positionCode:@"10015_1" bankCode:@"123" success:^(NSDictionary *orderPayMap) {
        DLog(orderPayMap);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    //13.用户借用消费
    [[APIService sharedInstance] pay_payType:PayType_wechat orderId:@"1005" success:^(PayObject *payObject) {
        
        DLog(payObject);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    
    
    
    //30.获取用户未支付订单
    [[APIService sharedInstance] unpayorders:^(NSArray *orderObjects) {
        
        DLog(orderObjects);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
}

#pragma mark - tool
//检测定位是否可用
- (BOOL)judgeIfLocationAvailable
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的位置, 请前往\"设置-隐私-定位服务\"打开"];
            return NO;
        }
    }
    else
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的位置, 请前往\"设置-隐私-定位服务\"打开"];
            return NO;
        }
    }
    
    return YES;
}

//地图缓存
- (void)mapCache
{
    //地图缓存(GPS坐标)
    NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
    NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
    
    if (latitude && longitude)
    {
        //GPS坐标-->火星坐标
        CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *marsLocation = [gpsLocation locationEarthToMars];
        
        [_mapView setcenterCoordinate:CLLocationCoordinate2DMake(marsLocation.coordinate.latitude, marsLocation.coordinate.longitude) zoomLevel:17 animated:NO];
    }
    
    
    if (_mapView.userTrackingMode != MKUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:NO];
    }
}

// 添加一个锚点(火星坐标)
- (void)addAnnotation:(LocationObject *)locationObject
{
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:locationObject.coordinate title:locationObject.title subTitle:locationObject.subTitle isCustom:locationObject.isCustom];
    
    if (locationObject.isFromSearchVC) {
        annotation.isFromSearchVC = YES;
        _annotationFromSearchVC = annotation;
    }
    
    [_mapView addAnnotation:annotation];
}

// 添加多个锚点(火星坐标)
- (void)addAnnotations:(NSArray *)locationObjectArr
{
    for (LocationObject *locationObject in locationObjectArr) {
        // 添加一个锚点(火星坐标)
        [self addAnnotation:locationObject];
    }
}

//增加充电桩锚点(火星坐标)
- (void)addAnnotations_stationObjects
{
    NSMutableArray *locationObjects = [NSMutableArray array];
    
    for (StationObject *stationObject in _stationObjects) {
        LocationObject *locationObject = [[LocationObject alloc] initWithCoordinate:CLLocationCoordinate2DMake([stationObject.latitude doubleValue], [stationObject.longitude doubleValue]) title:stationObject.shopName subTitle:stationObject.address isCustom:YES];
        [locationObjects addObject:locationObject];
    }
    

    // 添加多个锚点(火星坐标)
    [self addAnnotations:[locationObjects copy]];
}

//获取最近的充电桩信息 (我的位置/搜索的位置)
- (void)getStationObjects:(LocationType)locationType
{
    CLLocation *marsLocation = nil;//火星坐标
    
    if (locationType == LocationType_myLocation)
    {
        //地图缓存(GPS坐标)
        NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
        NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
        
        if (latitude && longitude)
        {
            //GPS坐标-->火星坐标
            CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
            marsLocation = [gpsLocation locationEarthToMars];
        }
    }
    
    if (locationType == LocationType_fromSearchVC)
    {
        marsLocation = [[CLLocation alloc] initWithLatitude:_locationObjectFromSearchVC.coordinate.latitude longitude:_locationObjectFromSearchVC.coordinate.longitude];
    }
    
    
    
    
    //6.获取最近的充电桩信息(仅限地图)
    [[APIService sharedInstance] getStationObjects_latitude:marsLocation.coordinate.latitude longitude:marsLocation.coordinate.longitude scope:1000 countNo:10 success:^(NSArray *stationObjects) {
        
        DLog(stationObjects);
        _stationObjects = stationObjects;
        
        //增加充电桩锚点(火星坐标)
        [self addAnnotations_stationObjects];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
    }];
}

//添加从搜索VC而来的锚点
- (void)addAnnotationFromSearchVC
{
    if (_locationObjectFromSearchVC)
    {
        // 添加一个锚点(火星坐标)
        [self addAnnotation:_locationObjectFromSearchVC];
        
        //进入时, 地图定位到特定点(火星坐标)
        [_mapView setcenterCoordinate:CLLocationCoordinate2DMake(_locationObjectFromSearchVC.coordinate.latitude, _locationObjectFromSearchVC.coordinate.longitude) zoomLevel:17 animated:YES];
        return;
    }
}

//绘制轨迹(火星坐标)
- (void)goSearch_from:(CLLocation *)fromLocation to:(CLLocation *)toLocation
{
    /*
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromLocation.coordinate addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toLocation.coordinate addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirections_from:fromItem to:toItem];
     */
    
    
    GCD_DELAY_AFTER(0.1, ^{
        [[HUDHelper sharedInstance] tipMessage:@"路线规划中..." seconds:kTimeout];
        
        
        //高德路线规划API
        AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
        
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:fromLocation.coordinate.latitude
                                               longitude:fromLocation.coordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:toLocation.coordinate.latitude
                                                    longitude:toLocation.coordinate.longitude];
        
        [_searchAPI AMapWalkingRouteSearch:navi];
    });
}

//绘制轨迹(火星坐标)
- (void)findDirections_from:(MKMapItem *)source to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;
    request.requestsAlternateRoutes = YES;
    request.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    
    //苹果地图路线规划API
    [[HUDHelper sharedInstance] tipMessage:@"路线规划中..." seconds:kTimeout];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error)
        {
            [[HUDHelper sharedInstance] tipMessage:@"路线规划失败"];
            DLog(error.localizedDescription);
        }
        else
        {
            [[HUDHelper sharedInstance] stopLoading];
            [_mapView removeOverlays:_mapView.overlays];//先移除所有轨迹
            
            MKRoute *route = response.routes[0];
            [_mapView addOverlay:route.polyline];
        }
    }];
}

//高德路线规划API
- (void)_searchAPI
{
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
}

//高德路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        
//        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:count];
//        MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}

//高德解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}

//旋转动画
- (void)refreshAction:(CGFloat)refreshTime
{
    //旋转动画
    if (refreshTime != 0) {
        [UIButton rotate360DegreeWithImageView:_refreshBtn seconds:refreshTime];
    }
    
    
    //移除所有annotation
    [_mapView removeAnnotations:_mapView.annotations];
    
    //移除地图原本的遮盖(绘制轨迹)
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    
    
    
    if (_locationObjectFromSearchVC)
    {
        // 添加一个锚点(火星坐标)
        [self addAnnotation:_locationObjectFromSearchVC];
        
        //获取最近的充电桩信息 (搜索的位置)
        [self getStationObjects:LocationType_fromSearchVC];
    }
    else
    {
        //获取最近的充电桩信息 (我的位置)
        [self getStationObjects:LocationType_myLocation];
    }
}

//网络请求
- (void)requestNetwork
{
    //5.获取服务器时间
    [[APIService sharedInstance] requestServerTime:^(NSString *serverTime) {
        
        DLog(serverTime);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    //18.获取用户详细信息
    [[APIService sharedInstance] getUserObject:^(UserObject *userObject) {
        
        DLog(userObject);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        if ([errorStatus isEqualToString:@"TOKEN_ERROR"])
        {
            [UIAlertView showWithMessage:@"token失效, 请重新登录" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                //我的bug
                GCD_DELAY_AFTER(0.5, ^{
                    [k_NSUserDefaults removeObjectForKey:@"token"];
                    [k_NSUserDefaults removeObjectForKey:@"security"];
                    [k_NSUserDefaults removeObjectForKey:@"userId"];
                    
                    [k_NSUserDefaults setBool:NO forKey:@"login"];
                    [k_NSUserDefaults synchronize];
                    
                    k_UIApplication.keyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
                });
            }];
        }
        else
        {
            [[HUDHelper sharedInstance] tipMessage:errorMsg];
        }
    }];
    
    
    
    
    //26.获取用户余额,押金,信用
    [[APIService sharedInstance] getBalanceObject:^(BalanceObject *balanceObject) {
        
        DLog(balanceObject);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
    
    
    
    //15.获取押金金额
    [[APIService sharedInstance] getDeposit:^(NSString *deposit) {
        
        DLog(deposit);
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        DLog(errorMsg);
    }];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"PP充电";
    
    //测试2
//    [self test];

    //网络请求
    [self requestNetwork];
    
    
    //检测定位是否可用
    [self judgeIfLocationAvailable];
    // 初始化地图
    [self initMapView];
    //地图缓存
    [self mapCache];
    
    
    //自定义导航栏
    [self customNaviBar];
    // 定位按钮
    [self initLocationBtn];
    // 刷新按钮
    [self initRefreshBtn];
    // 客服按钮
    [self init_kfButton];
    // 附近按钮
    [self init_nearbyBtn];
    
    //扫码借button
    [self init_borrowButton];
    //扫码还button
    [self init_returnButton];
    
    
    //高德路线规划API
    [self _searchAPI];
    
    //旋转动画
    [UIButton rotate360DegreeWithImageView:_refreshBtn seconds:kRefreshTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if (!_mapView) {
        // 初始化地图
        [self initMapView];
        
        [self.view bringSubviewToFront:_locationButton];
        [self.view bringSubviewToFront:_refreshBtn];
        [self.view bringSubviewToFront:_kfButton];
        [self.view bringSubviewToFront:_borrowBtn];
        [self.view bringSubviewToFront:_returnBtn];
        [self.view bringSubviewToFront:_nearbyBtn];
    }
     */
    
    //开始定位
    [[LocationTool sharedInstance] startUpdatingLocation:self];
    
    //添加从搜索VC而来的锚点
    [self addAnnotationFromSearchVC];
    
    _didGetStations = NO;
    
    //高德路线规划API
    if (!_searchAPI.delegate) {
        _searchAPI.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //停止定位
    [[LocationTool sharedInstance] stopUpdatingLocation];
    
    //检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
    [[LocationTool sharedInstance] setSearchDelegateNil];
    
    _searchAPI.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
    _mapView.delegate = nil;
    _mapView.mapType = MKMapTypeHybrid;
    _mapView.showsUserLocation = NO;
    [_mapView removeFromSuperview];
    _mapView = nil;
     */
}

#pragma mark - private
// 初始化地图
- (void)initMapView
{
//    return;//测试2
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH)];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_mapView];
    
    // 开启定位
    _mapView.showsUserLocation = YES;
}

//自定义导航栏
- (void)customNaviBar
{
    [self customNaviItemWithTitle:nil titleFont:nil normalTitleColor:nil highlightTitleColor:nil normalImage:[UIImage imageNamed:@"me"] highlightImage:[UIImage imageNamed:@"me_ant"] action:@selector(leftItemClick) frame:CGRectMake(10, 28, 56/2, 56/2) tag:nil];
    [self customNaviItemWithTitle:nil titleFont:nil normalTitleColor:nil highlightTitleColor:nil normalImage:[UIImage imageNamed:@"search"] highlightImage:[UIImage imageNamed:@"search_ant"] action:@selector(rightItemClick) frame:CGRectMake(SCREEN_WIDTH - 56/2 - 10, 28, 56/2, 56/2) tag:nil];
}

// 定位按钮
- (void)initLocationBtn
{
    _locationButton = [UIButton buttonWithType:0];
    _locationButton.frame = CGRectMake(kGap, SCREEN_HEIGHT - 60, 34, 34);
    [self.view addSubview:_locationButton];
    
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = _locationButton.width/2;
    [_locationButton addTarget:self action:@selector(locationButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"PositionMyself"] forState:0];
}

// 刷新按钮
- (void)initRefreshBtn
{
    _refreshBtn = [UIButton buttonWithType:0];
    _refreshBtn.frame = _locationButton.frame;
    _refreshBtn.bottom = _locationButton.top - kGap;
    [self.view addSubview:_refreshBtn];
    
    _refreshBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _refreshBtn.backgroundColor = [UIColor whiteColor];
    _refreshBtn.layer.cornerRadius = _refreshBtn.width/2;
    [_refreshBtn addTarget:self action:@selector(refreshButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:0];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:1];
}

// 客服按钮
- (void)init_kfButton
{
    _kfButton = [UIButton buttonWithType:0];
    _kfButton.frame = _locationButton.frame;
    _kfButton.right = SCREEN_WIDTH - kGap;
    [self.view addSubview:_kfButton];
    
    _kfButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _kfButton.backgroundColor = [UIColor whiteColor];
    _kfButton.layer.cornerRadius = _kfButton.width/2;
    [_kfButton addTarget:self action:@selector(kfButtonClick)
          forControlEvents:UIControlEventTouchUpInside];
    [_kfButton setImage:[UIImage imageNamed:@"service"] forState:0];
}

// 附近按钮
- (void)init_nearbyBtn
{
    _nearbyBtn = [UIButton buttonWithType:0];
    _nearbyBtn.frame = _kfButton.frame;
    _nearbyBtn.top = _refreshBtn.top;
    [self.view addSubview:_nearbyBtn];
    
    _nearbyBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _nearbyBtn.backgroundColor = [UIColor whiteColor];
    _nearbyBtn.layer.cornerRadius = _nearbyBtn.width/2;
    [_nearbyBtn addTarget:self action:@selector(_nearbyBtnClick)
        forControlEvents:UIControlEventTouchUpInside];
    [_nearbyBtn setImage:[UIImage imageNamed:@"liebiao"] forState:0];
}

//扫码借button
- (void)init_borrowButton
{
    _borrowBtn = [UIButton buttonWithType:0];
    _borrowBtn.width = (SCREEN_WIDTH - _locationButton.width*2 - kGap*5) / 2;
    _borrowBtn.height = _locationButton.height;
    _borrowBtn.left = _locationButton.right + kGap;
    _borrowBtn.top = _locationButton.top;
    [self.view addSubview:_borrowBtn];
    
    [_borrowBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [_borrowBtn jk_cornerRadius:_borrowBtn.height/2 strokeSize:0 color:nil];
    [_borrowBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(borrowViewClick)]];
    
    
    //1.图片
    UIImageView *imageView = [UIImageView new];
    imageView.width = 40/2;
    imageView.height = 38/2;
    imageView.left = _borrowBtn.height/2 - 2;
    imageView.top = (_borrowBtn.height - imageView.height) / 2;
    imageView.image = [UIImage imageNamed:@"QrCode"];
    [_borrowBtn addSubview:imageView];
    
    //2.文字
    UILabel *label = [UILabel new];
    label.height = imageView.height;
    label.top = imageView.top;
    label.left = imageView.right + 6;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"扫码借";
    [_borrowBtn addSubview:label];
    
    [label adjustWidth];
    
    //适配
    if (IS_IPHONE_6) {
        imageView.left = 20;
        label.left = 54;
    }
    if (IS_IPHONE_6P) {
        imageView.left = 24;
        label.left = 60;
    }
}

//扫码还button
- (void)init_returnButton
{
    _returnBtn = [UIButton buttonWithType:0];
    _returnBtn.frame = _borrowBtn.frame;
    _returnBtn.left = _borrowBtn.right + kGap;
    [self.view addSubview:_returnBtn];
    
    [_returnBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#6c8778"]] forState:0];
    _returnBtn.backgroundColor = [UIColor colorWithHexString:@"#6c8778"];
    [_returnBtn jk_cornerRadius:_returnBtn.height/2 strokeSize:0 color:nil];
    [_returnBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnViewClick)]];
    
    
    //1.图片
    UIImageView *imageView = [UIImageView new];
    imageView.width = 40/2;
    imageView.height = 38/2;
    imageView.left = _returnBtn.height/2 - 2;
    imageView.top = (_returnBtn.height - imageView.height) / 2;
    imageView.image = [UIImage imageNamed:@"QrCode"];
    [_returnBtn addSubview:imageView];
    
    //2.文字
    UILabel *label = [UILabel new];
    label.height = imageView.height;
    label.top = imageView.top;
    label.left = imageView.right + 6;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"扫码还";
    [_returnBtn addSubview:label];
    
    [label adjustWidth];
    
    //适配
    if (IS_IPHONE_6) {
        imageView.left = 20;
        label.left = 54;
    }
    if (IS_IPHONE_6P) {
        imageView.left = 24;
        label.left = 60;
    }
}

#pragma mark - MKMapViewDelegate
// 点击了锚点
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView
{
    //地图缓存(GPS坐标)
    NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
    NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
    
    if (latitude && longitude)
    {
        //GPS坐标-->火星坐标
        CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *marsLocation = [gpsLocation locationEarthToMars];
        
        
        if ([annotationView.annotation isKindOfClass:[MKUserLocation class]])
        {
            //>>>>>>>>>>>>>>>>>>>>>>>>>>> 点击了我的位置 >>>>>>>>>>>>>>>>>>>>>>>
            
            //高德地图 逆地理编码
            [[LocationTool sharedInstance] gaodeReverseGeoCode:gpsLocation type:CoordType_WGS84 success:^(AMapReGeocodeSearchResponse *response) {
                
                NSLog(@"____%@ ____%@",response.regeocode.formattedAddress, response.regeocode.addressComponent);
                _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
                
            } failure:^(NSError *error) {
                NSLog(@"____%@",[error localizedDescription]);
                [[HUDHelper sharedInstance] tipMessage:@"获取我的位置信息失败"];
            }];
        }
        
        if ([annotationView.annotation isKindOfClass:[CustomAnnotation class]])
        {
            //>>>>>>>>>>>>>>>>>>>>>>>>>>> 点击了自定义锚点 >>>>>>>>>>>>>>>>>>>>>>>
            
            //自定义锚点(火星坐标)
            CLLocation *customLocation = [[CLLocation alloc] initWithLatitude:((CustomAnnotation *)annotationView).coordinate.latitude longitude:((CustomAnnotation *)annotationView).coordinate.longitude];
            
            //绘制轨迹(火星坐标)
            if (_locationObjectFromSearchVC)
            {
                if (((CustomAnnotation *)annotationView.annotation).isFromSearchVC)
                {
                    //点击了"搜索的位置"
                }
                else
                {
                    //从"充电桩的位置"规划路径
                    CLLocation *marsLocationFromSearchVC = [[CLLocation alloc] initWithLatitude:_locationObjectFromSearchVC.coordinate.latitude longitude:_locationObjectFromSearchVC.coordinate.longitude];
                    [self goSearch_from:marsLocationFromSearchVC to:customLocation];
                }
            }
            else
            {
                //从"我的位置"规划路径
                [self goSearch_from:marsLocation to:customLocation];
            }
        }
    }
    else
    {
        [[HUDHelper sharedInstance] tipMessage:@"获取我的位置信息失败"];
    }
}

// 自定义锚点
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[CustomAnnotation class]])
    {
        return nil;
    }
    
    if (![mapView isEqual:mapView])
    {
        return nil;
    }
    
    CustomAnnotation *customAnnotation = (CustomAnnotation *)annotation;
    
    if (!customAnnotation.isCustom)
    {
        return nil;
    }
    else
    {
        NSString *identifier = [CustomAnnotation reusableIdentifierforPinColor:customAnnotation.pinColor];
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:customAnnotation reuseIdentifier:identifier];
        }
        annotationView.image = [UIImage imageNamed:@"position"];
        annotationView.canShowCallout = YES;
        
        if (customAnnotation.isFromSearchVC) {
            annotationView.image = [UIImage imageNamed:@"target"];
        }
        
        return annotationView;
    }
}

//绘制轨迹
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        renderer.strokeColor = k_MainColor;
        renderer.fillColor = k_MainColor;
        renderer.lineWidth = 3;

        return renderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        [[HUDHelper sharedInstance] tipMessage:@"路线规划失败"];
        return;
    }
    
    [[HUDHelper sharedInstance] stopLoading];
    
    
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    DLog(route);
    
    AMapPath *path = response.route.paths[0]; //选择一条路径
    AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
    DLog(step.polyline);   //此路段坐标点字符串
    
    if (response.count > 0)
    {
        //移除地图原本的遮盖
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        
        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [self polylinesForPath:response.route.paths[0]];
        DLog(response.route.paths[0]);
        //添加新的遮盖，然后会触发代理方法进行绘制
        [_mapView addOverlays:_pathPolylines];
    }
}

#pragma mark - LocationToolDelegate
//定位成功
- (void)locationTool:(LocationTool *)locationTool didUpdateLocation:(CLLocation *)location
{
    NSLog(@"____%.15f ____%.15f",location.coordinate.latitude, location.coordinate.longitude);
    
    //地图缓存(GPS坐标)
    [k_NSUserDefaults setObject:toNSString(location.coordinate.latitude) forKey:@"latitude"];
    [k_NSUserDefaults setObject:toNSString(location.coordinate.longitude) forKey:@"longitude"];
    [k_NSUserDefaults synchronize];
    
    
    
    if (!_didGetStations) {
        _didGetStations = YES;
        
        //获取最近的充电桩信息 (我的位置)
        [self getStationObjects:LocationType_myLocation];
    }
}

//定位失败
- (void)locationTool:(LocationTool *)locationTool didFailWithErrorMsg:(NSString *)errorMsg
{
    NSLog(@"____定位失败: %@",errorMsg);
}

#pragma mark - SearchViewControllerDelegate
//点击了cell(火星坐标)
- (void)searchViewController:(SearchViewController *)searchViewController didSelectedCell:(LocationObject *)locationObject
{
    //移除特定点锚点(火星坐标)
    [_mapView removeAnnotation:_annotationFromSearchVC];
    
    //移除地图原本的遮盖(绘制轨迹)
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    
    
    
    _locationObjectFromSearchVC = locationObject;
    
    //旋转动画
    [self refreshAction:kRefreshTime];
}

#pragma mark - QRScanViewControllerDelegate
//借取成功
- (void)qrScanViewController:(QRScanViewController *)qrScanViewController borrowSuccess:(BorrowObject *)borrowObject
{

}

#pragma mark - target action
//定位按钮
- (void)locationButtonClick
{
    if (_mapView.userTrackingMode != MKUserTrackingModeFollow) {
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    
    _locationObjectFromSearchVC = nil;
}

//刷新按钮
- (void)refreshButtonClick
{
    //旋转动画
    [self refreshAction:kRefreshTime*2];
}

//客服按钮
- (void)kfButtonClick
{
    //故障上报
    [self.navigationController pushViewController:[TroubleViewController new] animated:YES];
}

//附近按钮
- (void)_nearbyBtnClick
{
    NearbyViewController *vc = [NearbyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//扫码借
- (void)borrowViewClick
{
    // 检测是否禁用了相机
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusRestricted)
    {
        [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的相机, 请前往\"设置-隐私-相机\"打开"];
        return;
    }
    
    //检测蓝牙是否打开
    if (![k_NSUserDefaults boolForKey:@"ble"]) {
        [UIAlertView showWithMessage:@"未检测到蓝牙开启, 请前往\"设置-蓝牙\"打开"];
        return;
    }
    
    
    
    QRScanViewController *vc = [[QRScanViewController alloc] initWithNaviBarHidden:NO scanType:ScanType_borrow];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//扫码还
- (void)returnViewClick
{
    // 检测是否禁用了相机
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusRestricted)
    {
        [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的相机, 请前往\"设置-隐私-相机\"打开"];
        return;
    }
    
    //检测蓝牙是否打开
    if (![k_NSUserDefaults boolForKey:@"ble"]) {
        [UIAlertView showWithMessage:@"未检测到蓝牙开启, 请前往\"设置-蓝牙\"打开"];
        return;
    }
    
    
    
    QRScanViewController *vc = [[QRScanViewController alloc] initWithNaviBarHidden:NO scanType:ScanType_return];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftItemClick
{
    //个人中心
    [self.navigationController pushViewController:[MeViewController new] animated:YES];
}

- (void)rightItemClick
{
    //搜索
    SearchViewController *vc = [[SearchViewController alloc] initWithAddress:_mapView.userLocation.subtitle];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
