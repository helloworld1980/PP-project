//
//  BaseNavigationController+CoreNetWork.h
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController (CoreNetWork)

/** 监听网络状态 */
-(void)beginReachabilityNoti;

/** 网络状态变更 */
-(void)netWorkStatusChange;

@end
