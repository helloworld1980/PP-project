//
//  StationObject.h
//  demo
//
//  Created by liman on 3/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statistic.h"
#import "PositionObject.h"

@interface StationObject : NSObject //充电桩model

@property (nonatomic, strong) NSString * ProductCreator;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * agent;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * connectType;
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * create_user;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * latitude;//火星坐标
@property (nonatomic, strong) NSString * longitude;//火星坐标
@property (nonatomic, strong) NSArray<PositionObject *> * positions;
@property (nonatomic, strong) NSString * produceDate;
@property (nonatomic, strong) NSString * region;
@property (nonatomic, strong) NSString * regionValue;
@property (nonatomic, strong) NSString * shopName;
@property (nonatomic, strong) Statistic * statistic;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * wxUser;
@property (nonatomic, strong) NSString * wxUserPhone;
@property (nonatomic, strong) NSString * distance;

@end

/*
 {
 "code": "110013",
 "address": "人人乐(西丽店)",
 "agent": 11,
 "region": 1000101,
 "latitude": 22.577966,
 "longitude": 113.955276,
 "wxUser": "zhangsan",
 "wxUserPhone": "1341234134",
 "status": "ENABLE",
 "produceDate": "2017-01-26 18:25:03",
 "ProductCreator": "zhangsan",
 "shopName": "nihao",
 "connectType": "BULETOOTH",
 "regionValue": null,
 "create_user": null,
 "statistic": {
 "free": 0,
 "inuse": 0,
 "total": 0
 },
 "positions": null,
 "distance": 1.1698519867046742E7,
 "id": 11,
 "createDt": "2017-01-26 18:25:04"
 },
 */