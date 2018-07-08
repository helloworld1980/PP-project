//
//  SettingViewController.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "ContactViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

#pragma mark - tool
//退出APP
- (void)logoutAction
{
    [[HUDHelper sharedInstance] loading];
    //4.退出登录
    [[APIService sharedInstance] logout:^{
        
        //我的bug
        GCD_DELAY_AFTER(0.5, ^{
            [[HUDHelper sharedInstance] stopLoading];
            
            [k_NSUserDefaults setBool:NO forKey:@"login"];
            [k_NSUserDefaults synchronize];

            k_UIApplication.keyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        });
     
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.showNaviDismissItem = YES;
    
    //退出登录按钮
    [self initLogoutBtn];
    //版本label
    [self init_versionLabel];
    
    
    
    
    SettingItem *item1 = [SettingItem itemWithTitle:@"意见反馈" subTitle:nil image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item2 = [SettingItem itemWithTitle:@"联系我们" subTitle:nil image:nil switchType:0 accessoryType:0 center:NO];
    SettingItem *item3 = [SettingItem itemWithTitle:@"关于PP充电" subTitle:nil image:nil switchType:0 accessoryType:0 center:NO];
    
    self.cells = @[
                   @[item1],
                   @[item2],
                   @[item3],
                   ];
}

#pragma mark - private
//退出登录按钮
- (void)initLogoutBtn
{
    _logoutBtn = [UIButton buttonWithType:0];
    _logoutBtn.height = 44;
    _logoutBtn.width = SCREEN_WIDTH * 3/4;
    _logoutBtn.centerX = self.view.centerX;
    _logoutBtn.top = 300;
    [self.view addSubview:_logoutBtn];
    
    
    [_logoutBtn jk_cornerRadius:_logoutBtn.height/2 strokeSize:0 color:nil];
    [_logoutBtn addTarget:self action:@selector(_logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#9a9a9a"]] forState:0];
    [_logoutBtn setTitle:@"退出" forState:0];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:0];
}

//版本label
- (void)init_versionLabel
{
    _versionLabel = [UILabel new];
    _versionLabel.width = SCREEN_WIDTH;
    _versionLabel.height = 20;
    _versionLabel.centerX = self.view.centerX;
    _versionLabel.top = SCREEN_HEIGHT - _versionLabel.height - 14;
    [self.view addSubview:_versionLabel];
    
    _versionLabel.font = [UIFont systemFontOfSize:16];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _versionLabel.text = [NSString stringWithFormat:@"版本V%@",[UIDeviceHardware appVersion]];
}

#pragma mark - 父类方法
- (UITableViewCell *)settingTableView:(UITableView *)tableView settingItem:(SettingItem *)item cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseSettingCell class])];
    if (!cell) {
        cell  = [[BaseSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([BaseSettingCell class])];
    }
    
    cell.item = item;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        //意见反馈
        [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
    }
    if (indexPath.section == 1)
    {
        //联系我们
        [self.navigationController pushViewController:[ContactViewController new] animated:YES];
    }
    if (indexPath.section == 2)
    {
        //关于
        [self.navigationController pushViewController:[AboutViewController new] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor darkGrayColor];
    
    return view;
}

#pragma mark - target action
//退出登录
- (void)_logoutBtnClick
{
    [UIAlertView showWithTitle:nil message:@"您是否要退出应用?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            //退出APP
            [self logoutAction];
        }
    }];
}

@end
