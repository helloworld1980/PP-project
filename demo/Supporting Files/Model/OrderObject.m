//
//  OrderObject.m
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "OrderObject.h"

@implementation OrderObject

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Id" : @"id",
             @"Description" : @"description",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"lines" : @"Line",
             };
}

@end
