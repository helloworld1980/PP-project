//
//  SearchViewController.m
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 10

#import "SearchViewController.h"

@implementation SearchViewController
{
    NSString *_address;
    
    //AMapPOI对象数组
    NSArray *_aMapPOIs;
}

#pragma mark - public
- (instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    if (self) {
        _address = address;
    }
    return self;
}

#pragma mark - tool
//检测定位是否可用
- (BOOL)judgeIfLocationAvailable
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
//            [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的位置, 请前往\"设置-隐私-定位服务\"打开"];
            return NO;
        }
    }
    else
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
//            [UIAlertView showWithMessage:@"您已禁止\"PP充电\"访问您的位置, 请前往\"设置-隐私-定位服务\"打开"];
            return NO;
        }
    }
    
    return YES;
}

//获取我的位置
- (void)getMyLocation
{
    if (_address)
    {
        _myLocationLabel.text = _address;
    }
    else
    {
        //地图缓存(GPS坐标)
        NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
        NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
        
        if (latitude && longitude)
        {
            CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
            
            //高德地图 逆地理编码
            [[LocationTool sharedInstance] gaodeReverseGeoCode:gpsLocation type:CoordType_WGS84 success:^(AMapReGeocodeSearchResponse *response) {
                
                NSLog(@"____%@ ____%@",response.regeocode.formattedAddress, response.regeocode.addressComponent);
                _address = response.regeocode.formattedAddress;
                _myLocationLabel.text = _address;
                
            } failure:^(NSError *error) {
                NSLog(@"____%@",[error localizedDescription]);
                _myLocationLabel.text = @"获取我的位置信息失败";
            }];
        }
        else
        {
            _myLocationLabel.text = @"获取我的位置信息失败";
        }
    }
}

//高德POI
- (void)_poiSearch
{
    //http://lbs.amap.com/api/ios-sdk/guide/map-data/poi#keywords
    
    _poiSearch = [[AMapSearchAPI alloc] init];
    _poiSearch.delegate = self;
    
    
    
    //地图缓存(GPS坐标)
    NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
    NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
    
    if (latitude && longitude)
    {
        //GPS坐标-->火星坐标
        CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *marsLocation = [gpsLocation locationEarthToMars];
        
        _poiRequest2 = [[AMapPOIAroundSearchRequest alloc] init];
        _poiRequest2.location            = [AMapGeoPoint locationWithLatitude:marsLocation.coordinate.latitude longitude:marsLocation.coordinate.longitude];
//        _poiRequest2.keywords            = @"电影院";
        
        /* 按照距离排序. */
        _poiRequest2.sortrule            = 0;
        _poiRequest2.requireExtension    = YES;
    }
    else
    {
        _poiRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
//        _poiRequest.keywords            = @"北京大学";
//        _poiRequest.city                = @"北京";
//        _poiRequest.types               = @"高等院校";
        _poiRequest.requireExtension    = YES;
        
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        _poiRequest.cityLimit           = YES;
        _poiRequest.requireSubPOIs      = YES;
    }
}

//高德POI
- (void)run_poiSearch
{
    if (_poiRequest)
    {
        _poiRequest.keywords = _textField.text;
        [_poiSearch AMapPOIKeywordsSearch:_poiRequest];
    }
    
    if (_poiRequest2)
    {
        _poiRequest2.keywords = _textField.text;
        [_poiSearch AMapPOIAroundSearch:_poiRequest2];
    }
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)];
    tap.cancelsTouchesInView = NO; //防止覆盖UITableViewCell的点击事件
    [self.view addGestureRecognizer:tap];
    
    
    //自定义导航栏item
    [self customNaviItem];
    
    //搜索view
    [self init_searchView];
    //搜索textfield
    [self init_textField];
    
    //我的位置label1
    [self _myLocationLabel1];
    //我的位置label
    [self init_myLocationLabel];
    
    //tableview
    [self init_tableView];
    
    //高德POI
    [self _poiSearch];
    
    
    //检测定位是否可用
    if ([self judgeIfLocationAvailable])
    {
        //定位可用:
        [self getMyLocation];//获取我的位置
    }
    else
    {
        //定位不可用:
        _myLocationLabel.text = @"获取我的位置信息失败";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_poiSearch.delegate) {
        _poiSearch.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
    [[LocationTool sharedInstance] setSearchDelegateNil];
    
    _poiSearch.delegate = nil;
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:@"取消" titleFont:[UIFont systemFontOfSize:16] normalTitleColor:[UIColor whiteColor] highlightTitleColor:nil normalImage:nil highlightImage:nil action:@selector(cancelClick) frame:CGRectMake(SCREEN_WIDTH - 46, 33, 40, 20) tag:nil];
}

//搜索view
- (void)init_searchView
{
    _searchView = [UIView new];
    _searchView.left = 10;
    _searchView.height = k_NaviH - 20 - 10;
    _searchView.width = SCREEN_WIDTH - 60;
    _searchView.top = 20 + 10/2;
    [self.naviBarView addSubview:_searchView];
    
    _searchView.backgroundColor = [UIColor whiteColor];
    [_searchView jk_cornerRadius:_searchView.height/2 strokeSize:0 color:nil];
}

//搜索textfield
- (void)init_textField
{
    _textField = [UITextField new];
    _textField.width = _searchView.width - 20;
    _textField.height = _searchView.height - 16;
    _textField.top = 8;
    _textField.left = _searchView.height/2;
    [_searchView addSubview:_textField];
    
    
//    _textField.backgroundColor = k_RandomColor;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.placeholder = @"请输入地点";
    _textField.font = [UIFont systemFontOfSize:15];
    [_textField addTarget:self action:@selector(keyboardHidden) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
}

//我的位置label1
- (void)_myLocationLabel1
{
    _myLocationLabel1 = [UILabel new];
    _myLocationLabel1.top = k_NaviH + kGap;
    _myLocationLabel1.left = kGap;
    [self.view addSubview:_myLocationLabel1];
    
    _myLocationLabel1.text = @"我的位置";
    _myLocationLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    _myLocationLabel1.font = [UIFont systemFontOfSize:16];
    [_myLocationLabel1 adjustWidth];
    [_myLocationLabel1 adjustHeight:0];
}

//我的位置label
- (void)init_myLocationLabel
{
    _myLocationLabel = [UILabel new];
    _myLocationLabel.top = _myLocationLabel1.bottom + 4;
    _myLocationLabel.width = SCREEN_WIDTH - 2 * kGap;
    _myLocationLabel.left = kGap;
    _myLocationLabel.height = 20;
    [self.view addSubview:_myLocationLabel];
    
    _myLocationLabel.font = [UIFont systemFontOfSize:13];
    _myLocationLabel.textColor = [UIColor colorWithHexString:@"#666666"];
}

//tableview
- (void)init_tableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    _tableView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_aMapPOIs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyBaseCell class])];
    if (!cell) {
        cell = [[MyBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MyBaseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBaseCellStyle = MyBaseCellStyle_3;
    cell.aMapPOI = _aMapPOIs[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    AMapPOI *aMapPOI = _aMapPOIs[indexPath.row];
    CLLocation *marsLocation = [[CLLocation alloc] initWithLatitude:aMapPOI.location.latitude longitude:aMapPOI.location.longitude];
                        
    LocationObject *locationObject = [[LocationObject alloc] initWithCoordinate:marsLocation.coordinate title:aMapPOI.name subTitle:aMapPOI.address isCustom:YES];
    locationObject.isFromSearchVC = YES;
    
    if ([_delegate respondsToSelector:@selector(searchViewController:didSelectedCell:)]) {
        [_delegate searchViewController:self didSelectedCell:locationObject];
    }
}

#pragma mark - AMapSearchDelegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    //AMapPOI对象数组
    DLog(response.pois);
    
    _aMapPOIs = response.pois;
    [_tableView reloadData];
}

#pragma mark - target action
//取消
- (void)cancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏键盘
- (void)keyboardHidden
{
    [_textField resignFirstResponder];
}

//UITextField监控输入文字变化方法
- (void)textChangeAction:(id)sender
{
    if ([_textField.text isEmpty] || !_textField.text)
    {
        _tableView.hidden = YES;
    }
    else
    {
        _tableView.hidden = NO;
        
        //高德POI
        [self run_poiSearch];
    }
}

@end
