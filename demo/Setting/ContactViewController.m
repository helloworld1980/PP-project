//
//  AboutViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 14

#import "ContactViewController.h"

@implementation ContactViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"联系我们";
    self.showNaviDismissItem = YES;
    
    [self init_logoImageView];
    [self init_contentLabel];
}

#pragma mark - private
- (void)init_logoImageView
{
    _logoImageView = [UIImageView new];
    _logoImageView.width = 174/2.5;
    _logoImageView.height = 218/2.5;
    _logoImageView.top = k_NaviH + 20;
    _logoImageView.centerX = self.view.centerX;
    [self.view addSubview:_logoImageView];
    
    _logoImageView.image = [UIImage imageNamed:@"pp_logo"];
}

- (void)init_contentLabel
{
    NSString *string = @"如果您在使用中遇到问题，可以直接通过app首页右下角的“故障上报”功能，上报故障问题给我们。或者，您也可以在一下时间段通过以下渠道将问题反馈给我们。\n\nPP充电感谢的您的理解和支持。\n\n工作时间：09:00-22:00\n联系电话：0755-86666666\n官方邮箱：service@ppcharge.com\n官方网站：www.ppcharge.com";
    
    _contentLabel = [UILabel new];
    _contentLabel.width = SCREEN_WIDTH - 2*kGap;
    _contentLabel.left = kGap;
    _contentLabel.top = _logoImageView.bottom + 20;
    [self.view addSubview:_contentLabel];
    
    _contentLabel.text = string;
    _contentLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    [_contentLabel adjustHeight:0];
}

@end
