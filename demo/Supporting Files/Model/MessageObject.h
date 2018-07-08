//
//  MessageObject.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * msg_type;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * user;

@end

/*
 {
 "title": "TEST1",
 "content": "THIS IS A TEST!",
 "status": "READ",
 "msg_type": "ORDER",
 "user": 4,
 "id": 1009,
 "createDt": "2017-02-17 22:29:13"
 }
 */