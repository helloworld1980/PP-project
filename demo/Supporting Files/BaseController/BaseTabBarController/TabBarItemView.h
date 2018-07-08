//
//  MainTabberItemView.h
//  CustomTabbar
//
//  Created by liman on 14/11/9.
//  Copyright (c) 2014年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarItemView;
@protocol TabBarItemViewDelegate <NSObject>

- (void)tabbarItemView:(TabBarItemView *)itemView didSelectedIndex:(NSUInteger)index;

@end

@interface TabBarItemView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (weak, nonatomic) id <TabBarItemViewDelegate> delegate;

@end
