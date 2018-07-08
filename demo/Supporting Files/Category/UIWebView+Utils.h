//
//  UIWebView+Utils.h
//  wqewqe
//
//  Created by liman on 15/10/28.
//  Copyright © 2015年 liman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Utils)

/**
 *  加载本地html文件
 */
- (void)loadHTML_fileName:(NSString *)fileName inDirectory:(NSString *)bundlePath;

/**
 *  加载本地html文件
 */
- (void)loadHTML_fileName2:(NSString *)fileName inDirectory:(NSString *)bundlePath;

@end
