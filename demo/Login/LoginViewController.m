//
//  LoginViewController.m
//  demo
//
//  Created by liman on 3/8/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "JKCountDownButton.h"
#import "MapViewController.h"

@implementation LoginViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    //手机号view
    [self initPhoneNumView];
    //密码view
    [self initPasswordView];
    
    //手机号textField
    [self initPhoneNumTextField];
    //密码textField
    [self initPasswordTextField];
    
    //+86 imageView
    [self init86ImageView];
    //发送验证码
    [self initCountDownBtn];
    
    //登录按钮
    [self initLoginBtn];
    
    //协议label
    [self initAgreementLabel];
    
    
    _phoneNumTextField.left = 70;
    _phoneNumTextField.width = _phoneNumView.width - 74;
    
    _phoneNumTextField.text = [k_NSUserDefaults objectForKey:@"phone"];
}

#pragma mark - private
//手机号view
- (void)initPhoneNumView
{
    _phoneNumView = [UIView new];
    _phoneNumView.height = 44;
    _phoneNumView.width = SCREEN_WIDTH * 3/4;
    _phoneNumView.top = k_NaviH + _phoneNumView.height/2;
    _phoneNumView.centerX = self.view.centerX;
    [self.view addSubview:_phoneNumView];
    
    [_phoneNumView jk_cornerRadius:_phoneNumView.height/2 strokeSize:1 color:[UIColor colorWithHexString:@"#e5e5e5"]];
}

//密码view
- (void)initPasswordView
{
    _passwordView = [UIView new];
    _passwordView.frame = _phoneNumView.frame;
    _passwordView.top = _phoneNumView.bottom + 10;
    [self.view addSubview:_passwordView];
    
    [_passwordView jk_cornerRadius:_passwordView.height/2 strokeSize:1 color:[UIColor colorWithHexString:@"#e5e5e5"]];
}

//手机号textField
- (void)initPhoneNumTextField
{
    _phoneNumTextField = [UITextField new];
    _phoneNumTextField.width = _phoneNumView.width - 25;
    _phoneNumTextField.height = _phoneNumView.height - 20;
    _phoneNumTextField.top = 10;
    _phoneNumTextField.left = 20;
    [_phoneNumView addSubview:_phoneNumTextField];
    
    
//    _phoneNumTextField.backgroundColor = k_RandomColor;
    _phoneNumTextField.textColor = [UIColor colorWithHexString:@"#333333"];
    _phoneNumTextField.jk_maxLength = 11;
    _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumTextField.clearButtonMode = UITextFieldViewModeAlways;
    _phoneNumTextField.placeholder = @"请输入您的手机号";
    _phoneNumTextField.font = [UIFont systemFontOfSize:15];
    [_phoneNumTextField addTarget:self action:@selector(keyboardHidden) forControlEvents:UIControlEventEditingDidEndOnExit];
}

//密码textField
- (void)initPasswordTextField
{
    _passwordTextField = [UITextField new];
    _passwordTextField.frame = _phoneNumTextField.frame;
    _passwordTextField.width = _phoneNumTextField.width - 80 - 5;
    [_passwordView addSubview:_passwordTextField];
    
    
//    _passwordTextField.backgroundColor = k_RandomColor;
    _passwordTextField.textColor = [UIColor colorWithHexString:@"#333333"];
    _passwordTextField.jk_maxLength = 6;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"请输入验证码";
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    [_passwordTextField addTarget:self action:@selector(keyboardHidden) forControlEvents:UIControlEventEditingDidEndOnExit];
}

//+86 imageView
- (void)init86ImageView
{
    UIImageView *label = [UIImageView new];
    label.top = 9.3;
    label.left = 16;
    label.width = 96/2;
    label.height = 50/2;
    [_phoneNumView addSubview:label];
    
    label.image = [UIImage imageNamed:@"plus86"];
}

//发送验证码
- (void)initCountDownBtn
{
    JKCountDownButton *countDownBtn = [JKCountDownButton buttonWithType:0];
    countDownBtn.top = _passwordTextField.top;
    countDownBtn.height = _passwordTextField.height;
    countDownBtn.width = 80;
    countDownBtn.left = _passwordTextField.right;
    [_passwordView addSubview:countDownBtn];
    
    
    [countDownBtn jk_cornerRadius:countDownBtn.height/2 strokeSize:0 color:nil];
    [countDownBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [countDownBtn setTitle:@"获取验证码" forState:0];
    countDownBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [countDownBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    
    
    [countDownBtn countDownButtonHandler:^(JKCountDownButton *sender, NSInteger tag) {
        
        if ([_phoneNumTextField.text isEmpty] || !_phoneNumTextField.text) {
            [UIAlertView showWithMessage:@"请输入您的手机号"];
            return;
        }
        if (![_phoneNumTextField.text jk_isMobileNumber]) {
            [UIAlertView showWithMessage:@"手机格式非法"];
            return;
        }
        
        
        
        [[HUDHelper sharedInstance] loading];
        //1.发送验证码
        [[APIService sharedInstance] sendCodeWithPhoneNumber:_phoneNumTextField.text success:^{
            
            [[HUDHelper sharedInstance] tipMessage:@"验证码发放成功"];
            
            sender.enabled = NO;
            [sender startCountDownWithSecond:60];
            [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
                return title;
            }];
            [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
            
        } failure:^(NSString *errorStatus, NSString *errorMsg) {
            
            [[HUDHelper sharedInstance] stopLoading];
            [UIAlertView showWithMessage:errorMsg];
        }];
    }];
}

//登录按钮
- (void)initLoginBtn
{
    _loginBtn = [UIButton buttonWithType:0];
    _loginBtn.frame = _phoneNumView.frame;
    _loginBtn.top = _passwordView.bottom + 50;
    [self.view addSubview:_loginBtn];
    
    
    [_loginBtn jk_cornerRadius:_loginBtn.height/2 strokeSize:0 color:nil];
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [_loginBtn setTitle:@"登录" forState:0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
}

//协议label
- (void)initAgreementLabel
{
    _agreementLabel = [UILabel new];
    _agreementLabel.top = _loginBtn.bottom + 20;
    _agreementLabel.width = _loginBtn.width;
    _agreementLabel.centerX = self.view.centerX;
    [self.view addSubview:_agreementLabel];
    
    //高度自适应
    NSString *text = @"点击登录, 即表示已阅读并同意《PP充电用户协议》";
    UIFont *font = [UIFont systemFontOfSize:13];
    _agreementLabel.text = text;
    _agreementLabel.font = font;
    [_agreementLabel adjustHeight:0];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 15)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:k_MainColor range:NSMakeRange(15, 10)];
    _agreementLabel.attributedText = attributedString;
    
    _agreementLabel.enabledTapEffect = NO;//设置是否有点击效果，默认是YES
    [_agreementLabel yb_addAttributeTapActionWithStrings:@[@"《PP充电用户协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        MyBaseWebViewController *vc = [[MyBaseWebViewController alloc] initWithTitle:@"PP充电用户协议"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - target action
//登录
- (void)loginBtnClick
{
    if ([_phoneNumTextField.text isEmpty] || !_phoneNumTextField.text) {
        [UIAlertView showWithMessage:@"请输入您的手机号"];
        return;
    }
    if ([_passwordTextField.text isEmpty] || !_passwordTextField.text) {
        [UIAlertView showWithMessage:@"请输入验证码"];
        return;
    }
    if (![_phoneNumTextField.text jk_isMobileNumber]) {
        [UIAlertView showWithMessage:@"手机格式非法"];
        return;
    }
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //2.登录
    [[APIService sharedInstance] loginWithPhoneNumber:_phoneNumTextField.text code:_passwordTextField.text success:^{
        
        [[HUDHelper sharedInstance] stopLoading];
        
        [k_NSUserDefaults setBool:YES forKey:@"login"];
        [k_NSUserDefaults synchronize];
        
        k_UIApplication.keyWindow.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[MapViewController new]];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

//隐藏键盘
- (void)keyboardHidden
{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
