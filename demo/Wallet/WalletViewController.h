//
//  WalletViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PayViewController.h"
#import "ReturnDepositViewController.h"
#import "PayDepositViewController.h"

@class WalletViewController;
@protocol WalletViewControllerDelegate <NSObject>

//充值成功, 余额变化
- (void)walletViewController:(WalletViewController *)walletViewController paySuccess:(NSString *)money;

@end

@interface WalletViewController : BaseViewController <ReturnDepositViewControllerDelegate, PayDepositViewControllerDelegate, PayViewControllerDelegate>

//背景view
@property (strong, nonatomic) UIView *backgroudView;

//充值按钮
@property (strong, nonatomic) UIButton *payBtn;
//交押金按钮
@property (strong, nonatomic) UIButton *payDepositBtn;

//余额label
@property (strong, nonatomic) UILabel *moneyLabel;

//协议label
@property (strong, nonatomic) UILabel *agreementLabel;

@property (weak, nonatomic) id<WalletViewControllerDelegate> delegate;
@end
