//
//  BaseNavigationController+CoreNetWork.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseNavigationController+CoreNetWork.h"
#import "CoreStatus.h"
#import "CoreNetWorkView.h"
#import "CoreNetWorkSolveVC.h"

@implementation BaseNavigationController (CoreNetWork)

#pragma mark - tool
//显示网络状态提示条
-(void)showNetWorkBar
{
    CGFloat y = self.navigationBar.frame.size.height + 20.0f;
    
    [CoreNetWorkView showNetWordNotiInViewController:self y:y];
}

//隐藏网络状态提示条
-(void)dismissNetWorkBar
{
    [CoreNetWorkView dismissNetWordNotiInViewController:self];
}

-(BOOL)needHideNetWorkBarWithVC:(UIViewController *)vc
{
    NSString *vcStr=NSStringFromClass(vc.class);
    BOOL res = [self.hideNetworkBarControllerArrayFull containsObject:vcStr];
    
    return res;
}

#pragma mark - piblic
/** 监听网络状态 */
-(void)beginReachabilityNoti
{
    Reachability *readchability=[Reachability reachabilityForInternetConnection];
    
    //记录
    self.readchability=readchability;
    
    //开始通知
    [readchability startNotifier];
    
    //监听通知
    [k_NSNotificationCenter addObserver:self selector:@selector(netWorkStatusChange) name:kReachabilityChangedNotification object:readchability];
}


/** 网络状态变更 */
-(void)netWorkStatusChange
{
    if ([self needHideNetWorkBarWithVC:self.topViewController]) {
        
        //这里dismiss的原因在于可能由其他页面pop回来的时候，如果直接return会导致bar显示出来。
        [self dismissNetWorkBar];
        return;
    }
    
    if ([CoreStatus isNetworkEnable])
    {
        [self dismissNetWorkBar];
    }
    else
    {
        [self showNetWorkBar];
    }
}

#pragma mark - dealloc
//liman
- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

@end
