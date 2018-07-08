//
//  BaseViewController.h
//  123
//
//  Created by liman on 15/10/28.
//  Copyright © 2015年 liman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  导航栏view
 */
@property (strong, nonatomic) UIView *naviBarView;

/**
 *  是否隐藏"导航栏" (默认显示)
 */
@property (assign, nonatomic) BOOL hideNaviBarView;

/**
 *  是否显示"导航栏返回按钮" (默认隐藏)
 */
@property (assign, nonatomic) BOOL showNaviDismissItem;


/**
 *  自定义导航栏item
 */
- (void)customNaviItemWithTitle:(NSString *)title titleFont:(UIFont *)titleFont normalTitleColor:(UIColor *)normalTitleColor highlightTitleColor:(UIColor *)highlightTitleColor normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage action:(SEL)action frame:(CGRect)frame tag:(NSString *)tag;

@end
