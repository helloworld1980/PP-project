//
//  DepositViewController.h
//  demo
//
//  Created by liman on 3/13/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PayView.h"

@class PayDepositViewController;
@protocol PayDepositViewControllerDelegate <NSObject>

//押金充值成功
- (void)payDepositViewController:(PayDepositViewController *)payDepositViewController paySuccess:(NSString *)money;

@end

@interface PayDepositViewController : BaseViewController <PayViewDelegate>

@property (strong, nonatomic) UIImageView *imageview;

//提交按钮
@property (strong, nonatomic) UIButton *submitBtn;

//微信
@property (strong, nonatomic) PayView *wechatPayView;
//支付宝
@property (strong, nonatomic) PayView *alipayPayView;

//协议label
@property (strong, nonatomic) UILabel *agreementLabel;

//押金label
@property (strong, nonatomic) UILabel *depositLabel;

@property (weak, nonatomic) id <PayDepositViewControllerDelegate> delegate;
@end
