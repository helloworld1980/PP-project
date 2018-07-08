//
//  FriendObject.h
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendObject : NSObject

@property (nonatomic, strong) NSString * appType;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * channelId;
@property (nonatomic, strong) NSString * createDt;
@property (nonatomic, strong) NSString * Description;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * Id;
@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * myInviteCode;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * photoUrl;
@property (nonatomic, strong) NSString * pushType;
@property (nonatomic, strong) NSString * realName;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * status;

@end

/*
 {
 "loginName": "我想你fvg",
 "realName": "",
 "phone": "18123856209",
 "email": "18123856209",
 "status": "ENABLE",
 "photoUrl": "http://139.224.16.177/user/2_photo.jpg",
 "description": "多么娟娟",
 "channelId": "",
 "pushType": "BAIDU",
 "appType": 4,
 "myInviteCode": "qiqoucfc",
 "sex": "M",
 "birthday": 556661,
 "id": 2,
 "createDt": "2017-02-08 21:24:19"
 }
 */