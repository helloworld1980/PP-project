//
//  BaseTabBarController.h
//  CustomTabbar
//
//  Created by liman on 14/11/9.
//  Copyright (c) 2014年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItemView.h"

@interface BaseTabBarController : UITabBarController <TabBarItemViewDelegate>

// 自定义的tabber视图
@property (strong, nonatomic) UIView *tabBarView;

// 自定义的tabbarItem视图
@property (strong, nonatomic) TabBarItemView *tabbarItemView;

// item的显示数据数组(图片&标题)
@property (strong, nonatomic) NSArray *normalImages; //普通背景图片
@property (strong, nonatomic) NSArray *highlightImages; //高亮背景图片
@property (strong, nonatomic) NSArray *titles; // item标题

@end

/*********************************** push隐藏tabbar **********************************/

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
 */
