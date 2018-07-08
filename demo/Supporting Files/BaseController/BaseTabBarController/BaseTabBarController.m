//
//  BaseTabBarController.m
//  CustomTabbar
//
//  Created by liman on 14/11/9.
//  Copyright (c) 2014年 lh. All rights reserved.
//

#define kColorNormal        [UIColor whiteColor]
#define kColorHighlight     [UIColor redColor]

#import "BaseTabBarController.h"
#import "Test1_VC.h"
#import "Test2_VC.h"
#import "Test3_VC.h"
#import "Test4_VC.h"
#import "Test5_VC.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化子控制器
    [self initViewControllers];
    
    // 初始化item的显示数据数组(图片&标题)
    [self initImagesArrTitlesArr];
    
    // 自定义tabbar
    [self initTabBar];
}

#pragma mark - private methods
// 初始化子控制器
- (void)initViewControllers
{
    BaseNavigationController *navi1 = [[BaseNavigationController alloc] initWithRootViewController:[Test1_VC new]];
    BaseNavigationController *navi2 = [[BaseNavigationController alloc] initWithRootViewController:[Test2_VC new]];
    BaseNavigationController *navi3 = [[BaseNavigationController alloc] initWithRootViewController:[Test3_VC new]];
    BaseNavigationController *navi4 = [[BaseNavigationController alloc] initWithRootViewController:[Test4_VC new]];
    BaseNavigationController *navi5 = [[BaseNavigationController alloc] initWithRootViewController:[Test5_VC new]];
    
    self.viewControllers = @[navi1,
                             navi2,
                             navi3,
                             navi4,
                             navi5,
                             ];
}

// 初始化item的显示数据数组(图片&标题)
- (void)initImagesArrTitlesArr
{
    // 普通背景图片
    _normalImages = @[@"tabbar_home.png",
                      @"tabbar_message_center.png",
                      @"tabbar_profile.png",
                      @"tabbar_discover.png",
                      @"tabbar_more.png",
                      ];
    // 高亮背景图片
    _highlightImages = @[@"tabbar_home_highlighted.png",
                         @"tabbar_message_center_highlighted.png",
                         @"tabbar_profile_highlighted.png",
                         @"tabbar_discover_highlighted.png",
                         @"tabbar_more_highlighted.png",
                         ];
    // item标题
    _titles = @[@"1",
                @"2",
                @"3",
                @"4",
                @"5",
                ];
}

// 自定义tabbar
- (void)initTabBar
{
    _tabBarView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    _tabBarView.backgroundColor = [UIColor blackColor];
    [self.tabBar addSubview:_tabBarView];
    
    
    // 添加3个自定义的items
    for (int i = 0; i < self.viewControllers.count; i ++) {
    
        _tabbarItemView = [[TabBarItemView alloc] initWithFrame:CGRectMake(i * (self.view.width / [self.viewControllers count]), 0, self.view.width / [self.viewControllers count], 49)];
        _tabbarItemView.tag = i;
        _tabbarItemView.delegate = self;
        _tabbarItemView.imageView.image = [UIImage imageNamed:_normalImages[i]];
        _tabbarItemView.titleLabel.text = _titles[i];
        [_tabBarView addSubview:_tabbarItemView];
    }

    // 设置第一个item为"选中"状态
    UIView *firstSubview = _tabBarView.subviews[0];
    if ([firstSubview isKindOfClass:[TabBarItemView class]]) {
        TabBarItemView *firstItemView = (TabBarItemView *)firstSubview;
        firstItemView.imageView.image = [UIImage imageNamed:_highlightImages[0]];
        firstItemView.titleLabel.textColor = kColorHighlight;
    }
}

#pragma mark - TabBarItemViewDelegate
- (void)tabbarItemView:(TabBarItemView *)itemView didSelectedIndex:(NSUInteger)index
{
    // 核心代码
    self.selectedIndex = index;
    
    // 点击item后, 还原其他所有item的图片&标题颜色
    int i = 0;
    for (TabBarItemView *subView in _tabBarView.subviews) {
        subView.imageView.image = [UIImage imageNamed:_normalImages[i]];
        subView.titleLabel.textColor = kColorNormal;
        i ++;
    }
    
    // 点击item后, 改变选中的item的图片&标题颜色
    itemView.titleLabel.textColor = kColorHighlight;
    itemView.imageView.image = [UIImage imageNamed:_highlightImages[index]];
}

@end
