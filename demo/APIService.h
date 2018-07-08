//
//  APIService.h
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kBaseURL @"http://139.224.16.177:9000/api/app/"

#define kTimeout 10
#define kCompressionQuality  0.2  //图片压缩率

#define kNoParameter_status     @"NO_PARAMETER"
#define kNoParameter_msg        @"参数为空"

#define kNoNetwork_status       @"NO_NETWORK"
#define kNoNetwork_msg          @"没有网络"

#define kError_status           jsonDict[@"status"]
#define kError_msg              jsonDict[@"message"]


#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UpdateUserType_name = 0, /**< 昵称 */
    UpdateUserType_sex = 1, /**< 性别 */
    UpdateUserType_age = 2, /**< 年龄 */
    UpdateUserType_sign = 3, /**< 个性签名 */
} UpdateUserType;//编辑用户信息类型

typedef enum : NSUInteger {
    PayType_wechat = 0, /**< 微信 */
    PayType_alipay = 1, /**< 支付宝 */
} PayType;//充值类型

typedef enum : NSUInteger {
    StatusType_success = 0, /**< 支付成功 */
    StatusType_fail = 1, /**< 支付失败 */
} StatusType;//支付状态

@interface APIService : NSObject

SHARED_INSTANCE_FOR_HEADER(APIService);

/**
 *  0.获取token
 */
- (void)getToken_userId:(NSString *)userId success:(void (^)(NSString *token))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  1.发送验证码
 */
- (void)sendCodeWithPhoneNumber:(NSString *)phoneNumber success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  2.登录
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  3.更新用户的百度推送channel
 */
- (void)updateBaiduChannelId:(NSString *)channelId success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  4.退出登录
 */
- (void)logout:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  5.获取服务器时间
 */
- (void)requestServerTime:(void (^)(NSString *serverTime))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  6.获取最近的充电桩信息(仅限地图)
 */
- (void)getStationObjects_latitude:(double)latitude longitude:(double)longitude scope:(NSInteger)scope countNo:(NSInteger)countNo success:(void (^)(NSArray *stationObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  7.搜索附近的充电桩
 */
- (void)searchStationObjects_latitude:(double)latitude longitude:(double)longitude scope:(NSInteger)scope countNo:(NSInteger)countNo success:(void (^)(NSArray *stationObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  8.获取充电桩详细信息
 */
- (void)getStationDetail_stationId:(NSString *)stationId success:(void (^)(StationObject *stationObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  10.上传充电桩详细信息
 */
- (void)synch_stationCode:(NSString *)stationCode positionObjects:(NSArray *)positionObjects success:(void (^)(StationObject *stationObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  11.借用充电宝
 */
- (void)borrow_stationCode:(NSString *)stationCode success:(void (^)(BorrowObject *borrowObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  12.充值
 */
- (void)pay_payType:(PayType)payType money:(NSString *)money success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  13.用户借用消费
 */
- (void)pay_payType:(PayType)payType orderId:(NSString *)orderId success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  14.退押金
 */
- (void)returnDeposit:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  15.获取押金金额
 */
- (void)getDeposit:(void (^)(NSString *deposit))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  16.缴押金
 */
- (void)payDeposit_payType:(PayType)payType success:(void (^)(PayObject *payObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  17.还充电宝
 *
 *  @param stationCode      充电桩编码
 *  @param positionCode     卡槽编号
 *  @param bankCode         充电宝编码，为空意为空闲卡槽
 */
- (void)return_stationCode:(NSString *)stationCode positionCode:(NSString *)positionCode bankCode:(NSString *)bankCode success:(void (^)(NSDictionary *orderPayMap))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  18.获取用户详细信息
 */
- (void)getUserObject:(void (^)(UserObject *userObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  19.获取用户好友
 */
- (void)getFriendObjects:(void (^)(NSArray *friendObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;


/**
 *  20.编辑用户信息
 */
- (void)updateUser:(UpdateUserType)updateUserType value:(NSString *)value success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  21.上传用户头像
 */
- (void)uploadUserPhoto:(UIImage *)image success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  22.获取用户订单列表
 */
- (void)getOrderObjects_lastOrderId:(NSString *)lastOrderId success:(void (^)(NSArray *orderObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  23.获取订单详情
 */
- (void)getOrderDetail_orderId:(NSString *)orderId success:(void (^)(OrderObject *orderObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  24.判断充电桩详情
 */
- (void)getStationConnectType_stationCode:(NSString *)stationCode success:(void (^)(NSString *connectType, NSString *stationId))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  25.故障申报
 */
- (void)reportFault_typeTitle:(NSString *)typeTitle content:(NSString *)content image:(UIImage *)image bankCode:(NSString *)bankCode success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  26.获取用户余额,押金,信用
 */
- (void)getBalanceObject:(void (^)(BalanceObject *balanceObject))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  27.消息列表
 */
- (void)getMessageObjects_pageNO:(NSInteger)pageNO success:(void (^)(NSArray *messageObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  28.标记消息已读
 */
- (void)setMessageRead_messageId:(NSString *)messageId success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  29.用户反馈
 */
- (void)feedBack:(NSString *)description success:(void (^)(NSString *message))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  30.获取用户未支付订单
 */
- (void)unpayorders:(void (^)(NSArray *orderObjects))successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;

/**
 *  31.前端上报支付成功
 */
- (void)payreport_orderId:(NSString *)orderId statusType:(StatusType)statusType success:(void (^)())successBlock failure:(void (^)(NSString *errorStatus, NSString *errorMsg))failureBlock;







/*
//---------------------------------------------- mock配置 ----------------------------------------------/
- (void)setupHttpMock;
//---------------------------------------------- mock验证 ----------------------------------------------/
- (void)testGET;
- (void)testGET_JsonFile;
- (void)testPOST;
- (void)testPOST_JsonFile;
*/




/*
    //错误返回备份
     NSDictionary *errorDict = [operation.responseString transferToJsonDict];
     NSString *errorCode = [errorDict[@"code"] stringValue];
     NSString *errorMsg = errorDict[@"message"];
     DLog(errorDict);

     if (!errorDict) {
         failureBlock(kNoNetwork_status, kNoNetwork_msg);
     }else{
         failureBlock(errorCode, errorMsg);
     }
 */

@end
