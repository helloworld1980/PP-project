//
//  GuideViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MyBaseWebViewController.h"

@implementation MyBaseWebViewController
{
    NSString *_title;
}

#pragma mark - public
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
    }
    return self;
}

#pragma mark - tool
-(void)loadGoogle
{
    // @"http://www.chaoapp.cn/about/license.html"
    // @"http://www.wanmeizhensuo.com/api/terms_of_service/"
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.chaoapp.cn/about/license.html"]];
    [_webView loadRequest:req];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = _title;
    
    //webview
    [self init_webView];
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, k_NaviH, SCREEN_WIDTH, 2.f)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self loadGoogle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}

#pragma mark - private
- (void)init_webView
{
    _webView = [UIWebView new];
    _webView.frame = CGRectMake(0, k_NaviH, SCREEN_WIDTH, SCREEN_HEIGHT - k_NaviH);
    [self.view addSubview:_webView];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    //    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
