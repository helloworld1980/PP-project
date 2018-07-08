//
//  LMHttpMock.h
//  test
//
//  Created by liman on 7/22/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kBundle = 0, /**< json文件保存在bundle里 */
    kSandbox = 1, /**< json文件保存在沙盒里 */
} kLocation;

@interface MockRequest : NSObject

/**
 *  初始化MockRequest
 *
 *  @param method       GET或POST
 *  @param path         预设请求url
 *  @param parameter    预设请求参数
 *  @param header       预设请求header
 *  @param delay        预设请求延时
 *  @param responseJson 预设返回json字典
 */
- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameter:(NSDictionary *)parameter header:(NSDictionary *)header delay:(CGFloat)delay responseJson:(NSDictionary *)responseJson;

/**
 *  初始化MockRequest
 *
 *  @param method           GET或POST
 *  @param path             预设请求url
 *  @param parameter        预设请求参数
 *  @param header           预设请求header
 *  @param delay            预设请求延时
 *  @param responseJsonFile 预设返回json格式的文件
 *  @param location json文件位置
 */
- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameter:(NSDictionary *)parameter header:(NSDictionary *)header delay:(CGFloat)delay responseJsonFile:(NSString *)responseJsonFile location:(kLocation)location;

@end



//=======================================================================================================================================



@interface LMHttpMock : NSObject

/**
 *  启动http模拟服务
 */
+ (void)start:(NSArray *)mockRequests port:(NSUInteger)port result:(void (^)(NSURL *serverURL))block;

@end
