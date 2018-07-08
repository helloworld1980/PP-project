//
//  NSUserDefaults+SafeAccess.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 15/5/23.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSUserDefaults+JKSafeAccess.h"

@implementation NSUserDefaults (JKSafeAccess)
+ (NSString *)jk_stringForKey:(NSString *)defaultName {
    return [k_NSUserDefaults stringForKey:defaultName];
}

+ (NSArray *)jk_arrayForKey:(NSString *)defaultName {
    return [k_NSUserDefaults arrayForKey:defaultName];
}

+ (NSDictionary *)jk_dictionaryForKey:(NSString *)defaultName {
    return [k_NSUserDefaults dictionaryForKey:defaultName];
}

+ (NSData *)jk_dataForKey:(NSString *)defaultName {
    return [k_NSUserDefaults dataForKey:defaultName];
}

+ (NSArray *)jk_stringArrayForKey:(NSString *)defaultName {
    return [k_NSUserDefaults stringArrayForKey:defaultName];
}

+ (NSInteger)jk_integerForKey:(NSString *)defaultName {
    return [k_NSUserDefaults integerForKey:defaultName];
}

+ (float)jk_floatForKey:(NSString *)defaultName {
    return [k_NSUserDefaults floatForKey:defaultName];
}

+ (double)jk_doubleForKey:(NSString *)defaultName {
    return [k_NSUserDefaults doubleForKey:defaultName];
}

+ (BOOL)jk_boolForKey:(NSString *)defaultName {
    return [k_NSUserDefaults boolForKey:defaultName];
}

+ (NSURL *)jk_URLForKey:(NSString *)defaultName {
    return [k_NSUserDefaults URLForKey:defaultName];
}

#pragma mark - WRITE FOR STANDARD

+ (void)jk_setObject:(id)value forKey:(NSString *)defaultName {
    [k_NSUserDefaults setObject:value forKey:defaultName];
    [k_NSUserDefaults synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)jk_arcObjectForKey:(NSString *)defaultName {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[k_NSUserDefaults objectForKey:defaultName]];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)jk_setArcObject:(id)value forKey:(NSString *)defaultName {
    [k_NSUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:defaultName];
    [k_NSUserDefaults synchronize];
}
@end
