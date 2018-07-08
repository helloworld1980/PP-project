//
//  MyFriendViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyFriendViewController.h"

@implementation MyFriendViewController
{
   //好友列表
    NSArray *_friendObjects;
}

#pragma mark - tool
//网络请求
- (void)requestNetwork
{
    [[HUDHelper sharedInstance] loading];
    //19.获取用户好友
    [[APIService sharedInstance] getFriendObjects:^(NSArray *friendObjects) {
        
        [[HUDHelper sharedInstance] stopLoading];
        
        if (friendObjects && [friendObjects count] > 0)
        {
            _friendObjects = friendObjects;
            [_tableView reloadData];
            
            _tableView.hidden = NO;
        }
        
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
    self.title = @"我的好友";
    self.view.clipsToBounds = YES;//这个属性必须打开否则返回的时候会出现黑边
    
    //背景imageView
    [self init_backgroudImageView];
    
    //tableview
    [self init_tableView];
    
    //网络请求
    [self requestNetwork];
}

#pragma mark - private
//背景imageView
- (void)init_backgroudImageView
{
    //图片
    _backgroudImageView = [UIImageView new];
    _backgroudImageView.width = 750/2;
    _backgroudImageView.height = 396/2;
    _backgroudImageView.centerX = self.view.centerX;
    _backgroudImageView.top = k_NaviH;
    _backgroudImageView.image = [UIImage imageNamed:@"pic2"];
    [self.view addSubview:_backgroudImageView];
    
    
    //暂无好友imageview
    UIImageView *imageView2 = [UIImageView new];
    imageView2.width = 280/2;
    imageView2.height = 60/2;
    imageView2.centerX = self.view.centerX;
    imageView2.top = SCREEN_HEIGHT / 2;
    imageView2.image = [UIImage imageNamed:@"no_friend"];
    [self.view addSubview:imageView2];
}

//tableview
- (void)init_tableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH) style:UITableViewStyleGrouped];//必须是UITableViewStyleGrouped, 否则headerView不跟随cell滑动
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
    return [_friendObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyBaseCell class])];
    if (!cell) {
        cell = [[MyBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MyBaseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBaseCellStyle = MyBaseCellStyle_4;
    cell.friendObject = _friendObjects[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
