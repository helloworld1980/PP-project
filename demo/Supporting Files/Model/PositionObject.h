//
//  PositionObject.h
//  demo
//
//  Created by liman on 3/19/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionObject : NSObject //充电桩-->卡槽model

@property (strong, nonatomic) NSString *stationCode;//我自己添加的

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *capacity;
@property (assign, nonatomic) BOOL canBorrow;


//根据文档
@property (strong, nonatomic) NSString *voltage;
@property (strong, nonatomic) NSString *current;
@property (strong, nonatomic) NSString *powerStation;
@property (strong, nonatomic) NSString *powerBank;
@property (strong, nonatomic) NSString *chargStartTime;
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *createDt;

@end

/*
 {
 "stationCode":
	"10015",
 "positions":
	[
    {"code": "10015_1",
    "capacity": 0.5,
    "canBorrow": true,
    },
    {"code": "10015_3",
    "capacity": 0.4,
    "canBorrow": true,
    },
    {"code": "10015_4",
    "capacity": 0.8,
    "canBorrow": true,
    },
    {"code": "10015_7",
    "capacity": 0.6,
    "canBorrow": true,
    }
	]
 }
 */