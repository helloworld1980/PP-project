//
//  MainTabberItemView.m
//  CustomTabbar
//
//  Created by liman on 14/11/9.
//  Copyright (c) 2014年 lh. All rights reserved.
//

#define kColorNormal        [UIColor whiteColor]
#define kColorHighlight     [UIColor redColor]

#import "TabBarItemView.h"

@interface TabBarItemView ()

@end

@implementation TabBarItemView

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化子视图
        [self initSubviews];
        
    }
    return self;
}

#pragma mark - private methods
// 初始化子视图
- (void)initSubviews
{
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 40, 40)];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
    
    // label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 40, 10)];
    _titleLabel.textColor = kColorNormal;
    _titleLabel.font = [UIFont boldSystemFontOfSize:10];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabbarTapped)];
    [self addGestureRecognizer:tap];
}

#pragma mark - target action
- (void)tabbarTapped
{
    if ([self.delegate respondsToSelector:@selector(tabbarItemView:didSelectedIndex:)]) {
        [self.delegate tabbarItemView:self didSelectedIndex:self.tag];
    }
}

@end
