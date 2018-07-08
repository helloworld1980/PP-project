//
//  BaseNavigationController.h
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreStatus.h"

@interface BaseNavigationController : UINavigationController

@property (nonatomic,strong) Reachability *readchability;

@property (nonatomic,strong) NSArray *hideNetworkBarControllerArray;
@property (nonatomic,strong) NSArray *hideNetworkBarControllerArrayFull;

@end
