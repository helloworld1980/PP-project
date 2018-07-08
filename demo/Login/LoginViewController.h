//
//  LoginViewController.h
//  demo
//
//  Created by liman on 3/8/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

//手机号
@property (strong, nonatomic) UIView *phoneNumView;
@property (strong, nonatomic) UITextField *phoneNumTextField;

//密码
@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UITextField *passwordTextField;

//登录按钮
@property (strong, nonatomic) UIButton *loginBtn;

//协议label
@property (strong, nonatomic) UILabel *agreementLabel;

@end
