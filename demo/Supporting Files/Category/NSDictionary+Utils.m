//
//  NSDictionary+Utils.m
//  qew
//
//  Created by liman on 16/6/1.
//  Copyright © 2016年 liman. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (id)objectNotNilForKey:(NSString *)key
{
    if ([self objectForKey:key]) {
        return [self objectForKey:key];
    }
    
    return [NSNull null];
}

@end
