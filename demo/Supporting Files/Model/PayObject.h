//
//  PayObject.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayObject : NSObject

@property (nonatomic, strong) NSString * appid;
@property (nonatomic, strong) NSString * noncestr;
@property (nonatomic, strong) NSString * packageKey;
@property (nonatomic, strong) NSString * params;
@property (nonatomic, strong) NSString * partnerid;
@property (nonatomic, strong) NSString * prepayid;
@property (nonatomic, strong) NSString * sign;
@property (nonatomic, strong) NSString * timeStamp;
@property (nonatomic, strong) NSString * orderId;

@end

/*
 {
 "sign": "A436506ED8B7C0DF5B1B0CC262A7AC13",
 "appid": "wx517a8d83d6b4b67b",
 "noncestr": "9fsuzp5xc1aiu22dooecaqqoca8l1oo3",
 "packageKey": "Sign\u003dWXPay",
 "partnerid": "1448841002",
 "prepayid": "wx20170325151548570165bd1e0350807938",
 "params": "appid\u003dwx517a8d83d6b4b67b\u0026noncestr\u003d9fsuzp5xc1aiu22dooecaqqoca8l1oo3\u0026package\u003dSign\u003dWXPay\u0026partnerid\u003d1448841002\u0026prepayid\u003dwx20170325151548570165bd1e0350807938\u0026timestamp\u003d1490426148",
 "timeStamp": "1490426148",
 "orderId": 1312
 },
 */