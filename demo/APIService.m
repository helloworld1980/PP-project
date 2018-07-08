//
//  APIService.m
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "APIService.h"
#import "LMHttpMock.h"

@implementation APIService

SHARED_INSTANCE_FOR_CLASS(APIService);

#pragma mark - tool
//保存bundle文件到沙盒 (fileName参数: test_post.json)
- (NSString *)saveBundleToSandbox:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:fileName];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:[jsonDict copy]
                                                   options:0
                                                     error:nil];
    
    
    
    //沙盒路径
    NSString *path = [SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return fileName;
    }
    
    if ([data writeToFile:path atomically:YES]) {
        return fileName;
    }
    
    return nil;
}

//更新UserObject单例
- (void)updateUserObject:(UserObject *)userObject
{
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
    
    [UserObject sharedInstance].loginName = userObject.loginName;
    [UserObject sharedInstance].realName = userObject.realName;
    [UserObject sharedInstance].phone = userObject.phone;
    [UserObject sharedInstance].email = userObject.email;
    [UserObject sharedInstance].status = userObject.status;
    [UserObject sharedInstance].photoUrl = userObject.photoUrl;
    [UserObject sharedInstance].Description = userObject.Description;
    [UserObject sharedInstance].channelId = userObject.channelId;
    [UserObject sharedInstance].pushType = userObject.pushType;
    [UserObject sharedInstance].appType = userObject.appType;
    [UserObject sharedInstance].myInviteCode = userObject.myInviteCode;
    [UserObject sharedInstance].sex = userObject.sex;
    [UserObject sharedInstance].birthday = userObject.birthday;
    [UserObject sharedInstance].Id = userObject.Id;
    [UserObject sharedInstance].createDt = userObject.createDt;
    
    //保存手机号
    [k_NSUserDefaults setObject:userObject.phone forKey:@"phone"];
    [k_NSUserDefaults synchronize];
}

//更新BalanceObject单例
- (void)updateBalanceObject:(BalanceObject *)balanceObject
{
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
    
    [BalanceObject sharedInstance].user = balanceObject.user;
    [BalanceObject sharedInstance].balance = balanceObject.balance;
    [BalanceObject sharedInstance].deposit = balanceObject.deposit;
    [BalanceObject sharedInstance].accountNO = balanceObject.accountNO;
    [BalanceObject sharedInstance].credit = balanceObject.credit;
    [BalanceObject sharedInstance].Id = balanceObject.Id;
    [BalanceObject sharedInstance].createDt = balanceObject.createDt;
}

//计算年龄, 参数:26
- (NSNumber *)calculateAge:(NSString *)age
{
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
//    NSLog(@"现在是%ld年" , comp.year);
//    NSLog(@"现在是%ld月 " , comp.month);
//    NSLog(@"现在是%ld日" , comp.day);
//    NSLog(@"现在是%ld时" , comp.hour);
//    NSLog(@"现在是%ld分" , comp.minute);
//    NSLog(@"现在是%ld秒" , comp.second);
//    NSLog(@"现在是星期%ld" , comp.weekday);
    // 再次创建一个NSDateComponents对象
    NSDateComponents* comp2 = [[NSDateComponents alloc]
                               init];
    // 设置各时间字段的数值
    comp2.year = comp.year - [age integerValue];
//    comp2.month = 4;
//    comp2.day = 5;
//    comp2.hour = 18;
//    comp2.minute = 34;
    // 通过NSDateComponents所包含的时间字段的数值来恢复NSDate对象
    NSDate *date = [gregorian dateFromComponents:comp2];
    NSLog(@"获取的日期为：%@" , date);
    
    NSString *timestamp = [date timestamp];
    DLog(timestamp);
    
    return [NSNumber numberWithString:timestamp];
}

// 年月日---->NSDate
- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}

//计算性别, 参数:女
- (NSString *)calculateSex:(NSString *)sex
{
    if ([sex isEqualToString:@"男"]) {
        return @"M";
    }
    
    return @"F";
}

//返回非nil字符串
- (NSString *)returnNotNil:(NSString *)str
{
    if (str && ![str isEmpty]) {
        return str;
    }
    
    return @"20";//默认年龄20
}

//随机图片名字    xxx.png
- (NSString *)getRandomFileName
{
    NSString *name = [NSString stringWithFormat:@"%d", abs(random)];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", name];
    
    return fileName;
}

//根据kError_status, 得到kError_msg
- (NSString *)return_kError_msg:(NSDictionary *)jsonDict
{
    NSString *errorMsg = kError_msg;
    if ([kError_status isEqualToString:@"DUPLICATE"]) {
        errorMsg = @"请勿重复请求";
    }
    
    
    
    
    
    
    // 10.上传充电桩详细信息
    //
    //    RES_DUPLICATE         重复消息，此消息需要缓存确保后台处理。收到此消息说明server以处理
    //    STATION_NOT_EXIST     stationCode对应的充电桩不存在
    //    STATION_INUSE         充电桩正在被使用，并发借用情况提醒用户等等
    //    NO_BANK_BORROW        如果卡遭中没有任何充电宝，将返回该信息
    //    SUCCESS               成功，将返回相应的station，position，bank的code
    if ([kError_status isEqualToString:@"RES_DUPLICATE"]) {
        errorMsg = @"请勿重复请求";
    }
    if ([kError_status isEqualToString:@"STATION_NOT_EXIST"]) {
        errorMsg = @"充电桩不存在";
    }
    if ([kError_status isEqualToString:@"STATION_INUSE"]) {
        errorMsg = @"充电桩正在被使用";
    }
    if ([kError_status isEqualToString:@"NO_BANK_BORROW"]) {
        errorMsg = @"卡遭中没有充电宝";
    }
    
    
    
    // 14.退押金
    //
    //NO_DEPOSIT: 没有押金，不可退款
    //NEED_PAY：有欠款订单，需要支付后方可退款
    //SUCCESS:退款成功
    //FAILED:退款失败
    if ([kError_status isEqualToString:@"NO_DEPOSIT"]) {
        errorMsg = @"没有押金，不可退款";
    }
    if ([kError_status isEqualToString:@"NEED_PAY"]) {
        errorMsg = @"有欠款订单，需要支付后方可退款";
    }
    if ([kError_status isEqualToString:@"FAILED"]) {
        errorMsg = @"退款失败";
    }
    
    
    
    // 11.借用充电宝
    //
    //    RES_DUPLICATE         重复消息，此消息需要缓存确保后台处理。收到此消息说明server以处理
    //    NOT_ENOUGH_MONEY      余额不够，需要支付， 此时后台返回：订单号orderId， 订单金额needPay，支付消息message
    //    SUCCESS               成功，将返回相应的station，position，bank的code. 此时用户余额充足
    //    RES_BORROW_MORE_3     用户最多可以借用三个充电宝，多了禁止借用，提醒用户需要归还方可借用
    if ([kError_status isEqualToString:@"RES_DUPLICATE"]) {
        errorMsg = @"请勿重复请求";
    }
    if ([kError_status isEqualToString:@"NOT_ENOUGH_MONEY"]) {
        errorMsg = @"余额不够，需要支付";
    }
    if ([kError_status isEqualToString:@"RES_BORROW_MORE_3"]) {
        errorMsg = @"最多可以借用三个充电宝";
    }
    
    
    
    //17.还充电宝
    //
    // NO_ORDER_FOUND      没有发现订单
    if ([kError_status isEqualToString:@"NO_ORDER_FOUND"]) {
        errorMsg = @"没有发现订单";
    }
    
    
    
    
    
    
    
    
    
    
    return errorMsg;
}

#pragma mark - public
/**
 *  0.获取token
 */
- (void)getToken_userId:(NSString *)userId success:(void (^)(NSString *token))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    if ([userId isEmpty] || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     8aebac43-8067-465b-8c03-75970817f4e1
     */
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"token"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"SERVER_TIME",
                           
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        NSString *token = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DLog(token);
        
        //成功
        [k_NSUserDefaults setObject:token forKey:@"token"];
        [k_NSUserDefaults synchronize];
        successBlock(token);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  5.获取服务器时间
 */
- (void)requestServerTime:(void (^)(NSString *serverTime))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "time": 1489468891408,
     "status": "SUCCESS",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "SERVER_TIME",
     "userId": 4
     }
     */
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"server/time"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"SERVER_TIME",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *serverTime = toNSString(jsonDict[@"time"]);
            
            [k_NSUserDefaults setObject:serverTime forKey:@"serverTime"];
            [k_NSUserDefaults synchronize];
            
            successBlock(serverTime);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  1.发送验证码
 */
- (void)sendCodeWithPhoneNumber:(NSString *)phoneNumber success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    if ([phoneNumber isEmpty] || !phoneNumber) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     没有返回
     */
    
//    //假数据
//    GCD_DELAY_AFTER(1, ^{
//        successBlock();
//    });
//    return;
    
    
    
    
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"logincode"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"LOGIN_CODE",
                           
                           @"phone": phoneNumber,
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        successBlock();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  2.登录
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    if ([phoneNumber isEmpty] || [code isEmpty] || !phoneNumber || !code) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "security": "1b414847-0eeb-4951-9415-e55ed17dba12",
     "token": "434dff40-75a3-431b-8bae-0be200f8729a",
     "status": "SUCCESS",
     "message": "登录成功",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1489023868,
     "action": "LOGIN",
     "userId": 4
     }
     */
    
//    //假数据
//    GCD_DELAY_AFTER(1, ^{
//        [k_NSUserDefaults setObject:@"434dff40-75a3-431b-8bae-0be200f8729a" forKey:@"token"];
//        [k_NSUserDefaults setObject:@"1b414847-0eeb-4951-9415-e55ed17dba12" forKey:@"security"];
//        [k_NSUserDefaults setObject:@"4" forKey:@"userId"];
//        [k_NSUserDefaults synchronize];
//        
//        successBlock();
//    });
//    return ;
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"login"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"LOGIN",
                           
                           @"phone": phoneNumber,
                           @"code": code,
                           @"pushType": @"BAIDU",
                           @"channelld": @"xxxxxx",
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            [k_NSUserDefaults setObject:jsonDict[@"token"] forKey:@"token"];
            [k_NSUserDefaults setObject:jsonDict[@"security"] forKey:@"security"];
            [k_NSUserDefaults setObject:toNSString(jsonDict[@"userId"]) forKey:@"userId"];
            [k_NSUserDefaults synchronize];
            successBlock();
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  4.退出登录
 */
- (void)logout:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "成功退出！",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1489193110,
     "action": "LOG_OUT",
     "userId": 4
     }
     */
    
//    //假数据
//    GCD_DELAY_AFTER(1, ^{
//        [k_NSUserDefaults removeObjectForKey:@"token"];
//        [k_NSUserDefaults removeObjectForKey:@"security"];
//        [k_NSUserDefaults removeObjectForKey:@"userId"];
//        [k_NSUserDefaults synchronize];
//        successBlock();
//    });
//    return ;
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"logout"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"LOG_OUT",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            [k_NSUserDefaults removeObjectForKey:@"token"];
            [k_NSUserDefaults removeObjectForKey:@"security"];
            [k_NSUserDefaults removeObjectForKey:@"userId"];
            [k_NSUserDefaults synchronize];
            successBlock();
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  18.获取用户详细信息
 */
- (void)getUserObject:(void (^)(UserObject *userObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "user": {
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
     },
     "status": "SUCCESS",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_DETAIL",
     "userId": 4
     }
     */
    
//    //假数据
//    GCD_DELAY_AFTER(1, ^{
//        failureBlock(@"TOKEN_ERROR", @"获取用户详细信息失败");
//    });
//    return;
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_DETAIL",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            UserObject *userObject = [UserObject mj_objectWithKeyValues:jsonDict[@"user"]];
            
            //更新UserObject单例
            [self updateUserObject:userObject];
            
            successBlock(userObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  26.获取用户余额,押金,信用
 */
- (void)getBalanceObject:(void (^)(BalanceObject *balanceObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "orders": null,
     "status": "SUCCESS",
     "message": "user balance information",
     "payLoad": {
     "user": 4,
     "balance": 0.0,
     "deposit": 0.0,
     "accountNO": "30106608-03cf-4fc8-bafa-a395f3e86a92",
     "credit": 0,
     "id": 9,
     "createDt": "2017-03-15 15:37:24"
     },
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_BALANCE",
     "userId": 4
     }
     */
    
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/balance"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_BALANCE",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            BalanceObject *balanceObject = [BalanceObject mj_objectWithKeyValues:jsonDict[@"payLoad"]];
            
            //更新BalanceObject单例
            [self updateBalanceObject:balanceObject];
            
            successBlock(balanceObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  20.编辑用户信息
 */
- (void)updateUser:(UpdateUserType)updateUserType value:(NSString *)value success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "user": null,
     "status": "SUCCESS",
     "message": "更新用户成功",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "UPDATE_USER",
     "userId": 4
     }
     */
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/update"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"UPDATE_USER",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"loginName": [self returnNotNil:[UserObject sharedInstance].loginName],
                           @"sex": [self returnNotNil:[UserObject sharedInstance].sex],
                           @"birthday": [NSNumber numberWithString:[self returnNotNil:[UserObject sharedInstance].birthday]],
                           @"description": [self returnNotNil:[UserObject sharedInstance].Description],
                           };
    NSMutableDictionary *dic = [para mutableCopy];
    
    
    
    
    if (updateUserType == UpdateUserType_name) {
        //昵称
        [dic setObject:value forKey:@"loginName"];
    }
    if (updateUserType == UpdateUserType_sex) {
        //性别
        [dic setObject:[self calculateSex:value] forKey:@"sex"];
    }
    if (updateUserType == UpdateUserType_age) {
        //年龄
        [dic setObject:[self calculateAge:value] forKey:@"birthday"];
    }
    if (updateUserType == UpdateUserType_sign) {
        //个性签名
        [dic setObject:value forKey:@"description"];
    }
    
    
    
    
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:[dic copy] header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            [UserObject sharedInstance].loginName = dic[@"loginName"];
            [UserObject sharedInstance].sex = dic[@"sex"];
            [UserObject sharedInstance].birthday = [dic[@"birthday"] stringValue];
            [UserObject sharedInstance].Description = dic[@"description"];
            
            successBlock(jsonDict[@"message"]);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  21.上传用户头像
 */
- (void)uploadUserPhoto:(UIImage *)image success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!image) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "user": null,
     "status": "SUCCESS",
     "message": "http://139.224.16.177/user/4_photo.jpg",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1489490767844,
     "action": "UPDATE_HEADPHOTO",
     "userId": 4
     }
     */
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/photo"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"UPDATE_HEADPHOTO",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"phone": [self returnNotNil:[UserObject sharedInstance].phone],
                           };
    
    
    
    [[NetworkManager sharedInstance] uploadData:UIImageJPEGRepresentation(image, kCompressionQuality) withURL:url method:@"POST" parameter:para header:nil body:nil name:@"photo" fileName:[self getRandomFileName] mimeType:@"image/jpeg" timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *message = jsonDict[@"message"];
            [UserObject sharedInstance].photoUrl = message;
            
            successBlock(message);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  25.故障申报
 */
- (void)reportFault_typeTitle:(NSString *)typeTitle content:(NSString *)content image:(UIImage *)image bankCode:(NSString *)bankCode success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!image || !typeTitle || !content || !bankCode || [typeTitle isEmpty] || [content isEmpty] || [bankCode isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     */
    
    NSString *faultType = @"OTHER";
    if ([typeTitle isEqualToString:@"电量不足"]) {
        faultType = @"NO_ENOUGH_CAPACITY";
    }
    if ([typeTitle isEqualToString:@"借取失败"]) {
        faultType = @"FAULT_BORROW";
    }
    if ([typeTitle isEqualToString:@"充电宝损坏"]) {
        faultType = @"FAULT_BANK";
    }
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/reportFault"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"REPORT_FAULT",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"faultType": faultType,
                           @"bankCode": bankCode,
                           @"faultContent": content,
                           };
    
    
    
    [[NetworkManager sharedInstance] uploadData:UIImageJPEGRepresentation(image, kCompressionQuality) withURL:url method:@"POST" parameter:para header:nil body:nil name:@"attachment" fileName:[self getRandomFileName] mimeType:@"image/jpeg" timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *message = jsonDict[@"message"];

            successBlock(message);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  6.获取最近的充电桩信息(仅限地图)
 */
- (void)getStationObjects_latitude:(double)latitude longitude:(double)longitude scope:(NSInteger)scope countNo:(NSInteger)countNo success:(void (^)(NSArray *stationObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "list": [
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
         "statistic": null,
         "positions": null,
         "id": 11,
         "createDt": "2017-01-26 18:25:04"
         },
     ],
     "status": "SUCCESS",
     "message": "near stations",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "NEAR_STATION",
     "userId": 4
     }
     */
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/nearstations"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"NEAR_STATION",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"countNo": [NSNumber numberWithInteger:countNo],
                           @"scope": [NSNumber numberWithInteger:scope],
                           @"latitude": [NSNumber numberWithDouble:latitude],
                           @"longitude": [NSNumber numberWithDouble:longitude],
                           };

    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *stationObjects = [[StationObject mj_objectArrayWithKeyValuesArray:jsonDict[@"list"]] copy];
            successBlock(stationObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  7.搜索附近的充电桩
 */
- (void)searchStationObjects_latitude:(double)latitude longitude:(double)longitude scope:(NSInteger)scope countNo:(NSInteger)countNo success:(void (^)(NSArray *stationObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "near stations list",
     "payLoad": [
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
     ],
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "SEARCH_STATION",
     "userId": 4
     }
     */
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/search"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"SEARCH_STATION",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"countNo": [NSNumber numberWithInteger:countNo],
                           @"scope": [NSNumber numberWithInteger:scope],
                           @"latitude": [NSNumber numberWithDouble:latitude],
                           @"longitude": [NSNumber numberWithDouble:longitude],
                           };
    
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *stationObjects = [[StationObject mj_objectArrayWithKeyValuesArray:jsonDict[@"payLoad"]] copy];
            successBlock(stationObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  19.获取用户好友
 */
- (void)getFriendObjects:(void (^)(NSArray *friendObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": [
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
     ],
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_FRIENDS",
     "userId": 1
     }
     */
    
    NSDictionary *dict =
    @{
      @"status": @"SUCCESS",
      @"message": @"",
      @"payLoad": @[
              @{
                  @"loginName": @"我想你fvg",
                  @"realName": @"",
                  @"phone": @"18123856209",
                  @"email": @"18123856209",
                  @"status": @"ENABLE",
                  @"photoUrl": @"http://139.224.16.177/user/2_photo.jpg",
                  @"description": @"多么娟娟",
                  @"channelId": @"",
                  @"pushType": @"BAIDU",
                  @"appType": @4,
                  @"myInviteCode": @"qiqoucfc",
                  @"sex": @"M",
                  @"birthday": @556661,
                  @"id": @2,
                  @"createDt": @"2017-02-08 21:24:19",
                  },
              @{
                  @"loginName": @"百度logo",
                  @"realName": @"",
                  @"phone": @"18123856209",
                  @"email": @"18123856209",
                  @"status": @"ENABLE",
                  @"photoUrl": @"https://www.baidu.com/img/bd_logo1.png",
                  @"description": @"多么娟娟",
                  @"channelId": @"",
                  @"pushType": @"BAIDU",
                  @"appType": @4,
                  @"myInviteCode": @"qiqoucfc",
                  @"sex": @"M",
                  @"birthday": @556661,
                  @"id": @2,
                  @"createDt": @"2017-02-08 21:24:19",
                  }
              ],
      @"version": @"1.0.0",
      @"messageDt": @1488966375,
      @"action": @"USER_FRIENDS",
      @"userId": @1,
      };
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/friends"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_FRIENDS",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        jsonDict = dict;//假数据
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *friendObjects = [[FriendObject mj_objectArrayWithKeyValuesArray:jsonDict[@"payLoad"]] copy];
            successBlock(friendObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  27.消息列表
 */
- (void)getMessageObjects_pageNO:(NSInteger)pageNO success:(void (^)(NSArray *messageObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": [
     {
     "title": "TEST1",
     "content": "THIS IS A TEST!",
     "status": "READ",
     "msg_type": "ORDER",
     "user": 4,
     "id": 1009,
     "createDt": "2017-02-17 22:29:13"
     },
     {
     "title": "TEST",
     "content": "THIS IS A TEST!",
     "status": "READ",
     "msg_type": "ORDER",
     "user": 4,
     "id": 1008,
     "createDt": "2017-02-17 22:29:13"
     }
     ],
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_ORDER",
     "userId": 4
     }
     */
    
    NSDictionary *dict =
    @{
      @"status": @"SUCCESS",
      @"message": @"",
      @"payLoad": @[
              @{
                  @"title": @"TEST1",
                  @"content": @"THIS IS A TEST!",
                  @"status": @"READ",
                  @"msg_type": @"ORDER",
                  @"user": @4,
                  @"id": @1009,
                  @"createDt": @"2017-02-17 22:29:13",
                  },
              @{
                  @"title": @"TEST",
                  @"content": @"THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!THIS IS A TEST!",
                  @"status": @"UNREAD",
                  @"msg_type": @"NEWS",
                  @"user": @4,
                  @"id": @1008,
                  @"createDt": @"2017-02-17 22:29:13",
                  }
              ],
      @"version": @"1.0.0",
      @"messageDt": @1488966375,
      @"action": @"USER_ORDER",
      @"userId": @4,
      };
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/message"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_ORDER",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"pageNO": [NSNumber numberWithInteger:pageNO],
                           };
    
    NSMutableDictionary *dic = [para mutableCopy];
    if (pageNO == 0) {
        [dic removeObjectForKey:@"pageNO"];
    }
    
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:[dic copy] header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        jsonDict = dict;//假数据

        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *messageObjects = [[MessageObject mj_objectArrayWithKeyValuesArray:jsonDict[@"payLoad"]] copy];
            successBlock(messageObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  28.标记消息已读
 */
- (void)setMessageRead_messageId:(NSString *)messageId success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!messageId || [messageId isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "maek read success",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_ORDER",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/message/read"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_ORDER",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"messageId": [NSNumber numberWithString:messageId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);

        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *message = jsonDict[@"message"];
            successBlock(message);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  22.获取用户订单列表
 */
- (void)getOrderObjects_lastOrderId:(NSString *)lastOrderId success:(void (^)(NSArray *orderObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!lastOrderId || [lastOrderId isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "orders": [
             {
                "totalFee": 100,
                "orderOwner": 4,
                "parentOrder": null,
                "agency": 1,
                "type": "BALANCE",
                "status": "PENDING",
                "orderNo": "9dfeefba-92b7-4885-97d8-3ee222b",
                "startDt": null,
                "endDt": null,
                "id": 1070,
                "createDt": "2017-03-11 20:09:39"
             },
     ],
     "status": "SUCCESS",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_ORDERS",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/order"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_ORDERS",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"lastOrderId": [NSNumber numberWithString:lastOrderId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *orderObjects = [[OrderObject mj_objectArrayWithKeyValuesArray:jsonDict[@"orders"]] copy];
            successBlock(orderObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  23.获取订单详情
 */
- (void)getOrderDetail_orderId:(NSString *)orderId success:(void (^)(OrderObject *orderObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!orderId || [orderId isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "order detail!",
     "payLoad": {
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
                 },
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "USER_ORDER",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/orderDetail"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_ORDER",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"orderId": [NSNumber numberWithString:orderId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            OrderObject *orderObject = [OrderObject mj_objectWithKeyValues:jsonDict[@"payLoad"]];
            successBlock(orderObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  24.判断充电桩详情
 */
- (void)getStationConnectType_stationCode:(NSString *)stationCode success:(void (^)(NSString *connectType, NSString *stationId))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!stationCode || [stationCode isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": {
     "connectType": "BULETOOTH",
     "stationId": 1
     },
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "STATION_TYPE",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/connectType"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"STATION_TYPE",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"stationCode": [NSNumber numberWithString:stationCode],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSDictionary *payLoad = jsonDict[@"payLoad"];
            NSString *connectType = payLoad[@"connectType"];
            NSString *stationId = toNSString(payLoad[@"stationId"]);
            
            successBlock(connectType, stationId);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  3.更新用户的百度推送channel
 */
- (void)updateBaiduChannelId:(NSString *)channelId success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (!channelId || [channelId isEmpty]) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "channel register success",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 141414123524,
     "action": "USER_CHANNEL",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/channel"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"USER_CHANNEL",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"channelId": [NSNumber numberWithString:channelId],
                           @"pushType": @"BAIDU"
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *message = jsonDict[@"message"];
            successBlock(message);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  15.获取押金金额
 */
- (void)getDeposit:(void (^)(NSString *deposit))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "SUCCESS",
     "message": "SUCCESS",
     "payLoad": 100.0,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "DEPOSIT_VALUE",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"pay/deposit/value"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"DEPOSIT_VALUE",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *deposit = toNSString(jsonDict[@"payLoad"]);
            
            if (deposit) {
                [k_NSUserDefaults setObject:deposit forKey:@"deposit"];
                [k_NSUserDefaults synchronize];
            }
            
            successBlock(deposit);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  8.获取充电桩详细信息
 */
- (void)getStationDetail_stationId:(NSString *)stationId success:(void (^)(StationObject *stationObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([stationId isEmpty] || !stationId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "station": {
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
     "id": 11,
     "createDt": "2017-01-26 18:25:04"
     },
     "status": "SUCCESS",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "GET_STATION",
     "userId": 4
     }
     */
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/detail"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"GET_STATION",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"stationId": [NSNumber numberWithString:stationId]
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            StationObject *stationObject = [StationObject mj_objectWithKeyValues:jsonDict[@"station"]];
            successBlock(stationObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  14.退押金
 */
- (void)returnDeposit:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /*
     {
     "status": "NO_DEPOSIT",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "REFUND",
     "userId": 4
     }
     */

    //STATUS:
    //NO_DEPOSIT: 没有押金，不可退款
    //NEED_PAY：有欠款订单，需要支付后方可退款
    //SUCCESS:退款成功
    //FAILED:退款失败
    
    NSDictionary *dict =
    @{
        @"status": @"SUCCESS",
        @"message": @"",
        @"payLoad": @"",
        @"version": @"1.0.0",
        @"messageDt": @1488966375,
        @"action": @"REFUND",
        @"userId": @4
        };

    
    
    NSString *url = [kBaseURL stringByAppendingString:@"pay/refund"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"REFUND",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           @"tradeType": @"APP",
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
//        jsonDict = dict;//假数据(支付)
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            successBlock();
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  12.充值
 */
- (void)pay_payType:(PayType)payType money:(NSString *)money success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([money isEmpty] || !money) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    /*
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": {
     "sign": "5D9022A6EF929303C8F83AB1CE81FEA0",
     "appid": "wx0a6f912b64eaf720",
     "noncestr": "5k402burqbi4u3i6g2jcvx44pkyrq14c",
     "packageKey": "Sign\u003dWXPay",
     "partnerid": "1442541002",
     "prepayid": null,
     "params": "appid\u003dwx0a6f912b64eaf720\u0026body\u003d充值余额\u0026mch_id\u003d1442541002\u0026nonce_str\u003d5k402burqbi4u3i6g2jcvx44pkyrq14c\u0026notify_url\u003dhttp://www.popularpowers.com/api/app/weixin/notify\u0026out_trade_no\u003df545e131-2925-4be1-ab12-60ae0d4\u0026spbill_create_ip\u003d139.224.16.177\u0026total_fee\u003d100\u0026trade_type\u003dAPP"
     },
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "RECHARGE",
     "userId": 4
     }
     */
    
    NSString *xxx = @"weixin";
    if (payType == PayType_alipay) {
        xxx = @"zhifubao";
    }
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"pay/balance"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"RECHARGE",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"payType": xxx,
                           @"tradeType": @"APP",
                           @"money": [NSNumber numberWithString:money],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            PayObject *payObject = [PayObject mj_objectWithKeyValues:jsonDict[@"payLoad"]];
            successBlock(payObject);
        }
        else
        {            
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  16.缴押金
 */
- (void)payDeposit_payType:(PayType)payType success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }

    /*
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": {
     "sign": "3B8EE10FBC5416C7402896AA7D5076D8",
     "appid": "wx0a6f912b64eaf720",
     "noncestr": "nrmkaxp0c9i82fetjzz5hbs4gmndd925",
     "packageKey": "Sign\u003dWXPay",
     "partnerid": "1442541002",
     "prepayid": null,
     "params": "appid\u003dwx0a6f912b64eaf720\u0026body\u003d充值余额\u0026mch_id\u003d1442541002\u0026nonce_str\u003dnrmkaxp0c9i82fetjzz5hbs4gmndd925\u0026notify_url\u003dhttp://www.popularpowers.com/api/app/weixin/notify\u0026out_trade_no\u003df09dfffd-400e-40e4-8926-7aad8dd\u0026spbill_create_ip\u003d139.224.16.177\u0026total_fee\u003d100\u0026trade_type\u003dAPP"
     },
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "CONSUME",
     "userId": 4
     }
     */
    
    NSString *xxx = @"weixin";
    if (payType == PayType_alipay) {
        xxx = @"zhifubao";
    }
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"pay/deposit"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"CONSUME",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"payType": xxx,
                           @"tradeType": @"APP",
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            PayObject *payObject = [PayObject mj_objectWithKeyValues:jsonDict[@"payLoad"]];
            successBlock(payObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  11.借用充电宝
 */
- (void)borrow_stationCode:(NSString *)stationCode success:(void (^)(BorrowObject *borrowObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([stationCode isEmpty] || !stationCode) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if (![stationCode isPureNumandCharacters]) {
        failureBlock(kNoParameter_status, @"编码无效");
        return;
    }
    
    
    
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
    
//    Status                状态
//    RES_DUPLICATE         重复消息，此消息需要缓存确保后台处理。收到此消息说明server以处理
//    NOT_ENOUGH_MONEY      余额不够，需要支付， 此时后台返回：订单号orderId， 订单金额needPay，支付消息message
//    SUCCESS               成功，将返回相应的station，position，bank的code. 此时用户余额充足
//    RES_BORROW_MORE_3     用户最多可以借用三个充电宝，多了禁止借用，提醒用户需要归还方可借用
    
    NSDictionary *dict =
    @{
        @"needDeposit": @100.0,
        @"needBalance": @0.0,
        @"consume": @0.0,
        @"goodType": @"DEPOSIT_BANLANCE",
        @"orderId": @1073,
        @"status": @"SUCCESS",
        @"message": @"押金:100.0",
        @"payLoad": @"",
        @"version": @"1.0.0",
        @"messageDt": @1488966375,
        @"action": @"BORROW",
        @"userId": @4,
        };
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/borrow"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"BORROW",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"stationCode": [NSNumber numberWithString:stationCode],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        jsonDict = dict;//假数据(借)
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            BorrowObject *borrowObject = [BorrowObject mj_objectWithKeyValues:jsonDict];
            successBlock(borrowObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  10.上传充电桩详细信息
 */
- (void)synch_stationCode:(NSString *)stationCode positionObjects:(NSArray *)positionObjects success:(void (^)(StationObject *stationObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([stationCode isEmpty] || !stationCode) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "station": {
                 "code": "10015",
                 "address": "深圳市第二人民医院",
                 "agent": 1,
                 "region": 1000101,
                 "latitude": 22.557046,
                 "longitude": 114.085469,
                 "wxUser": "zhangsan",
                 "wxUserPhone": "1341234134",
                 "status": "ENABLE",
                 "produceDate": "2017-01-14 09:41:59",
                 "ProductCreator": "zhangsan",
                 "shopName": "nihao",
                 "connectType": "BULETOOTH",
                 "regionValue": null,
                 "create_user": null,
                 "statistic": null,
                 "positions": [],
                 "id": 5,
                 "createDt": "2017-01-06 12:48:06"
                 },
     "status": "SUCCESS",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966378,
     "action": "STATION_INFO",
     "userId": 4
     }
     */
    
    
//Status:
//    
//    RES_DUPLICATE         重复消息，此消息需要缓存确保后台处理。收到此消息说明server以处理
//    STATION_NOT_EXIST     stationCode对应的充电桩不存在
//    STATION_INUSE         充电桩正在被使用，并发借用情况提醒用户等等
//    NO_BANK_BORROW        如果卡遭中没有任何充电宝，将返回该信息
//    SUCCESS               成功，将返回相应的station，position，bank的code
    
    
    
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (PositionObject *positionObject in positionObjects) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:positionObject.code forKey:@"code"];
        [dic setObject:[NSNumber numberWithString:positionObject.capacity] forKey:@"capacity"];
        [dic setObject:[NSNumber numberWithBool:positionObject.canBorrow] forKey:@"canBorrow"];
        
        [arr addObject:[dic copy]];
    }
    
    [dict setObject:stationCode forKey:@"stationCode"];
    [dict setObject:[arr copy] forKey:@"positions"];
    
    
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/synch"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"STATION_INFO",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"station": [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[dict copy] options:0 error:nil] encoding:NSUTF8StringEncoding],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);

        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            StationObject *stationObject = [StationObject mj_objectWithKeyValues:jsonDict[@"station"]];
            successBlock(stationObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  17.还充电宝
 *
 *  @param stationCode      充电桩编码
 *  @param positionCode     卡槽编号
 *  @param bankCode         充电宝编码，为空意为空闲卡槽
 */
- (void)return_stationCode:(NSString *)stationCode positionCode:(NSString *)positionCode bankCode:(NSString *)bankCode success:(void (^)(NSDictionary *orderPayMap))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([stationCode isEmpty] || !stationCode) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([positionCode isEmpty] || !positionCode) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([bankCode isEmpty] || !bankCode) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "orderPayMap": {},
     "status": "STATION_NOT_EXIST",
     "message": null,
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966377,
     "action": "RETURN",
     "userId": 4
     }
     */
    
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"station/return"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"RETURN",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"station": stationCode,
                           @"position": positionCode,
                           @"bank": bankCode,
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSDictionary *orderPayMap = jsonDict[@"orderPayMap"];
            successBlock(orderPayMap);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  13.用户借用消费
 */
- (void)pay_payType:(PayType)payType orderId:(NSString *)orderId success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([orderId isEmpty] || !orderId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "status": "SUCCESS",
     "message": null,
     "payLoad": {
             "sign": "C6C3C5AC390125260951270CEBB8CB70",
             "appid": "wx0a6f912b64eaf720",
             "noncestr": "jvd9wzdrpb1xcr0rijoyrgovuvwdqj5d",
             "packageKey": "Sign\u003dWXPay",
             "partnerid": "1442541002",
             "prepayid": null,
             "params": "appid\u003dwx0a6f912b64eaf720\u0026body\u003d借用消费\u0026mch_id\u003d1442541002\u0026nonce_str\u003djvd9wzdrpb1xcr0rijoyrgovuvwdqj5d\u0026notify_url\u003dhttp://139.224.16.177:9000/api/app/pay/notify\u0026out_trade_no\u003d8b2b7150-1c3b-4cbd-b530-77e05a9\u0026spbill_create_ip\u003d139.224.16.177\u0026total_fee\u003d100\u0026trade_type\u003dAPP"
             },
     "version": "1.0.0",
     "messageDt": 14889663324,
     "action": "CONSUME",
     "userId": 4
     }
     */
    
    
    
    
    NSString *xxx = @"weixin";
    if (payType == PayType_alipay) {
        xxx = @"zhifubao";
    }
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"pay"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"CONSUME",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"payType": xxx,
                           @"tradeType": @"APP",
                           @"orderId": [NSNumber numberWithString:orderId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            PayObject *payObject = [PayObject mj_objectWithKeyValues:jsonDict[@"payLoad"]];
            successBlock(payObject);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  29.用户反馈
 */
- (void)feedBack:(NSString *)description success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    if ([description isEmpty] || !description) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "status": "SUCCESS",
     "message": "feed back commit successfuly",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "FEED_BACK",
     "userId": 4
     }
     */
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/feedback"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"FEED_BACK",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"description": description,
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSString *message = jsonDict[@"message"];
            
            successBlock(message);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  30.获取用户未支付订单
 */
- (void)unpayorders:(void (^)(NSArray *orderObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "status": "SUCCESS",
     "message": "have unpay consume order?false",
     "payLoad": [],
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "UNPAY_ORDER",
     "userId": 4
     }
     */
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/unpayorders"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"UNPAY_ORDER",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            NSArray *orderObjects = [[OrderObject mj_objectArrayWithKeyValuesArray:jsonDict[@"payLoad"]] copy];
            successBlock(orderObjects);
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}

/**
 *  31.前端上报支付成功
 */
- (void)payreport_orderId:(NSString *)orderId statusType:(StatusType)statusType success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock
{
    NSString *token = [k_NSUserDefaults objectForKey:@"token"];
    NSString *userId = [k_NSUserDefaults objectForKey:@"userId"];
    
    if ([token isEmpty] || [userId isEmpty] || !token || !userId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    if ([orderId isEmpty] || !orderId) {
        failureBlock(kNoParameter_status, kNoParameter_msg);
        return;
    }
    
    /**
     {
     "status": "SUCCESS",
     "message": "report successfully",
     "payLoad": null,
     "version": "1.0.0",
     "messageDt": 1488966375,
     "action": "PAY_REPORT",
     "userId": 4
     }
     */
    
    NSString *status = @"SUCCESS";
    if (statusType == StatusType_fail) {
        status = @"FAILED";
    }
    
    
    NSString *url = [kBaseURL stringByAppendingString:@"user/payreport"];
    NSDictionary *para = @{
                           @"messageDt": [NSNumber numberWithString:[[NSDate date] timestamp]],
                           @"version": [UIDeviceHardware appVersion],
                           @"appType": @4,
                           @"action": @"PAY_REPORT",
                           
                           @"token": token,
                           @"userId": [NSNumber numberWithString:userId],
                           
                           @"orderId": [NSNumber numberWithString:orderId],
                           @"status": status,
                           };
    
    [[NetworkManager sharedInstance] requestDataWithURL:url method:@"POST" parameter:para header:nil cookies:nil body:nil timeoutInterval:kTimeout result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        DLog(jsonDict);
        
        if ([jsonDict[@"status"] isEqualToString:@"SUCCESS"])
        {
            //成功
            successBlock();
        }
        else
        {
            //失败
            failureBlock(kError_status, [self return_kError_msg:jsonDict]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *errorDict = [error userInfo];
        NSString *errorCode = toNSString([error code]);
        NSString *errorMsg = [error localizedDescription];
        DLog(errorDict);
        
        if (!errorDict) {
            failureBlock(kNoNetwork_status, kNoNetwork_msg);
        }else{
            failureBlock(errorCode, errorMsg);
        }
    }];
}











/*
//---------------------------------------------- mock配置 ----------------------------------------------/
- (void)setupHttpMock
{
    MockRequest *request1 = [[MockRequest alloc] initWithMethod:@"GET" path:@"/111" parameter:@{@"para1":@"para1"} header:@{@"header1":@"header1"} delay:0.5 responseJson:@{@"result1":@"result1"}];
 
    MockRequest *request2 = [[MockRequest alloc] initWithMethod:@"GET" path:@"/222" parameter:@{@"para2":@"para2"} header:@{@"header2":@"header2"} delay:0.5 responseJsonFile:@"test_get.json" location:kBundle];
    
    MockRequest *request3 = [[MockRequest alloc] initWithMethod:@"POST" path:@"/333" parameter:@{@"para3":@"para3"} header:@{@"header3":@"header3"} delay:0.5 responseJson:@{@"result3":@"result3"}];
    
    MockRequest *request4 = [[MockRequest alloc] initWithMethod:@"POST" path:@"/444" parameter:@{@"para4":@"para4"} header:@{@"header4":@"header4"} delay:0.5 responseJsonFile:[self saveBundleToSandbox:@"test_post.json"] location:kSandbox];
    
    
    
    // 启动http模拟服务
    [LMHttpMock start:@[request1, request2, request3, request4] port:8888 result:^(NSURL *serverURL) {
        
        NSLog(@"%@", serverURL);
    }];
}

//---------------------------------------------- mock验证 ----------------------------------------------/
- (void)testGET
{
    [[HUDHelper sharedInstance] loading];
    
    [[NetworkManager sharedInstance] requestDataWithURL:@"http://localhost:8888/111" method:@"GET" parameter:@{@"para1":@"para1"} header:@{@"header1":@"header1"} cookies:nil body:nil timeoutInterval:MAXFLOAT result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[HUDHelper sharedInstance] stopLoading];
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"GET success:\n %@", jsonDict]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"GET fail:\n %@", error.userInfo[@"NSLocalizedDescription"]]];
    }];
}

- (void)testGET_JsonFile
{
    [[HUDHelper sharedInstance] loading];
    
    [[NetworkManager sharedInstance] requestDataWithURL:@"http://localhost:8888/222" method:@"GET" parameter:@{@"para2":@"para2"} header:@{@"header2":@"header2"} cookies:nil body:nil timeoutInterval:MAXFLOAT result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[HUDHelper sharedInstance] stopLoading];
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"GET success:\n %@", jsonDict]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"GET fail:\n %@", error.userInfo[@"NSLocalizedDescription"]]];
    }];
}

- (void)testPOST
{
    [[HUDHelper sharedInstance] loading];
    
    [[NetworkManager sharedInstance] requestDataWithURL:@"http://localhost:8888/333" method:@"POST" parameter:@{@"para3":@"para3"} header:@{@"header3":@"header3"} cookies:nil body:nil timeoutInterval:MAXFLOAT result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[HUDHelper sharedInstance] stopLoading];
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"POST success:\n %@", jsonDict]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"POST fail:\n %@", error.userInfo[@"NSLocalizedDescription"]]];
    }];
}

- (void)testPOST_JsonFile
{
    [[HUDHelper sharedInstance] loading];
    
    [[NetworkManager sharedInstance] requestDataWithURL:@"http://localhost:8888/444" method:@"POST" parameter:@{@"para4":@"para4"} header:@{@"header4":@"header4"} cookies:nil body:nil timeoutInterval:MAXFLOAT result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[HUDHelper sharedInstance] stopLoading];
        NSDictionary *jsonDict = [[JSONManager alloc] transformDatatodic:responseObject];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"POST success:\n %@", jsonDict]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:[NSString stringWithFormat:@"POST fail:\n %@", error.userInfo[@"NSLocalizedDescription"]]];
    }];
}
 */

@end
