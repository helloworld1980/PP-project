//
//  line.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (nonatomic, strong) NSString * agency;
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * endDt;
@property (nonatomic, strong) NSString * fee;
@property (nonatomic, strong) NSString * feeType;
@property (nonatomic, strong) NSString * fromStation;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * order;
@property (nonatomic, strong) NSString * powerBank;
@property (nonatomic, strong) NSString * startDt;
@property (nonatomic, strong) NSString * toStation;
@property (nonatomic, strong) NSString * user;

@end

/*
 {
 "fromStation": "10015",
 "toStation": null,
 "powerBank": "band3",
 "user": 1,
 "startDt": 141414123524,
 "endDt": null,
 "fee": 0.0,
 "feeType": "CONSUME",
 "agency": 1,
 "order": 1005,
 "id": 1002,
 "createDt": "2017-01-08 11:32:58"
 }
 */