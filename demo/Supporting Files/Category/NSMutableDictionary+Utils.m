//
//  NSMutableDictionary+Utils.m
//  2132131321
//
//  Created by liman on 16/5/17.
//  Copyright © 2016年 liman. All rights reserved.
//

#import "NSMutableDictionary+Utils.h"

@implementation NSMutableDictionary (Utils)

- (void)setObjectNotNil:(id)obj forKey:(NSString *)key
{
    if (!obj) {
        return;
    }
    
    [self setObject:obj forKey:key];
}

- (void)replaceObject:(id)obj forKey:(NSString *)key
{
    if (![self objectForKey:key]) {
        return;
    }
    
    [self removeObjectForKey:key];
    [self setObjectNotNil:obj forKey:key];
}

- (void)replaceOldKey:(NSString *)oldKey toNewKey:(NSString *)newKey
{
    if (![self objectForKey:oldKey]) {
        return;
    }
    
    [self setObject:[self objectForKey:oldKey] forKey:newKey];
    [self removeObjectForKey:oldKey];
}

@end
