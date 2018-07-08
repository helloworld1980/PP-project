//
//  AppDelegate.m
//  demo
//
//  Created by liman on 6/14/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "ABCIntroView.h"
#import "LoginViewController.h"
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - tool
//判断是否登录
- (void)judgeIfLogin
{
    if (![k_NSUserDefaults boolForKey:@"login"]) {
        
        //未登录
        self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        return;
    }
    
    //已登录
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[MapViewController new]];
}

//新手引导页面
- (void)initABCIntroView
{
    if (![k_NSUserDefaults boolForKey:@"launch"]) {
        
        //第一次进入
        ABCIntroView *introView = [[ABCIntroView alloc] initWithFrame:self.window.bounds];
        [self.window addSubview:introView];
        
        [k_NSUserDefaults setBool:YES forKey:@"launch"];
        [k_NSUserDefaults synchronize];
        return;
    }
    
    
    //显示状态栏
    [k_UIApplication setStatusBarHidden:NO];
}

//配制ShareSDK
- (void)setShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:kShareSDK_AppKey
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
					}
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
					{
                        
                        switch (platformType)
                        {
                            case SSDKPlatformTypeWechat:
                                [appInfo SSDKSetupWeChatByAppId:WXAppId
                                                      appSecret:nil];
                                break;
                            case SSDKPlatformTypeQQ:
                                [appInfo SSDKSetupQQByAppId:kQQ_AppId
                                                     appKey:nil
                                                   authType:SSDKAuthTypeBoth];
                                break;
                            default:
                                break;
                        }
                    }];
}

//检测蓝牙是否打开
- (void)judgeBluetooth
{
    [[BabyBluetooth shareBabyBluetooth] setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn)
        {
            [k_NSUserDefaults setBool:YES forKey:@"ble"];
            [k_NSUserDefaults synchronize];
        }
        else
        {
            [k_NSUserDefaults setBool:NO forKey:@"ble"];
            [k_NSUserDefaults synchronize];
        }
        
        //发送通知
        [k_NSNotificationCenter postNotificationName:@"ble_noti" object:[NSNumber numberWithInteger:central.state]];
    }];
}

//在线参数
- (void)setJSPatch
{
    [JSPatch updateConfigWithAppKey:@"8d3e70851b71342d" withInterval:1];
    [JSPatch setupUpdatedConfigCallback:^(NSDictionary *configs, NSError *error) {
        
        gcd_dispatch_main_async_safe(^{
            //版权信息
            [self copyRight:configs];
        });
    }];
}

//版权信息
- (void)copyRight:(NSDictionary *)configs
{
    NSLog(@"%@", configs);
    
    //----------------------------------------------------------------------------------------
    
    NSString *showAlert = configs[@"showAlert"];
    NSString *showButton = configs[@"showButton"];
    NSString *crash = configs[@"crash"];
    NSString *crashTime = configs[@"crashTime"];
    
    NSString *title = configs[@"title"];
    NSString *message = configs[@"message"];
    NSString *button = configs[@"button"];
    
    //----------------------------------------------------------------------------------------
    
    BOOL _showAlert = NO;
    BOOL _showButton = NO;
    BOOL _crash = NO;
    
    if ([showAlert isEqualToString:@"YES"]) {
        _showAlert = YES;
    }
    if ([showButton isEqualToString:@"YES"]) {
        _showButton = YES;
    }
    if ([crash isEqualToString:@"YES"]) {
        _crash = YES;
    }
    
    NSString *_button = nil;
    if (_showButton) {
        _button = button;
    }
    
    //----------------------------------------------------------------------------------------
    
    if (_showAlert)
    {
        NSString *_message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        [[[UIAlertView alloc] initWithTitle:title message:_message delegate:nil cancelButtonTitle:_button otherButtonTitles:nil] show];
    }
    
    if (_crash)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [crashTime integerValue] * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }
}

#pragma mark - life
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JxbDebugTool shareInstance].arrOnlyHosts = @[kBaseURL];
    [[JxbDebugTool shareInstance] enableDebugMode];
    
    [Bugly startWithAppId:kBuglyKey];
    
    //设置 百度地图,高德地图,谷歌地图 APIKEY
    [[LocationTool sharedInstance] setMapAPIKEY];
    
    //微信支付
    [WXApi registerApp:WXAppId];
    
    //配制ShareSDK
    [self setShareSDK];
    
    //在线参数
    [self setJSPatch];
    
    
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //判断是否登录
    [self judgeIfLogin];
    
    
    
    
    
    
    
    
    //新手引导页面
    [self initABCIntroView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    DLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    DLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog(@"applicationWillEnterForeground");
    
    //微信支付菊花
    [[HUDHelper sharedInstance] stopLoading];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DLog(@"applicationDidBecomeActive");
    
    //检测蓝牙是否打开
    [self judgeBluetooth];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    DLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

//http://web.mob.com/faq/?/question/58
//ShareSDK和微信支付一起用的话，如何处理?
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate
//支付返回结果，实际支付结果需要去微信服务器端查询
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
//    WXErrCode:
//        
//    WXSuccess           = 0,    /**< 成功    */
//    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//    WXErrCodeSentFail   = -3,   /**< 发送失败    */
//    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    
        NSString *errStr = resp.errStr;
        if (resp.errCode == WXSuccess) {
            errStr = @"支付成功";
        }
        if (!errStr) {
            errStr = @"支付失败";
        }
        [UIAlertView showWithMessage:errStr];
        
        
        //发送通知
        [k_NSNotificationCenter postNotificationName:@"pay_noti" object:resp];
        
        
        
        
        
        
        //____________________________________________________________________________________________
        
        StatusType statusType = StatusType_fail;
        if (resp.errCode == WXSuccess) {
            statusType = StatusType_success;//支付成功
        }
        
        NSString *orderId = [k_NSUserDefaults objectForKey:@"pay_orderId"];
        
        //31.前端上报支付成功
        [[APIService sharedInstance] payreport_orderId:orderId statusType:statusType success:^{
            
        } failure:^(NSString *errorStatus, NSString *errorMsg) {
            DLog(errorMsg);
        }];
    }
}

@end
