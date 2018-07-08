//
//  Statistic.h
//  demo
//
//  Created by liman on 3/15/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistic : NSObject

@property (nonatomic, strong) NSString * free;
@property (nonatomic, strong) NSString * inuse;
@property (nonatomic, strong) NSString * total;

@end

/*
 {
 "free": 0,
 "inuse": 0,
 "total": 0
 }
 */