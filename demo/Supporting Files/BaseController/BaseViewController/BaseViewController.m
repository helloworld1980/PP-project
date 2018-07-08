//
//  BaseViewController.m
//  123
//
//  Created by liman on 15/10/28.
//  Copyright © 2015年 liman. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

/**
 *  导航栏label
 */
@property (strong, nonatomic) UILabel *naviBarTitleLabel;

/**
 *  返回btn
 */
@property (strong, nonatomic) UIButton *dismissBtn;

@end

@implementation BaseViewController

#pragma mark - public
/**
 *  自定义导航栏item
 */
- (void)customNaviItemWithTitle:(NSString *)title titleFont:(UIFont *)titleFont normalTitleColor:(UIColor *)normalTitleColor highlightTitleColor:(UIColor *)highlightTitleColor normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage action:(SEL)action frame:(CGRect)frame tag:(NSString *)tag
{
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = frame;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:btn];
    
    // 扩大点击区域
    [btn setEnlargeEdge:30];
    
    
    //1.文字
    if (title) {
        [btn setTitle:title forState:0];
    }
    if (titleFont) {
        btn.titleLabel.font = titleFont;
    }
    if (normalTitleColor) {
        [btn setTitleColor:normalTitleColor forState:0];
    }
    if (highlightTitleColor) {
        [btn setTitleColor:highlightTitleColor forState:1];
    }
    
    //2.图片
    if (normalImage) {
        [btn setBackgroundImage:normalImage forState:0];
    }
    if (highlightImage) {
        [btn setBackgroundImage:highlightImage forState:1];
    }
    
    //3.tag
    if (tag) {
        btn.tag = [tag integerValue];
    }
}

#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    _naviBarTitleLabel.text = title;
}

/**
 *  是否隐藏"导航栏" (默认显示)
 */
- (void)setHideNaviBarView:(BOOL)hideNaviBarView
{
    if (hideNaviBarView) {
        _naviBarView.hidden = YES;
    } else {
        _naviBarView.hidden = NO;
    }
}

/**
 *  是否显示"导航栏返回按钮" (默认隐藏)
 */
- (void)setShowNaviDismissItem:(BOOL)showNaviDismissItem
{
    if (showNaviDismissItem) {
        _dismissBtn.hidden = NO;
    } else {
        _dismissBtn.hidden = YES;
    }
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController setNavigationBarHidden:NO];       // 使导航条有效
    [self.navigationController.navigationBar setHidden:YES];     // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
    
    // 导航栏view
    [self initNaviBarView];
    // 导航栏label
    [self initNaviBarTitleLabel];
    // 返回btn
    [self initDismissBtn];
}

- (void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
// 导航栏view
- (void)initNaviBarView
{
    _naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, k_NaviH)];
    [self.view addSubview:_naviBarView];
    
    _naviBarView.backgroundColor = k_MainColor;
}

// 导航栏label
- (void)initNaviBarTitleLabel
{
    _naviBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, k_NaviH - 20)];
    _naviBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    _naviBarTitleLabel.textColor = [UIColor whiteColor];
    [_naviBarView addSubview:_naviBarTitleLabel];
}

// 返回btn
- (void)initDismissBtn
{
    _dismissBtn = [UIButton buttonWithType:0];
    _dismissBtn.frame = CGRectMake(14, 32, 11, 20);
    [_dismissBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:0];
    [_dismissBtn setBackgroundImage:[UIImage imageNamed:@"return_hl"] forState:1];
    [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:_dismissBtn];
    
    // 扩大点击区域
    [_dismissBtn setEnlargeEdge:30];
    
    //默认隐藏
    _dismissBtn.hidden = YES;
}

#pragma mark - target action
// 返回btn
- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
