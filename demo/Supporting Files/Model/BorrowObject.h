//
//  BorrowObject.h
//  demo
//
//  Created by liman on 3/17/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowObject : NSObject

@property (nonatomic, strong) NSString * action;
@property (nonatomic, strong) NSString * consume;
@property (nonatomic, strong) NSString * goodType;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * messageDt;
@property (nonatomic, strong) NSString * needBalance;
@property (nonatomic, strong) NSString * needDeposit;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * payLoad;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * version;

@end

/*
 {
 "needDeposit": 100.0,
 "needBalance": 0.0,
 "consume": 0.0,
 "goodType": "DEPOSIT_BANLANCE",
 "orderId": 1073,
 "status": "NOT_ENOUGH_MONEY",
 "message": "押金:100.0",
 "payLoad": null,
 "version": "1.0.0",
 "messageDt": 1488966375,
 "action": "BORROW",
 "userId": 4
 }
 */