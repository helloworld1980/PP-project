//
//  UIWebView+Utils.m
//  wqewqe
//
//  Created by liman on 15/10/28.
//  Copyright © 2015年 liman. All rights reserved.
//

#import "UIWebView+Utils.h"

@implementation UIWebView (Utils)

/**
 *  加载本地html文件
 */
- (void)loadHTML_fileName:(NSString *)fileName inDirectory:(NSString *)bundlePath
{
    // 第一种方法
//    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:bundlePath];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    [self loadHTMLString:html baseURL:nil];
//
    // 第二种方法
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:bundlePath];
    NSURL *url =[NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
    
    // 第三种方法
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:bundlePath];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self loadHTMLString:html baseURL:baseURL];
}



/**
 *  加载本地html文件
 */
- (void)loadHTML_fileName2:(NSString *)fileName inDirectory:(NSString *)bundlePath
{
    // 第一种方法
    //    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    //    NSData *data = [NSData dataWithContentsOfFile:path];
    //    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    [self loadHTMLString:html baseURL:nil];
    
    // 第二种方法
    //    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:bundlePath];
    NSString *path = [[SANDBOX_DOCUMENT_PATH stringByAppendingPathComponent:bundlePath] stringByAppendingPathComponent:fileName];
    NSURL *url =[NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
    
    // 第三种方法
    //    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:@"web"];
    //    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //    [self loadHTMLString:html baseURL:baseURL];
}

@end
