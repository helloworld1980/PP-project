//
//  SettingViewController.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
#import "GuideViewController.h"
#import "InviteFriendViewController.h"
#import "RecordViewController.h"
#import "MessageViewController.h"
#import "CreditViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;

    
    
    SettingItem *item1 = [SettingItem itemWithTitle:@"钱包" subTitle:nil image:[UIImage imageNamed:@"wallet"] switchType:0 accessoryType:1 center:NO];
    SettingItem *item2 = [SettingItem itemWithTitle:@"记录" subTitle:nil image:[UIImage imageNamed:@"record"] switchType:0 accessoryType:1 center:NO];
    SettingItem *item3 = [SettingItem itemWithTitle:@"消息" subTitle:nil image:[UIImage imageNamed:@"message"] switchType:0 accessoryType:1 center:NO];
    SettingItem *item4 = [SettingItem itemWithTitle:@"好友" subTitle:nil image:[UIImage imageNamed:@"friend"] switchType:0 accessoryType:1 center:NO];
    SettingItem *item5 = [SettingItem itemWithTitle:@"指南" subTitle:nil image:[UIImage imageNamed:@"guide"] switchType:0 accessoryType:1 center:NO];
    SettingItem *item6 = [SettingItem itemWithTitle:@"设置" subTitle:nil image:[UIImage imageNamed:@"setting"] switchType:0 accessoryType:1 center:NO];
    
    
    self.cells = @[
                   @[item1, item2, item3, item4, item5, item6],
                   ];
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
    
    if (indexPath.row == 0)
    {
        //钱包
        WalletViewController *vc = [WalletViewController new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1)
    {
        //记录
        [self.navigationController pushViewController:[RecordViewController new] animated:YES];
    }
    if (indexPath.row == 2)
    {
        //消息
        [self.navigationController pushViewController:[MessageViewController new] animated:YES];
    }
    if (indexPath.row == 3)
    {
        //好友
        [self.navigationController pushViewController:[InviteFriendViewController new] animated:YES];
    }
    if (indexPath.row == 4)
    {
        //指南
        GuideViewController *vc = [[GuideViewController alloc] initWithTitle:@"用户指南"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 5)
    {
        //设置
        [self.navigationController pushViewController:[SettingViewController new] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 200;//MeHeaderView高度
    }
    
    return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return tableView.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MeHeaderView *headerView = [[MeHeaderView alloc] initWithHeight:200];
    headerView.tag = 1001;
    headerView.delegate = self;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    //    view.backgroundColor = [UIColor darkGrayColor];
    
    return view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat yPos = -scrollView.contentOffset.y;
        if (yPos > 0) {
            
            MeHeaderView *headerView = [self.view viewWithTag:1001];
            
            CGRect imgRect = headerView.bgImageView.frame;
            imgRect.origin.y = scrollView.contentOffset.y;
            imgRect.size.height = headerView.height + yPos;
            headerView.bgImageView.frame = imgRect;
        }
    }
}

#pragma mark - MeHeaderViewDelegate
//点击了头像
- (void)headerView:(MeHeaderView *)headerView didSelectedAvatarImageView:(UIImageView *)avatarImageView
{
    ProfileViewController *vc = [[ProfileViewController alloc] initWithAvatarImage:headerView.avatarImageView.image nickname:headerView.nicknameLabel.text];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击了余额
- (void)headerView:(MeHeaderView *)headerView didSelectedBalanceLabel:(UILabel *)balanceLabel
{
    WalletViewController *vc = [WalletViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击了信用
- (void)headerView:(MeHeaderView *)headerView didSelectedCreditLabel:(UILabel *)creditLabel
{
    CreditViewController *vc = [[CreditViewController alloc] initWithScore:[BalanceObject sharedInstance].credit];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ProfileViewControllerDelegate
//头像更改
- (void)profileViewController:(ProfileViewController *)profileViewController newAvatarImage:(UIImage *)avatarImage
{
    MeHeaderView *headerView = (MeHeaderView *)[self.view viewWithTag:1001];
    headerView.avatarImageView.image = avatarImage;
}

//昵称更改
- (void)profileViewController:(ProfileViewController *)profileViewController newNickname:(NSString *)nickname
{
    MeHeaderView *headerView = (MeHeaderView *)[self.view viewWithTag:1001];
    headerView.nicknameLabel.text = nickname;
}

#pragma mark - WalletViewControllerDelegate
//充值成功, 余额变化
- (void)walletViewController:(WalletViewController *)walletViewController paySuccess:(NSString *)money
{
    MeHeaderView *headerView = (MeHeaderView *)[self.view viewWithTag:1001];
    headerView.balanceLabel.text = [NSString stringWithFormat:@"余额%@元", money];
    
    [BalanceObject sharedInstance].balance = money;
}

@end
