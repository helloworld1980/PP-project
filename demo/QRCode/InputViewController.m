//
//  InputViewController.m
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "InputViewController.h"

@implementation InputViewController
{
    CGRect _batteryFrame;
}

#pragma mark - tool
//开关闪光灯
- (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

//借充电宝
- (void)action_borrow:(NSString *)stationCode
{
    [[HUDHelper sharedInstance] loading];
    //11.借用充电宝
    [[APIService sharedInstance] borrow_stationCode:stationCode success:^(BorrowObject *borrowObject) {
        
        DLog(borrowObject);
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"模拟借取成功"];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

//还充电宝
- (void)action_return:(NSString *)stationCode positionCode:(NSString *)positionCode bankCode:(NSString *)bankCode
{
    [[HUDHelper sharedInstance] loading];
    
    
    //17.还充电宝
    [[APIService sharedInstance] return_stationCode:stationCode positionCode:positionCode bankCode:bankCode success:^(NSDictionary *orderPayMap) {
        
        DLog(orderPayMap);
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"模拟还成功"];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

#pragma mark - public
- (instancetype)initWithBatteryFrame:(CGRect)batteryFrame scanType:(ScanType)scanType
{
    self = [super init];
    if (self) {
        _batteryFrame = batteryFrame;
        _scanType = scanType;
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [k_NSNotificationCenter addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [k_NSNotificationCenter addObserver:self selector:@selector(ble_noti:) name:@"ble_noti" object:nil];//蓝牙
    
    
    self.title = @"输入编码";
    self.showNaviDismissItem = YES;
    self.naviBarView.backgroundColor = [UIColor colorWithHexString:@"#30303a"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#30303a"];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    
    
    //自定义导航栏item
    [self customNaviItem];
    
    //电池image
    [self init_batteryImageView];
    
    //输入textField
    [self init_inputTextField];
    
    //文字label
    [self init_label];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_inputTextField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self turnTorchOn:NO];
}

- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:nil titleFont:nil normalTitleColor:nil highlightTitleColor:nil normalImage:[UIImage imageNamed:@"torch1"] highlightImage:nil action:@selector(clickFlashlight:) frame:CGRectMake(SCREEN_WIDTH - 25 - 9, 30, 25, 25) tag:@"1001"];
}

//电池image
- (void)init_batteryImageView
{
    _batteryImageView = [UIImageView new];
    _batteryImageView.frame = _batteryFrame;
    [self.view addSubview:_batteryImageView];
    
    _batteryImageView.image = [UIImage imageNamed:@"logo"];
}

//输入textField
- (void)init_inputTextField
{
    _inputTextField = [InputTextField new];
    _inputTextField.width = SCREEN_WIDTH;
    _inputTextField.left = 0;
    _inputTextField.height = ((SCREEN_WIDTH - 30) - 6 * (kCount - 1)) / kCount;
    _inputTextField.top = _batteryImageView.bottom + (_batteryFrame.origin.y - k_NaviH);
    [self.view addSubview:_inputTextField];
    
    [_inputTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

//文字label
- (void)init_label
{
    _label = [UILabel new];
    _label.width = _inputTextField.width;
    _label.left = _inputTextField.left;
    _label.top = _inputTextField.bottom + 14;
    [self.view addSubview:_label];
    
    _label.text = @"输入编号完成借取";
    _label.textColor = [UIColor colorWithHexString:@"#706f75"];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    [_label adjustHeight:0];
    
    if (_scanType == ScanType_return) {
        _label.text = @"输入编号还充电宝";
    }
}

#pragma mark - target action
//闪光灯
- (void)clickFlashlight:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected)
    {
        [self turnTorchOn:YES];
    }
    else
    {
        [self turnTorchOn:NO];
    }
}

//隐藏键盘
- (void)keyboardHidden
{
    [_inputTextField resignFirstResponder];
}

//监控textfield输入内容
- (void)textFieldDidChange
{
    if ([_inputTextField.text length] < kCount)
    {
        return;
    }
    
    
    
    
    NSString *xxx = nil;
    if (_scanType == ScanType_borrow) {
        xxx = @"是否确定借?";
    }
    if (_scanType == ScanType_return) {
        xxx = @"是否确定还?";
    }
    
    [UIAlertView showWithTitle:xxx message:_inputTextField.text cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            if (_scanType == ScanType_borrow) {
                //借充电宝
                [self action_borrow:_inputTextField.text];
            }
            if (_scanType == ScanType_return) {
                //还充电宝
                [self action_return:@"1005" positionCode:@"1005_1" bankCode:@"123"];
            }
        }
    }];
}

#pragma mark - notification
- (void)applicationWillEnterForegroundNotification
{
    UIButton *flashBtn = [self.view viewWithTag:1001];
    flashBtn.selected = NO;
}

//蓝牙
- (void)ble_noti:(NSNotification *)noti
{
    NSInteger state = [noti.object integerValue];
    
    if (state == CBCentralManagerStatePoweredOn)
    {
        
    }
    else
    {
        [UIAlertView showWithMessage:@"未检测到蓝牙开启, 请前往\"设置-蓝牙\"打开"];
    }
}

@end
