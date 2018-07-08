//
//  ScanViewController.m
//  demo
//
//  Created by liman on 3/6/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "QRScanViewController.h"

@interface QRScanViewController ()

//是否隐藏导航栏
@property (nonatomic, assign) BOOL naviBarHidden;
//导航栏高度
@property (nonatomic, assign) CGFloat naviBarHeight;

@end

@implementation QRScanViewController
{
    BOOL _kIsFlashOn;
    BOOL _xxx;
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

//恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 482/2;
        CGFloat scanWindowH = SCREEN_WIDTH - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.width;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
}

//获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
}

//恢复扫码
- (void)resumeScan
{
    [self.session startRunning];
    //恢复动画
    [self resumeAnimation];
}

//借充电宝
- (void)action_borrow:(NSString *)stationCode
{
    [[HUDHelper sharedInstance] loading];
    //11.借用充电宝
    [[APIService sharedInstance] borrow_stationCode:stationCode success:^(BorrowObject *borrowObject) {
        
        DLog(borrowObject);
        [[HUDHelper sharedInstance] stopLoading];
        
        [UIAlertView showWithMessage:@"模拟借取成功" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if ([_delegate respondsToSelector:@selector(qrScanViewController:borrowSuccess:)]) {
                [_delegate qrScanViewController:self borrowSuccess:borrowObject];
            }
            
            //恢复扫码
            [self resumeScan];
        }];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        
        [UIAlertView showWithMessage:errorMsg tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            //恢复扫码
            [self resumeScan];
        }];
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
        
        [UIAlertView showWithMessage:@"模拟还成功" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if ([_delegate respondsToSelector:@selector(qrScanViewController:borrowSuccess:)]) {
//                [_delegate qrScanViewController:self borrowSuccess:borrowObject];
//            }
            
            //恢复扫码
            [self resumeScan];
        }];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        
        [UIAlertView showWithMessage:errorMsg tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            //恢复扫码
            [self resumeScan];
        }];
    }];
}

#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}

#pragma mark - public
/**
 *  是否隐藏导航栏
 */
- (instancetype)initWithNaviBarHidden:(BOOL)naviBarHidden scanType:(ScanType)scanType
{
    self = [super init];
    if (self) {
        _naviBarHidden = naviBarHidden;
        _scanType = scanType;
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [k_NSNotificationCenter addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];//主要是解决一下系统前后台切换的过程中动画被强制终端的情况
    [k_NSNotificationCenter addObserver:self selector:@selector(ble_noti:) name:@"ble_noti" object:nil];//蓝牙
    
    
    self.naviBarView.backgroundColor = [UIColor colorWithHexString:@"#30303a"];
    self.view.clipsToBounds = YES;//这个属性必须打开否则返回的时候会出现黑边
    
    
    
    //判断是否隐藏导航栏
    [self judgeIfHideNaviBar];
    //遮罩
    [self setupMaskView];
    //扫描区域
    [self setupScanWindowView];
    //核心代码(第1种方式) //缺点:进入会卡顿
//    [self setupCapture1];
    //核心代码(第2种方式) //缺点:扫描区域只能中间
    [self setupCapture2];
    //恢复动画
    [self resumeAnimation];
    
    
    
    //电池image
    [self init_batteryImageView];
    //说明label
    [self init_label];
    //输入编码(左边)
    [self init_leftView];
    //手电筒(右边)
    [self init_rightView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _xxx = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _xxx = NO;
}

- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
//判断是否隐藏导航栏
- (void)judgeIfHideNaviBar
{
    if (!_naviBarHidden)
    {
        //显示导航栏
        self.title = @"扫描二维码";
        self.showNaviDismissItem = YES;
        _naviBarHeight = 64;
    }
    else
    {
        //隐藏导航栏
        self.hideNaviBarView = YES;
        _naviBarHeight = 0;
    }
}

//遮罩
- (void)setupMaskView
{
    //1.主要遮罩
    UIView *maskView = [UIView new];
    
    maskView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    maskView.layer.borderWidth = kBorderW;
    
    maskView.bounds = CGRectMake(0, 0, SCREEN_WIDTH + (kBorderW - kMargin)*2, SCREEN_WIDTH + (kBorderW - kMargin)*2);
    maskView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    maskView.y = _naviBarHeight;
    
    [self.view addSubview:maskView];
    
    
    //2.底部遮罩
    UIView *maskView2 = [[UIView alloc] initWithFrame:CGRectMake(0, maskView.bottom, SCREEN_WIDTH, SCREEN_WIDTH)];
    maskView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:maskView2];    
}

//扫描区域
- (void)setupScanWindowView
{
    CGFloat scanWindowH = SCREEN_WIDTH - kMargin * 2;
    CGFloat scanWindowW = SCREEN_WIDTH - kMargin * 2;
    CGFloat buttonWH = 42/2;
    
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW + _naviBarHeight, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;//二维码动画关键属性设置
    [self.view addSubview:_scanWindow];
    
    
    //1.四个角
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setBackgroundImage:[UIImage imageNamed:@"scan_coremark01"] forState:0];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setBackgroundImage:[UIImage imageNamed:@"scan_coremark02"] forState:0];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setBackgroundImage:[UIImage imageNamed:@"scan_coremark04"] forState:0];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setBackgroundImage:[UIImage imageNamed:@"scan_coremark03"] forState:0];
    [_scanWindow addSubview:bottomRight];
    
    
    //2.扫描图片
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
}

//核心代码(第1种方式) //缺点:进入会卡顿
- (void)setupCapture1
{
#if TARGET_IPHONE_SIMULATOR
    return;
#else
    
#endif
    
    self.session = [[AVCaptureSession alloc] init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    [self.session addInput:self.input];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.output]; // 这行代码要在设置 metadataObjectTypes 前
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    __weak typeof(self) weakSelf = self;
    [k_NSNotificationCenter addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue currentQueue]
                                                  usingBlock: ^(NSNotification *_Nonnull note) {
                                                      self.output.rectOfInterest = [self.preview metadataOutputRectOfInterestForRect:weakSelf.scanWindow.frame]; // 如果不设置，整个屏幕都可以扫
                                                  }];
    
    //开始捕获
    [self.session startRunning];
    
    //rectOfInterest 不可以直接在设置 metadataOutput 时接着设置，而需要在这个 AVCaptureInputPortFormatDescriptionDidChangeNotification 通知里设置，否则 metadataOutputRectOfInterestForRect: 转换方法会返回 (0, 0, 0, 0)
}

//核心代码(第2种方式) //缺点:扫描区域只能中间
- (void)setupCapture2
{
#if TARGET_IPHONE_SIMULATOR
    return;
#else
    
#endif
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    self.output.rectOfInterest = [self getScanCrop:_scanWindow.frame readerViewBounds:[UIScreen mainScreen].bounds];//获取扫描区域的比例关系
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    //开始捕获
    [self.session startRunning];
}

//电池image
- (void)init_batteryImageView
{
    _batteryImageView = [UIImageView new];
    _batteryImageView.height = 120/2;
    _batteryImageView.width = 97/2;
    _batteryImageView.centerX = self.view.centerX;
    _batteryImageView.top = (_scanWindow.top - _batteryImageView.height) / 2 + k_NaviH/2;
    [self.view addSubview:_batteryImageView];
    
    _batteryImageView.image = [UIImage imageNamed:@"logo"];
}

//说明label
- (void)init_label
{
    _label = [UILabel new];
    _label.width = _scanWindow.width;
    _label.left = _scanWindow.left;
    _label.top = _scanWindow.bottom + 14;
    [self.view addSubview:_label];
    
    _label.text = @"扫描二维码借取充电宝";
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentCenter;
    [_label adjustHeight:0];
    
    if (_scanType == ScanType_return) {
        _label.text = @"扫描二维码还充电宝";
    }
}

//输入编码(左边)
- (void)init_leftView
{
    _leftView = [UIView new];
//    _leftView.backgroundColor = k_RandomColor;
    _leftView.width = _scanWindow.width/2;
    _leftView.height = _leftView.width;
    _leftView.left = _scanWindow.left;
    _leftView.top = _label.bottom + (SCREEN_HEIGHT - _label.bottom - _leftView.height)/2;
    [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_leftViewClick)]];
    [self.view addSubview:_leftView];
    
    
    //1.图片
    UIImageView *imageView = [UIImageView new];
    imageView.width = 56/2;
    imageView.height = 56/2;
    imageView.left = (_leftView.width - imageView.width) / 2;
    imageView.top = (_leftView.height - imageView.height) / 2 - 14;
    imageView.image = [UIImage imageNamed:@"bianma"];
    [_leftView addSubview:imageView];
    
    //2.文字
    UILabel *label = [UILabel new];
    label.width = _leftView.width;
    label.left = 0;
    label.top = imageView.bottom + 4;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"输入编码";
    label.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:label];
    
    [label adjustHeight:0];
}

//手电筒(右边)
- (void)init_rightView
{
    _rightView = [UIView new];
//    _rightView.backgroundColor = k_RandomColor;
    _rightView.frame = _leftView.frame;
    _rightView.left = _leftView.right;
    [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_rightViewClick)]];
    [self.view addSubview:_rightView];
    
    
    //1.图片
    UIImageView *imageView = [UIImageView new];
    imageView.width = 56/2;
    imageView.height = 56/2;
    imageView.left = (_rightView.width - imageView.width) / 2;
    imageView.top = (_rightView.height - imageView.height) / 2 - 14;
    imageView.image = [UIImage imageNamed:@"torch1"];
    [_rightView addSubview:imageView];
    
    //2.文字
    UILabel *label = [UILabel new];
    label.width = _rightView.width;
    label.left = 0;
    label.top = imageView.bottom + 4;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"手电筒";
    label.textAlignment = NSTextAlignmentCenter;
    [_rightView addSubview:label];
    
    [label adjustHeight:0];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] == 0)
    {
        return;
    }
    
    if ([metadataObjects count] > 0) {
        
        //扫描成功之后的提示音
        [self playSoundEffect:@"sound.mp3"];
        
        [self.session stopRunning];
        //恢复动画
        [self resumeAnimation];
        
        [_scanNetImageView.layer removeAnimationForKey:@"translationAnimation"];
        
        
        
        
        NSString *xxx = nil;
        if (_scanType == ScanType_borrow) {
            xxx = @"是否确定借?";
        }
        if (_scanType == ScanType_return) {
            xxx = @"是否确定还?";
        }
        
        [UIAlertView showWithTitle:xxx message:[[metadataObjects firstObject] stringValue] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1)
            {
                if (_scanType == ScanType_borrow) {
                    //借充电宝
                    [self action_borrow:[[metadataObjects firstObject] stringValue]];
                }
                if (_scanType == ScanType_return) {
                    //还充电宝
                    [self action_return:@"1005" positionCode:@"1005_1" bankCode:@"123"];
                }
            }
            else
            {
                //恢复扫码
                [self resumeScan];
            }
        }];
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
        [button setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_on"] forState:0];
    }
    else
    {
        [self turnTorchOn:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"topbar_icon_light_off"] forState:0];
    }
}

//输入编码
- (void)_leftViewClick
{
    InputViewController *vc = [[InputViewController alloc] initWithBatteryFrame:_batteryImageView.frame scanType:_scanType];
    [self.navigationController pushViewController:vc animated:YES];
}

//手电筒
- (void)_rightViewClick
{
    if (!_kIsFlashOn)
    {
        _kIsFlashOn = YES;
        [self turnTorchOn:YES];
    }
    else
    {
        _kIsFlashOn = NO;
        [self turnTorchOn:NO];
    }
}

#pragma mark - notification
- (void)applicationWillEnterForegroundNotification
{
    //恢复动画
    [self resumeAnimation];
    
    _kIsFlashOn = NO;
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
        if (_xxx) {
            [UIAlertView showWithMessage:@"未检测到蓝牙开启, 请前往\"设置-蓝牙\"打开"];
        }
    }
}

@end
