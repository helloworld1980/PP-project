//
//  PayViewController.h
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MoneyView.h"
#import "PayView.h"

@class PayViewController;
@protocol PayViewControllerDelegate <NSObject>

//充值成功
- (void)payViewController:(PayViewController *)payViewController paySuccess:(NSString *)money;

@end

@interface PayViewController : BaseViewController <MoneyViewDelegate, PayViewDelegate>

//提交按钮
@property (strong, nonatomic) UIButton *submitBtn;

//textField
@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) MoneyView *moneyView1;
@property (strong, nonatomic) MoneyView *moneyView2;
@property (strong, nonatomic) MoneyView *moneyView3;
@property (strong, nonatomic) MoneyView *moneyView4;

//微信
@property (strong, nonatomic) PayView *wechatPayView;
//支付宝
@property (strong, nonatomic) PayView *alipayPayView;

//协议label
@property (strong, nonatomic) UILabel *agreementLabel;

@property (weak, nonatomic) id<PayViewControllerDelegate> delegate;
@end
