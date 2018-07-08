//
//  NetworkManager.h
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void(^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface NetworkManager : NSObject

/**
 *  GCD单例
 */
+ (NetworkManager *)sharedInstance;


/**
 *  请求网络数据 (POST或PUT时, 需要手动拼接url?后面的参数)
 */
//- (void)requestDataWithFrontURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header cookies:(NSDictionary *)cookies body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

/**
 *  请求网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
 */
- (void)requestDataWithURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header cookies:(NSDictionary *)cookies body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;


/**
 *  下载文件
 */
- (void)downloadFile:(NSString *)fileUrl timeoutInterval:(NSTimeInterval)timeoutInterval success:(void (^)(NSData *data))successBlock failure:(void (^)(NSError *error))failureBlock;





/**
 *  上传网络数据 (POST或PUT时, 不需要手动拼接url?后面的参数)
 */
//uploadData:data name:@"test" fileName:@"test.png" mimeType:@"image/jpeg"
- (void)uploadData:(NSData *)data withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  上传图片数组
 */
- (void)uploadImages:(NSArray *)images withURL:(NSString *)url method:(NSString *)method parameter:(NSDictionary *)parameter header:(NSDictionary *)header body:(NSString *)body timeoutInterval:(NSTimeInterval)timeoutInterval result:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end



