//
//  PayViewController.m
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "PayViewController.h"

@implementation PayViewController
{
    //选择的价格
    NSString *_selectedMoney;
    
    //选择的充值平台类型(默认微信)
    PayStyle _payStyle;
}

#pragma mark - tool
//微信支付(核心)
- (void)pay:(PayObject *)payObject
{
    [k_NSUserDefaults setObject:payObject.orderId forKey:@"pay_orderId"];
    [k_NSUserDefaults synchronize];
    
    /**
     {
     "sign": "A436506ED8B7C0DF5B1B0CC262A7AC13",
     "appid": "wx517a8d83d6b4b67b",
     "noncestr": "9fsuzp5xc1aiu22dooecaqqoca8l1oo3",
     "packageKey": "Sign\u003dWXPay",
     "partnerid": "1448841002",
     "prepayid": "wx20170325151548570165bd1e0350807938",
     "params": "appid\u003dwx517a8d83d6b4b67b\u0026noncestr\u003d9fsuzp5xc1aiu22dooecaqqoca8l1oo3\u0026package\u003dSign\u003dWXPay\u0026partnerid\u003d1448841002\u0026prepayid\u003dwx20170325151548570165bd1e0350807938\u0026timestamp\u003d1490426148",
     "timeStamp": "1490426148"
     }
     */
    
    
    PayReq *request = [[PayReq alloc] init];
    
    /** 商家向财付通申请的商家id */
    request.partnerId = payObject.partnerid;
    /** 预支付订单 */
    request.prepayId= payObject.prepayid;
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = payObject.packageKey;
    /** 随机串，防重发 */
    request.nonceStr = payObject.noncestr;
    /** 时间戳，防重发 */
    request.timeStamp = (UInt32)[payObject.timeStamp integerValue];
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign = payObject.sign;
    
    [WXApi sendReq:request];
}

//微信支付
- (void)pay_wechat
{
    [[HUDHelper sharedInstance] loading];
    //12.充值
    [[APIService sharedInstance] pay_payType:PayType_wechat money:_selectedMoney success:^(PayObject *payObject) {
        
        DLog(payObject);
//        [[HUDHelper sharedInstance] stopLoading];

        //微信支付(核心)
        [self pay:payObject];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
    return;
    
    

    
    
    
    
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [UIAlertView showWithMessage:@"没有安装微信"];
        return;
    }
}

//支付宝支付
- (void)pay_alipay
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [UIAlertView showWithMessage:@"没有安装支付宝"];
        return;
    }
    
    [UIAlertView showWithMessage:@"暂不支持支付宝充值"];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.showNaviDismissItem = YES;
    self.title = @"充值金额";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    //提交按钮
    [self init_submitBtn];
    
    //_textField
    [self _textField];
    
    [self _moneyView1];
    [self _moneyView2];
    [self _moneyView3];
    [self _moneyView4];
    
    //微信
    [self _wechatPayView];
    //支付宝
    [self _alipayPayView];
    
    //协议label
    [self initAgreementLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //微信支付结果通知 (必须写在这里, 否则会收到多次通知)
    [k_NSNotificationCenter addObserver:self selector:@selector(pay_noti:) name:@"pay_noti" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [k_NSNotificationCenter removeObserver:self];
}

- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
//提交按钮
- (void)init_submitBtn
{
    _submitBtn = [UIButton buttonWithType:0];
    _submitBtn.width = SCREEN_WIDTH - 4*kGap;
    _submitBtn.height = 44;
    _submitBtn.top = SCREEN_HEIGHT - _submitBtn.height - 1.5*kGap;
    _submitBtn.left = 2*kGap;
    [self.view addSubview:_submitBtn];
    
    [_submitBtn jk_cornerRadius:4 strokeSize:0 color:nil];
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [_submitBtn setTitle:@"确认" forState:0];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_submitBtn addTarget:self action:@selector(_submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//_textField
- (void)_textField
{
    _textField = [UITextField new];
    _textField.left = kGap;
    _textField.top = kGap + k_NaviH;
    _textField.width = SCREEN_WIDTH - 2*kGap;
    _textField.height = 44;
    [self.view addSubview:_textField];
    
    
    _textField.jk_maxLength = 3;
    _textField.keyboardType = UIKeyboardTypeNumberPad; //测试2
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"请输入充值金额(元)";
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.font = [UIFont systemFontOfSize:16];
    [_textField addTarget:self action:@selector(keyboardHidden) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(textChangeAction:) forControlEvents:UIControlEventEditingChanged];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    
    //左边间距
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kGap, 0)];
}

- (void)_moneyView1
{
    _moneyView1 = [[MoneyView alloc] initWithFrame:CGRectMake(kGap, _textField.bottom + kGap, (SCREEN_WIDTH - 3*kGap)/2, _textField.height) money:@"0.01" selected:NO]; //测试2
    [self.view addSubview:_moneyView1];
    
    _moneyView1.delegate = self;
}

- (void)_moneyView2
{
    _moneyView2 = [[MoneyView alloc] initWithFrame:_moneyView1.frame money:@"10" selected:NO];
    _moneyView2.left = _moneyView1.right + kGap;
    [self.view addSubview:_moneyView2];
    
    _moneyView2.delegate = self;
}

- (void)_moneyView3
{
    _moneyView3 = [[MoneyView alloc] initWithFrame:_moneyView1.frame money:@"20" selected:NO];
    _moneyView3.top = _moneyView1.bottom + kGap;
    [self.view addSubview:_moneyView3];
    
    _moneyView3.delegate = self;
}

- (void)_moneyView4
{
    _moneyView4 = [[MoneyView alloc] initWithFrame:_moneyView3.frame money:@"30" selected:NO];
    _moneyView4.left = _moneyView3.right + kGap;
    [self.view addSubview:_moneyView4];
    
    _moneyView4.delegate = self;
}

//微信
- (void)_wechatPayView
{
    _wechatPayView = [[PayView alloc] initWithFrame:CGRectMake(kGap - 4, _moneyView4.bottom + 2.5*kGap, SCREEN_WIDTH, 50) payStyle:PayStyle_wechat selected:YES];
    [self.view addSubview:_wechatPayView];
    
    _wechatPayView.delegate = self;
}

//支付宝
- (void)_alipayPayView
{
    _alipayPayView = [[PayView alloc] initWithFrame:_wechatPayView.frame payStyle:PayStyle_alipay selected:NO];
    _alipayPayView.top = _wechatPayView.bottom + kGap;
    [self.view addSubview:_alipayPayView];
    
    _alipayPayView.delegate = self;
}

//协议label
- (void)initAgreementLabel
{
    _agreementLabel = [UILabel new];
    _agreementLabel.bottom = _submitBtn.top - 30;
    _agreementLabel.width = SCREEN_WIDTH;
    _agreementLabel.centerX = self.view.centerX;
    [self.view addSubview:_agreementLabel];
    
    //高度自适应
    NSString *text = @"点击充值, 即表示已阅读并同意《充值协议》";
    UIFont *font = [UIFont systemFontOfSize:13];
    _agreementLabel.text = text;
    _agreementLabel.font = font;
    [_agreementLabel adjustHeight:0];
    [_agreementLabel adjustWidth];
    _agreementLabel.centerX = self.view.centerX;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, 15)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#2f9af0"] range:NSMakeRange(15, 6)];
    _agreementLabel.attributedText = attributedString;
    
    _agreementLabel.enabledTapEffect = NO;//设置是否有点击效果，默认是YES
    [_agreementLabel yb_addAttributeTapActionWithStrings:@[@"《充值协议》"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        MyBaseWebViewController *vc = [[MyBaseWebViewController alloc] initWithTitle:@"充值协议"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - MoneyViewDelegate
//点击了MoneyView
- (void)moneyViewDidSelected:(MoneyView *)moneyView
{
    _moneyView1.selected = NO;
    [_moneyView1 judgeIfSelected];
    
    _moneyView2.selected = NO;
    [_moneyView2 judgeIfSelected];
    
    _moneyView3.selected = NO;
    [_moneyView3 judgeIfSelected];
    
    _moneyView4.selected = NO;
    [_moneyView4 judgeIfSelected];
    
    //选择的价格
    _selectedMoney = moneyView.money;
    
    _textField.text = _selectedMoney;
    [self keyboardHidden];
}

#pragma mark - PayViewDelegate
//点击了PayView
- (void)payViewDidSelected:(PayView *)payView
{
    _wechatPayView.selected = NO;
    [_wechatPayView judgeIfSelected];
    
    _alipayPayView.selected = NO;
    [_alipayPayView judgeIfSelected];
    
    //选择的充值平台类型(默认微信)
    _payStyle = payView.payStyle;
    
    [self keyboardHidden];
}

#pragma mark - target action
//UITextField监控输入文字变化方法
- (void)textChangeAction:(id)sender
{
    _moneyView1.selected = NO;
    [_moneyView1 judgeIfSelected];
    
    _moneyView2.selected = NO;
    [_moneyView2 judgeIfSelected];
    
    _moneyView3.selected = NO;
    [_moneyView3 judgeIfSelected];
    
    _moneyView4.selected = NO;
    [_moneyView4 judgeIfSelected];
    
    //选择的价格
    _selectedMoney = _textField.text;
}


//提交按钮
- (void)_submitBtnClick
{
    if ([_selectedMoney isEmpty] || !_selectedMoney) {
        [UIAlertView showWithMessage:@"请输入或选择充值金额"];
        return;
    }
    
    if ([_selectedMoney doubleValue] == 0) {
        [UIAlertView showWithMessage:@"充值金额不能为0"];
        return;
    }

    DLog(_selectedMoney);
    
    
    
    
    
    if (_payStyle == PayStyle_wechat) {
        //微信支付
        [self pay_wechat];
    }
    
    if (_payStyle == PayStyle_alipay) {
        //支付宝支付
        [self pay_alipay];
    }
}

//隐藏键盘
- (void)keyboardHidden
{
    [_textField resignFirstResponder];
}

#pragma mark - notification
//微信支付结果通知
- (void)pay_noti:(NSNotification *)noti
{
    //    WXErrCode:
    //
    //    WXSuccess           = 0,    /**< 成功    */
    //    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    //    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    //    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    //    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    //    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
    PayResp *resp = noti.object;
    
    if (resp.errCode == WXSuccess)
    {
        //支付成功
        if ([_delegate respondsToSelector:@selector(payViewController:paySuccess:)]) {
            [_delegate payViewController:self paySuccess:_selectedMoney];
        }
    }
}

@end
