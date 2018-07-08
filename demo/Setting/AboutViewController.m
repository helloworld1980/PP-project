//
//  AboutViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 14

#import "AboutViewController.h"

@implementation AboutViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于PP充电";
    self.showNaviDismissItem = YES;
    
    [self init_logoImageView];
    [self init_contentLabel];
    
    [self init_companyName];
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
    NSString *string = @"PP充电是宇能共享科技有限公司开发的一款共享电源产品，PP充电致力于使人们生活更加便捷，随时随地电力充沛，实现共享生活。";
    
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

- (void)init_companyName
{
    UIImageView *imageView = [UIImageView new];
    imageView.width = 388/2;
    imageView.height = 46/2;
    imageView.bottom = self.view.bottom - 20;
    imageView.centerX = self.view.centerX;
    [self.view addSubview:imageView];
    
    imageView.image = [UIImage imageNamed:@"company_name"];
}

@end
