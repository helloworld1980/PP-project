//
//  NSDictionary+JKNullReplacer.h
//  JKNullReplacer
//
//  Created by Jobin Kurian on 14/03/14.
//  Copyright (c) 2014 Jobin Kurian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JKNullReplacer)

- (NSDictionary *)dictionaryWithoutNulls;

@end
