//
//  MyBaseWebViewController.h
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface MyBaseWebViewController : BaseViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

- (instancetype)initWithTitle:(NSString *)title;

@end
