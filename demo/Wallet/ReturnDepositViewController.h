//
//  ReturnDepositViewController.h
//  demo
//
//  Created by liman on 3/13/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@class ReturnDepositViewController;
@protocol ReturnDepositViewControllerDelegate <NSObject>

//申请了退押金
- (void)returnDepositViewControllerDidReturnDeposit:(ReturnDepositViewController *)returnDepositViewController;

@end

@interface ReturnDepositViewController : BaseViewController

//说明label
@property (strong, nonatomic) UILabel *label;

//ok按钮
@property (strong, nonatomic) UIButton *okBtn;
//取消按钮
@property (strong, nonatomic) UIButton *cancelBtn;

@property (weak, nonatomic) id<ReturnDepositViewControllerDelegate> delegate;
@end
