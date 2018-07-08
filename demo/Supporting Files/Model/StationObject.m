//
//  StationObject.m
//  demo
//
//  Created by liman on 3/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "StationObject.h"

@implementation StationObject

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Id" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"positions" : @"PositionObject",
             };
}


@end
