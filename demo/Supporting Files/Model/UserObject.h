//
//  UserObject.h
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject

SHARED_INSTANCE_FOR_HEADER(UserObject);

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
 "loginName": "lfje033x",
 "realName": "啊啊啊",
 "phone": "13246728830",
 "email": "381004367@qq.com",
 "status": "ENABLE",
 "photoUrl": "http://139.224.16.177/user/4_photo.jpg",
 "description": "吧",
 "channelId": "xxxxxxxx",
 "pushType": "BAIDU",
 "appType": 3,
 "myInviteCode": "rl4iudfjoy",
 "sex": "F",
 "birthday": 1489161600000,
 "id": 4,
 "createDt": "2017-02-25 22:53:34"
	}
 */