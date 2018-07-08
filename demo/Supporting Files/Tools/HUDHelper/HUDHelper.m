//
//  HUDHelper.m
//  HUD_demo
//
//  Created by liman on 9/5/16.
//  Copyright © 2016 liman. All rights reserved.
//

#define kDelayTime 1

#import "HUDHelper.h"

@implementation HUDHelper

#pragma mark - public
+ (HUDHelper *)sharedInstance
{
    static HUDHelper *sharedInstace = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    
    sharedInstace.animated = YES;
    
    return sharedInstace;
}

- (void)loading
{
    [self setupHUD];
}

- (void)loading:(NSString *)msg
{
    [self setupHUD];
    
    _hud.label.text = msg;
    _hud.square = YES;
}

- (void)loading:(NSString *)msg success:(BOOL)success
{
    [self setupHUD];
    
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.label.text = msg;
    _hud.square = YES;
    
    if (success) {
        _hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }else{
        _hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
}

- (void)tipMessage:(NSString *)msg
{
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    
    
    [self setupHUD];
    
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabel.text = msg;
    _hud.detailsLabel.font = _hud.label.font;
    
    [_hud hideAnimated:_animated afterDelay:kDelayTime];
}

- (void)tipMessage:(NSString *)msg seconds:(CGFloat)seconds
{
    if (_hud) {
        [_hud hideAnimated:NO];
    }
    
    
    [self setupHUD];
    
    _hud.mode = MBProgressHUDModeText;
    _hud.detailsLabel.text = msg;
    _hud.detailsLabel.font = _hud.label.font;
    
    [_hud hideAnimated:_animated afterDelay:seconds];
}

- (void)stopLoading
{
    [_hud hideAnimated:_animated];
}

#pragma mark - tool
- (void)setupHUD
{
    if (!_hud)
    {
        _hud = [MBProgressHUD showHUDAddedTo:k_UIApplication.keyWindow animated:_animated];
        _hud.contentColor = [UIColor whiteColor];
        _hud.bezelView.color = [UIColor blackColor];
        _hud.delegate = self;
    }
    else
    {
        _hud.mode = MBProgressHUDModeIndeterminate; //default
        _hud.label.text = nil;
        _hud.detailsLabel.text = nil;
        _hud.customView = nil;
        _hud.square = NO;
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_hud removeFromSuperview];
    _hud = nil;
}

@end
