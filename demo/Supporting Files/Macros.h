//
//  Macros.h
//  demo
//
//  Created by liman on 27/10/2016.
//  Copyright © 2016 apple. All rights reserved.
//

/*
 
 #ifdef DEBUG
 
 #else
 
 #endif
 
 
 
 #if TARGET_IPHONE_SIMULATOR
 
 #else
 
 #endif
 
 */


//打印
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr,"%s %s:%d\t%s\n",[[NSString stringWithFormat:@"<%@>", [[LogHelper sharedInstance] timeStamp]] UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:(@"\033[" @"fg201,119,58;" format @"\033[" @";"), ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

#define DLog(NSObject) NSLog(@"%@",NSObject);



//单例
#define SHARED_INSTANCE_FOR_HEADER(className) \
\
+ (className *)sharedInstance;

#define SHARED_INSTANCE_FOR_CLASS(className) \
\
+ (className *)sharedInstance { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}



//系统全局线程 (并行队列)
#define GCD_SYSTEM_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//系统主线程 (串行队列)
#define GCD_SYSTEM_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
//自定义线程 (串行队列)
#define GCD_MULTI_THREAD_SERIAL(block) dispatch_async(dispatch_queue_create("background", DISPATCH_QUEUE_SERIAL), block)
#define GCD_MULTI_THREAD_NULL(block) dispatch_async(dispatch_queue_create("background", NULL), block)
//自定义线程 (并行队列)
#define GCD_MULTI_THREAD_CONCURRENT(block) dispatch_async(dispatch_queue_create("background", DISPATCH_QUEUE_CONCURRENT), block)
//延迟几秒执行
#define GCD_DELAY_AFTER(time, block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), dispatch_get_main_queue(), block)


//判断主线程还是子线程
#define IS_MAIN_THREAD      [NSThread isMainThread]
#define IS_BACK_THREAD      [NSThread isMultiThreaded]


//线程安全(同步)
#define gcd_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
//线程安全(异步)
#define gcd_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}



//机型  http://stackoverflow.com/questions/25780283/ios-how-to-detect-iphone-6-plus-iphone-6-iphone-5-by-macro
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



//判断系统版本
#define IS_IOS_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)

#define IS_IOS_9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)

#define IS_IOS_10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0



// 沙盒目录
#define SANDBOX_HOME_PATH           NSHomeDirectory()
// MyApp.app
#define SANDBOX_BUNDLE_PATH         [[NSBundle mainBundle] bundlePath]
// tmp
#define SANDBOX_TEMP_PATH           NSTemporaryDirectory()
// Documents
#define SANDBOX_DOCUMENT_PATH       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// Library
#define SANDBOX_LIBRARY_PATH        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]




#define k_NSNotificationCenter [NSNotificationCenter defaultCenter]
#define k_NSUserDefaults [NSUserDefaults standardUserDefaults]
#define k_UIApplication [UIApplication sharedApplication]


//导航栏高度
#define k_NaviH 64
//随机颜色
#define k_RandomColor [UIColor randomColor]
//APP主色调
#define k_MainColor [UIColor colorWithHexString:@"#1dbe61"]









