//
//  UserObject.m
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

SHARED_INSTANCE_FOR_CLASS(UserObject);

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Id" : @"id",
             @"Description" : @"description",
             };
}


@end
