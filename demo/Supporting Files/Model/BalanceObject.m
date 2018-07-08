//
//  BalanceObject.m
//  demo
//
//  Created by liman on 3/15/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BalanceObject.h"

@implementation BalanceObject

SHARED_INSTANCE_FOR_CLASS(BalanceObject);

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Id" : @"id",
             };
}

@end
