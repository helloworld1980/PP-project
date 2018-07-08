//
//  WalletViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kMoveH 24

#import "WalletViewController.h"
#import "RecordViewController.h"

@implementation WalletViewController
{
    //是否需要交押金
    BOOL _needPayDeposit;
}

#pragma mark - tool
//判断是否需要交押金
- (void)judgeIfNeedPayDeposit
{
    //适配
    CGFloat xxx = 105;
    if (IS_IPHONE_6) {
        xxx = 204;
    }
    if (IS_IPHONE_6P) {
        xxx = 245;
    }
    if (IS_IPHONE_4_OR_LESS) {
        xxx = 17;
    }
    
    
    
    if ([[BalanceObject sharedInstance].deposit integerValue] == 0)//测试2
    {
        //未交押金
        _needPayDeposit = YES;
    }
    else
    {
        //已交押金
        _needPayDeposit = NO;
    }
    
    //_______________________________________________________________________________________
    
    if (_needPayDeposit)
    {
        //1.需要交押金
        
        //交押金按钮
        [_payDepositBtn removeFromSuperview];
        _payDepositBtn = nil;
        [self init_payDepositBtn];
        
        _payDepositBtn.top = _payBtn.top - kMoveH;
        _payBtn.bottom = _agreementLabel.bottom;
        _backgroudView.height = SCREEN_HEIGHT - kMoveH - 176;
        [self.view viewWithTag:1000].top = xxx;
        
        //协议label
        [_agreementLabel removeFromSuperview];
        _agreementLabel = nil;
    }
    else
    {
        //2.不需要交押金

        //背景view
        [_backgroudView removeFromSuperview];
        _backgroudView = nil;
        [self init_backgroudView];
        
        //充值按钮
        [_payBtn removeFromSuperview];
        _payBtn = nil;
        [self init_payBtn];

        //协议label
        [_agreementLabel removeFromSuperview];
        _agreementLabel = nil;
        [self initAgreementLabel];
        
        //余额label
        [_moneyLabel removeFromSuperview];
        _moneyLabel = nil;
        [self init_moneyLabel];
        
        //交押金按钮
        [_payDepositBtn removeFromSuperview];
        _payDepositBtn = nil;
    }
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"我的钱包";
    self.naviBarView.backgroundColor = [UIColor colorWithHexString:@"#01b5f0"];
    self.view.clipsToBounds = YES;//这个属性必须打开否则返回的时候会出现黑边
    
    //自定义导航栏item
    [self customNaviItem];
    
    //背景view
    [self init_backgroudView];
    
    //充值按钮
    [self init_payBtn];
    //交押金按钮
    [self init_payDepositBtn];
    
    //协议label
    [self initAgreementLabel];
    
    //余额label
    [self init_moneyLabel];
    
    //判断是否需要交押金
    [self judgeIfNeedPayDeposit];
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:@"明细" titleFont:[UIFont systemFontOfSize:16] normalTitleColor:[UIColor whiteColor] highlightTitleColor:nil normalImage:nil highlightImage:nil action:@selector(detailClick) frame:CGRectMake(SCREEN_WIDTH - 46, 33, 40, 20) tag:nil];
}

//背景view
- (void)init_backgroudView
{
    _backgroudView = [UIView new];
    _backgroudView.width = SCREEN_WIDTH;
    _backgroudView.top = k_NaviH;
    _backgroudView.left = 0;
    _backgroudView.height = SCREEN_HEIGHT * 3/4 - k_NaviH - 40;
    _backgroudView.backgroundColor = [UIColor colorWithHexString:@"#01b5f0"];
    [self.view addSubview:_backgroudView];
    
    //图片
    UIImageView *imageView = [UIImageView new];
    imageView.width = 750/2;
    imageView.height = 528/2;
    imageView.centerX = _backgroudView.centerX;
    imageView.bottom = _backgroudView.bottom;
    imageView.image = [UIImage imageNamed:@"qianbao"];
    imageView.tag = 1000;
    [_backgroudView addSubview:imageView];
    
    
    //图片(余额)
    UIImageView *imageView2 = [UIImageView new];
    imageView2.tag = 1001;
    imageView2.width = 114/2;
    imageView2.height = 52/2;
    imageView2.centerX = _backgroudView.centerX;
    imageView2.top = _backgroudView.height / 2 - 50;
    imageView2.image = [UIImage imageNamed:@"yu_e"];
    [_backgroudView addSubview:imageView2];
    
    
    //适配
    if (IS_IPHONE_6P) {
        imageView.width = SCREEN_WIDTH;
        imageView.height = 528 * SCREEN_WIDTH / 750;
        imageView.left = 0;
    }
    if (IS_IPHONE_4_OR_LESS) {
        imageView.top = 30;
    }
}

//充值按钮
- (void)init_payBtn
{
    _payBtn = [UIButton buttonWithType:0];
    _payBtn.height = 44;
    _payBtn.width = SCREEN_WIDTH * 3/4;
    _payBtn.centerX = self.view.centerX;
    _payBtn.top = SCREEN_HEIGHT - _payBtn.height - 52;
    [self.view addSubview:_payBtn];
    
    
    [_payBtn jk_cornerRadius:_payBtn.height/2 strokeSize:0 color:nil];
    [_payBtn addTarget:self action:@selector(_payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_payBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1dbe61"]] forState:0];
    [_payBtn setTitle:@"充值" forState:0];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:0];
}

//交押金按钮
- (void)init_payDepositBtn
{
    _payDepositBtn = [UIButton buttonWithType:0];
    _payDepositBtn.frame = _payBtn.frame;
    [self.view addSubview:_payDepositBtn];
    
    
    [_payDepositBtn jk_cornerRadius:_payDepositBtn.height/2 strokeSize:0 color:nil];
    [_payDepositBtn addTarget:self action:@selector(_payDepositBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_payDepositBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#1dbe61"]] forState:0];
    [_payDepositBtn setTitle:@"缴押金" forState:0];
    [_payDepositBtn setTitleColor:[UIColor whiteColor] forState:0];
}


//协议label
- (void)initAgreementLabel
{
    NSString *money = [k_NSUserDefaults objectForKey:@"deposit"];
    if (!money || [money isEmpty]) {
        money = @"99";//默认押金
    }
    
    NSInteger xxx = 0;
    if ([money integerValue] >= 0 && [money integerValue] <= 9) {
        xxx = 5;
    }
    if ([money integerValue] >= 10 && [money integerValue] <= 99) {
        xxx = 6;
    }
    if ([money integerValue] >=100 && [money integerValue] <= 999) {
        xxx = 7;
    }
    
    //--------------------------------------------------------------------------------------------
    _agreementLabel = [UILabel new];
    _agreementLabel.top = _payBtn.bottom + 20;
    _agreementLabel.width = SCREEN_WIDTH;
    _agreementLabel.centerX = self.view.centerX;
    [self.view addSubview:_agreementLabel];
    
    //高度自适应
    NSString *text = [NSString stringWithFormat:@"押金%@元, 退押金", money];
    UIFont *font = [UIFont systemFontOfSize:13];
    _agreementLabel.text = text;
    _agreementLabel.font = font;
    [_agreementLabel adjustHeight:0];
    [_agreementLabel adjustWidth];
    _agreementLabel.centerX = self.view.centerX;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, xxx)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:k_MainColor range:NSMakeRange(xxx, 4)];
    _agreementLabel.attributedText = attributedString;
    
    _agreementLabel.enabledTapEffect = NO;//设置是否有点击效果，默认是YES
    [_agreementLabel yb_addAttributeTapActionWithStrings:@[@"退押金"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        
        ReturnDepositViewController *vc = [ReturnDepositViewController new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//余额label
- (void)init_moneyLabel
{
    //图片(余额)
    UIImageView *imageView2 = [self.view viewWithTag:1001];
    
    _moneyLabel = [UILabel new];
    _moneyLabel.width = SCREEN_WIDTH;
    _moneyLabel.height = 40;
    _moneyLabel.centerX = self.view.centerX;
    _moneyLabel.bottom = imageView2.top - 14;
    [_backgroudView addSubview:_moneyLabel];
    
    _moneyLabel.text = [NSString stringWithFormat:@"%.1f", [BalanceObject sharedInstance].balance.floatValue];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.font = [UIFont boldSystemFontOfSize:34];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - PayViewControllerDelegate
//充值成功
- (void)payViewController:(PayViewController *)payViewController paySuccess:(NSString *)money
{
    [payViewController.navigationController popViewControllerAnimated:YES];
    
    CGFloat result = [[BalanceObject sharedInstance].balance floatValue] + [money floatValue];
    [BalanceObject sharedInstance].balance = [NSString stringWithFormat:@"%.1f", result];

    _moneyLabel.text = [BalanceObject sharedInstance].balance;
    
    
    
    if ([_delegate respondsToSelector:@selector(walletViewController:paySuccess:)]) {
        [_delegate walletViewController:self paySuccess:[BalanceObject sharedInstance].balance];
    }
}

#pragma mark - PayDepositViewControllerDelegate
//押金充值成功
- (void)payDepositViewController:(PayDepositViewController *)payDepositViewController paySuccess:(NSString *)money
{
    [payDepositViewController.navigationController popViewControllerAnimated:YES];
    
    _needPayDeposit = NO;
    [BalanceObject sharedInstance].deposit = money;
    
    //判断是否需要交押金
    [self judgeIfNeedPayDeposit];
}
 
#pragma mark - ReturnDepositViewControllerDelegate
//申请了退押金
- (void)returnDepositViewControllerDidReturnDeposit:(ReturnDepositViewController *)returnDepositViewController
{
    [returnDepositViewController.navigationController popViewControllerAnimated:YES];
    
    _needPayDeposit = YES;
    [BalanceObject sharedInstance].deposit = @"0";
    
    //判断是否需要交押金
    [self judgeIfNeedPayDeposit];
}

#pragma mark - target action
//明细
- (void)detailClick
{
    [self.navigationController pushViewController:[RecordViewController new] animated:YES];
}

//充值
- (void)_payBtnClick
{
    if (_needPayDeposit)
    {
        //未交押金
        [UIAlertView showWithMessage:@"请先缴押金"];
        return;
    }
    
    PayViewController *vc = [PayViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//交押金
- (void)_payDepositBtnClick
{
    PayDepositViewController *vc = [PayDepositViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
