//
//  BaseNavigationController.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseNavigationController.h"
#import "CoreNetWorkSolveVC.h"
#import "BaseNavigationController+CoreNetWork.h"

@implementation BaseNavigationController

#pragma mark - getter
- (NSArray *)hideNetworkBarControllerArrayFull
{
    if (!_hideNetworkBarControllerArrayFull) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.hideNetworkBarControllerArray];
        [arrayM addObject:NSStringFromClass([CoreNetWorkSolveVC class])];
        _hideNetworkBarControllerArrayFull = [arrayM copy];
    }
    return _hideNetworkBarControllerArrayFull;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self beginReachabilityNoti];
    
    [self netWorkStatusChange];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    [self netWorkStatusChange];
    
//    if (self.viewControllers.count >= 1){
//        self.hidesBottomBarWhenPushed = YES;
//    }
    
    return vc;
}

#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self netWorkStatusChange];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self netWorkStatusChange];
}

@end
