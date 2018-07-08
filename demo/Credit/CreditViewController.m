//
//  CreditViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "CreditViewController.h"

@implementation CreditViewController
{
    NSString *_score;
}

#pragma mark - public
//传值: 信用分
- (instancetype)initWithScore:(NSString *)score
{
    self = [super init];
    if (self) {
        _score = score;
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"我的信用分";
    self.naviBarView.backgroundColor = [UIColor colorWithHexString:@"#2f93df"];

    //自定义导航栏item
    [self customNaviItem];
    
    //tableview
    [self init_tableView];
    
    //测试2
    [UIAlertView showWithMessage:@"此界面暂无API接口支持!"];
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:@"规则" titleFont:[UIFont systemFontOfSize:16] normalTitleColor:[UIColor whiteColor] highlightTitleColor:nil normalImage:nil highlightImage:nil action:@selector(ruleClick) frame:CGRectMake(SCREEN_WIDTH - 46, 33, 40, 20) tag:nil];
}

#pragma mark - private
//tableview
- (void)init_tableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH) style:UITableViewStyleGrouped];//必须是UITableViewStyleGrouped, 否则headerView不跟随cell滑动
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyBaseCell class])];
    if (!cell) {
        cell = [[MyBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MyBaseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBaseCellStyle = MyBaseCellStyle_2;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CreditHeaderView *headerView = [[CreditHeaderView alloc] initWithHeight:200 - 12 score:_score];
    headerView.tag = 1001;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200 - 12;//CreditHeaderView高度
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat yPos = -scrollView.contentOffset.y;
        if (yPos > 0) {
            
            CreditHeaderView *headerView = [self.view viewWithTag:1001];
            
            CGRect imgRect = headerView.bgImageView.frame;
            imgRect.origin.y = scrollView.contentOffset.y;
            imgRect.size.height = headerView.height + yPos;
            headerView.bgImageView.frame = imgRect;
        }
    }
}

#pragma mark - target action
//规则
- (void)ruleClick
{
    MyBaseWebViewController *vc = [[MyBaseWebViewController alloc] initWithTitle:@"信用积分规则"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
