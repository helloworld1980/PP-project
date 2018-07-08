//
//  RecordViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "RecordViewController.h"

@implementation RecordViewController
{
    //订单列表models
    NSArray *_orderObjects;
}

#pragma mark - tool
//网络请求
- (void)requestNetwork
{
    [[HUDHelper sharedInstance] loading];
    //22.获取用户订单列表
    [[APIService sharedInstance] getOrderObjects_lastOrderId:@"0" success:^(NSArray *orderObjects) {
        
        [[HUDHelper sharedInstance] stopLoading];
        
        _orderObjects = orderObjects;
        [_tableView reloadData];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"交易记录";
    
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
    return [_orderObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyBaseCell class])];
    if (!cell) {
        cell = [[MyBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MyBaseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBaseCellStyle = MyBaseCellStyle_1;
    cell.orderObject = _orderObjects[indexPath.row];
    
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
    
    OrderObject *orderObject = _orderObjects[indexPath.row];
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //23.获取订单详情
    [[APIService sharedInstance] getOrderDetail_orderId:orderObject.Id success:^(OrderObject *orderObject) {
        
        DLog(orderObject);
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"23.获取订单详情 API接口请求成功"];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

@end
