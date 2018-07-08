//
//  MessageViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearbyCell.h"

@implementation NearbyViewController
{
    //充电桩数组
    NSArray *_stationObjects;
}

#pragma mark - tool
//网络请求
- (void)requestNetwork
{
    //地图缓存(GPS坐标)
    NSString *latitude = [k_NSUserDefaults objectForKey:@"latitude"];
    NSString *longitude = [k_NSUserDefaults objectForKey:@"longitude"];
    
    if (latitude && longitude)
    {
        //GPS坐标-->火星坐标
        CLLocation *gpsLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        CLLocation *marsLocation = [gpsLocation locationEarthToMars];
        
        
        [[HUDHelper sharedInstance] loading];
        //7.搜索附近的充电桩
        [[APIService sharedInstance] searchStationObjects_latitude:marsLocation.coordinate.latitude longitude:marsLocation.coordinate.longitude scope:1000 countNo:10 success:^(NSArray *stationObjects) {
            
            [[HUDHelper sharedInstance] stopLoading];
            _stationObjects = stationObjects;
            
            [_tableView reloadData];
            
        } failure:^(NSString *errorStatus, NSString *errorMsg) {
            [[HUDHelper sharedInstance] stopLoading];
            [UIAlertView showWithMessage:errorMsg];
        }];
    }
    else
    {
        [UIAlertView showWithMessage:@"获取我的位置信息失败" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"附近电源";
    
    //tableview
    [self init_tableView];
    
    //网络请求
    [self requestNetwork];
}

#pragma mark - private
//tableview
- (void)init_tableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_stationObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NearbyCell class])];
    if (!cell) {
        cell = [[NearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NearbyCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _stationObjects[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StationObject *stationObject = _stationObjects[indexPath.row];
    
    
    
    [[HUDHelper sharedInstance] loading];
    //8.获取充电桩详细信息
    [[APIService sharedInstance] getStationDetail_stationId:stationObject.Id success:^(StationObject *stationObject) {
        
        DLog(stationObject);
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"8.获取充电桩详细信息 API接口请求成功"];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

@end
