//
//  MessageViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MessageViewController.h"

@implementation MessageViewController
{
    //消息列表models
    NSArray *_messageObjects;
}

#pragma mark - tool
//网络请求
- (void)requestNetwork
{
    [[HUDHelper sharedInstance] loading];
    //27.消息列表
    [[APIService sharedInstance] getMessageObjects_pageNO:0 success:^(NSArray *messageObjects) {
        
        [[HUDHelper sharedInstance] stopLoading];
        
        _messageObjects = messageObjects;
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
    self.title = @"消息";
    
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
    return [_messageObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyBaseCell class])];
    if (!cell) {
        cell = [[MyBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MyBaseCell class])];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myBaseCellStyle = MyBaseCellStyle_0;
    cell.messageObject = _messageObjects[indexPath.row];
    
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
    
    MessageObject *messageObject = _messageObjects[indexPath.row];
    
    MessageDetailViewController *vc = [[MessageDetailViewController alloc] initWithMessageObject:messageObject];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //28.标记消息已读
    [[APIService sharedInstance] setMessageRead_messageId:messageObject.Id success:^(NSString *message) {
        
        DLog(message);
        messageObject.status = @"READ";
//        messageObject.title = message;
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
    }];
}

#pragma mark - MessageDetailViewControllerDelegate
//消息已读
- (void)messageDetailViewController:(MessageDetailViewController *)messageDetailViewController didReadMessage:(MessageObject *)messageObject
{
    [_tableView reloadData];
}

@end
