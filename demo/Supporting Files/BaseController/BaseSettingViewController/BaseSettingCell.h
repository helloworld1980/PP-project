//
//  BaseSettingCell.h
//  SettingPage框架
//
//  Created by liman on 15/11/17.
//  Copyright © 2015年 liman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@class BaseSettingCell;
@protocol BaseSettingCellDelegate <NSObject>
@optional
/**
 *  监控UISwitch控件值的改变
 */
- (void)baseSettingCell:(BaseSettingCell *)cell switchChanged:(UISwitch *)switchView;

@end

@interface BaseSettingCell : UITableViewCell

// 模型
@property (strong, nonatomic) SettingItem *item;
// UISwitch控件
@property (strong, nonatomic) UISwitch *switchView;
// 代理
@property (weak, nonatomic) id <BaseSettingCellDelegate> delegate;

@end
