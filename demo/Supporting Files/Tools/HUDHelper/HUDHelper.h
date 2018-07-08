//
//  HUDHelper.h
//  HUD_demo
//
//  Created by liman on 9/5/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDHelper : NSObject <MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) BOOL animated;//动画

+ (HUDHelper *)sharedInstance;

- (void)loading;
- (void)loading:(NSString *)msg;
- (void)loading:(NSString *)msg success:(BOOL)success;
- (void)tipMessage:(NSString *)msg;
- (void)tipMessage:(NSString *)msg seconds:(CGFloat)seconds;
- (void)stopLoading;

@end
