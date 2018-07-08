//
//  LMHttpMock.m
//  test
//
//  Created by liman on 7/22/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import "LMHttpMock.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import "GCDWebServerHTTPStatusCodes.h"

@interface MockRequest ()

@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSDictionary *parameter;
@property (strong, nonatomic) NSDictionary *header;
@property (assign, nonatomic) CGFloat delay;
@property (strong, nonatomic) NSDictionary *responseJson;

@end

@implementation MockRequest

#pragma mark - public
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
- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameter:(NSDictionary *)parameter header:(NSDictionary *)header delay:(CGFloat)delay responseJson:(NSDictionary *)responseJson
{
    self = [super init];
    if (self) {
        
        _method = method;
        _path = path;
        _parameter = parameter;
        _header = header;
        _delay = delay;
        _responseJson = responseJson;
    }
    return self;
}

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
- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameter:(NSDictionary *)parameter header:(NSDictionary *)header delay:(CGFloat)delay responseJsonFile:(NSString *)responseJsonFile location:(kLocation)location
{
    self = [super init];
    if (self) {
        
        NSString *filePath = nil;
        if (location == kSandbox)
        {
            filePath = [[SANDBOX_DOCUMENT_PATH stringByAppendingString:@"/"] stringByAppendingString:responseJsonFile];
        }
        else
        {
            filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:responseJsonFile];
        }
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        
        _method = method;
        _path = path;
        _parameter = parameter;
        _header = header;
        _delay = delay;
        _responseJson = [jsonDict copy];
    }
    return self;
}

@end



//=======================================================================================================================================



@interface LMHttpMock ()

@end

@implementation LMHttpMock

#pragma mark - public
/**
 *  启动http模拟服务
 */
+ (void)start:(NSArray *)mockRequests port:(NSUInteger)port result:(void (^)(NSURL *serverURL))block
{
    GCDWebServer *webServer = [GCDWebServer new];
    
    
    for (MockRequest *mockRequest in mockRequests) {
        
        [self mockWithWebServer:webServer method:mockRequest.method path:mockRequest.path parameter:mockRequest.parameter header:mockRequest.header responseJson:mockRequest.responseJson delay:mockRequest.delay port:port];
    }
    
    
    [webServer startWithPort:port bonjourName:nil];
    block(webServer.serverURL);
}

#pragma mark - tool
+ (void)mockWithWebServer:(GCDWebServer *)webServer method:(NSString *)method path:(NSString *)path parameter:(NSDictionary *)parameter header:(NSDictionary *)header responseJson:(NSDictionary *)responseJson delay:(CGFloat)delay port:(NSUInteger)port
{
    /******************************************************* GET请求 ****************************************************/
    if ([method isEqualToString:@"GET"])
    {
        [webServer addHandlerForMethod:@"GET" path:path requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
            
            NSLog(@"request: %@", request);
            
            // 判断parameter
            if (parameter)
            {
                if (![request.query isEqualToDictionary:parameter])
                {
                    GCDWebServerResponse *response = [GCDWebServerResponse responseWithStatusCode:kGCDWebServerHTTPStatusCode_BadRequest];
                    completionBlock(response);
                    return;
                }
            }
            
            // 判断header
            if (header)
            {
                for (NSString *key in [header allKeys]) {
                    if (![request.headers[key] isEqualToString:header[key]])
                    {
                        GCDWebServerResponse *response = [GCDWebServerResponse responseWithStatusCode:kGCDWebServerHTTPStatusCode_BadRequest];
                        completionBlock(response);
                        return;
                    }
                }
            }
            
            // 成功
            GCD_DELAY_AFTER(delay, ^{
                GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithJSONObject:responseJson];
                completionBlock(response);
            });
        }];
    }
    
    
    /******************************************************* POST请求 ****************************************************/
    if ([method isEqualToString:@"POST"])
    {
        [webServer addHandlerForMethod:@"POST" path:path requestClass:[GCDWebServerURLEncodedFormRequest class] asyncProcessBlock:^(GCDWebServerRequest *request, GCDWebServerCompletionBlock completionBlock) {
            
            GCDWebServerURLEncodedFormRequest *_request = (GCDWebServerURLEncodedFormRequest *)request;
            NSDictionary *_requestDict = [[JSONManager alloc] transformDatatodic:_request.data];
            NSLog(@"request: %@", _request);
            
            // 判断parameter
            if (parameter)
            {
                if (![_requestDict isEqualToDictionary:parameter])
                {
                    GCDWebServerResponse *response = [GCDWebServerResponse responseWithStatusCode:kGCDWebServerHTTPStatusCode_BadRequest];
                    completionBlock(response);
                    return;
                }
            }
            
            // 判断header
            if (header)
            {
                for (NSString *key in [header allKeys]) {
                    if (![_request.headers[key] isEqualToString:header[key]])
                    {
                        GCDWebServerResponse *response = [GCDWebServerResponse responseWithStatusCode:kGCDWebServerHTTPStatusCode_BadRequest];
                        completionBlock(response);
                        return;
                    }
                }
            }
            
            // 成功
            GCD_DELAY_AFTER(delay, ^{
                GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithJSONObject:responseJson];
                completionBlock(response);
            });
        }];
    }
}

@end
