//
//  BalanceObject.h
//  demo
//
//  Created by liman on 3/15/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceObject : NSObject

SHARED_INSTANCE_FOR_HEADER(BalanceObject);

@property (nonatomic, strong) NSString * accountNO;
@property (nonatomic, strong) NSString * balance; //余额
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * credit; //信用
@property (nonatomic, strong) NSString * deposit; //押金
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * user;

@end

/*
 {
 "user": 4,
 "balance": 0.0,
 "deposit": 0.0,
 "accountNO": "30106608-03cf-4fc8-bafa-a395f3e86a92",
 "credit": 0,
 "id": 9,
 "createDt": "2017-03-15 15:37:24"
 }
 */