//
//  FriendObject.m
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "FriendObject.h"

@implementation FriendObject

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"Id" : @"id",
             @"Description" : @"description",
             };
}

@end
