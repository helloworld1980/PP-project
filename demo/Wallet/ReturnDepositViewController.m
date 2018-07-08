//
//  ReturnDepositViewController.m
//  demo
//
//  Created by liman on 3/13/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "ReturnDepositViewController.h"

@implementation ReturnDepositViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"退押金";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    //说明label
    [self _label];
    
    //ok按钮
    [self _okBtn];
    //取消按钮
    [self _cancelBtn];
}

#pragma mark - private
//说明label
- (void)_label
{
    _label = [UILabel new];
    _label.width = SCREEN_WIDTH - 40;
    _label.top = k_NaviH + 60;
    _label.left = 20;
    [self.view addSubview:_label];
    
    _label.text = @"押金退款时间为2-7个工作日, 在此期间将无法租借移动电源, 押金将原路退回。 确定退押金吗?";
    _label.textColor = [UIColor colorWithHexString:@"#666666"];
    _label.font = [UIFont systemFontOfSize:15];
    [_label adjustHeight:0];
}

//ok按钮
- (void)_okBtn
{
    _okBtn = [UIButton buttonWithType:0];
    _okBtn.height = 44;
    _okBtn.width = (SCREEN_WIDTH - 3*kGap) / 2;
    _okBtn.top = _label.bottom + 60;
    _okBtn.right = SCREEN_WIDTH - kGap;
    [self.view addSubview:_okBtn];
    
    
    [_okBtn jk_cornerRadius:_okBtn.height/2 strokeSize:0 color:nil];
    [_okBtn addTarget:self action:@selector(_okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_okBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1dbe61"]] forState:0];
    [_okBtn setTitle:@"确定" forState:0];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:0];
}

//取消按钮
- (void)_cancelBtn
{
    _cancelBtn = [UIButton buttonWithType:0];
    _cancelBtn.frame = _okBtn.frame;
    _cancelBtn.left = kGap;
    [self.view addSubview:_cancelBtn];
    
    
    [_cancelBtn jk_cornerRadius:_cancelBtn.height/2 strokeSize:0 color:nil];
    [_cancelBtn addTarget:self action:@selector(_cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#9a9a9a"]] forState:0];
    [_cancelBtn setTitle:@"取消" forState:0];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
}

#pragma mark - target action
//确定
- (void)_okBtnClick
{
    [[HUDHelper sharedInstance] loading];
    //14.退押金
    [[APIService sharedInstance] returnDeposit:^{
        
        [[HUDHelper sharedInstance] stopLoading];
        
        [UIAlertView showWithMessage:@"退押金成功" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if ([_delegate respondsToSelector:@selector(returnDepositViewControllerDidReturnDeposit:)]) {
                [_delegate returnDepositViewControllerDidReturnDeposit:self];
            }
        }];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

//取消
- (void)_cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
