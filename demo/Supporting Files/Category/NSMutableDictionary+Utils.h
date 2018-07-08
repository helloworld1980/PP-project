//
//  NSMutableDictionary+Utils.h
//  2132131321
//
//  Created by liman on 16/5/17.
//  Copyright © 2016年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Utils)

- (void)setObjectNotNil:(id)obj forKey:(NSString *)key;

- (void)replaceObject:(id)obj forKey:(NSString *)key;

- (void)replaceOldKey:(NSString *)oldKey toNewKey:(NSString *)newKey;

@end
