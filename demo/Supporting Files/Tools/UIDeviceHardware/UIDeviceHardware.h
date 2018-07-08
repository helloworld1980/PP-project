//
//  UIDeviceHardware.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDKeychainBindings.h"

static NSString *kAppID = @"1025278904";//援援服务

@interface UIDeviceHardware : NSObject

+ (NSString *)platform;
+ (NSString *)platformString;

//********************************************* liman *********************************************
+ (BOOL)isUpdateAvailable;

+ (NSString *)bundleId;
+ (NSString *)systemVersion;
+ (NSString *)appVersion;
+ (NSString *)appBuild;

+ (NSString *)getCarrierName;
+ (NSString *)getUUID;

@end
