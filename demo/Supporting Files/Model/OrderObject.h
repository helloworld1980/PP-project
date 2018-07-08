//
//  OrderObject.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Line.h"

@interface OrderObject : NSObject

@property (nonatomic, strong) NSString * agency;
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * endDt;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * orderOwner;
@property (nonatomic, strong) NSString * parentOrder;
@property (nonatomic, strong) NSString * startDt;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * totalFee;
@property (nonatomic, strong) NSString * type;

@property (nonatomic, strong) NSArray<Line *> * lines;
@property (nonatomic, strong) NSString * Description;

@end

/*
 {
 "totalFee": 0.1,
 "orderOwner": 4,
 "parentOrder": null,
 "agency": 1,
 "type": "BALANCE",
 "status": "PAYED",
 "orderNo": "21375cf0-bcd8-42a1-b11e-43e3e5e",
 "startDt": null,
 "endDt": null,
 "description": "充值余额",
 "id": 1278,
 "createDt": "2017-03-27 15:29:21"
 },
 */


/*
 {
 "totalFee": 0.01,
 "orderOwner": 1,
 "parentOrder": null,
 "agency": 1,
 "type": "CONSUME",
 "status": "ACTIVE",
 "orderNo": "8b2b7150-1c3b-4cbd-b530-77e05a9",
 "desciption": null,
 "lines": [
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
 ],
 "id": 1005,
 "createDt": "2017-01-08 11:32:58"
	}
 */