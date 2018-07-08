//
//  BaseSettingCell.m
//  SettingPage框架
//
//  Created by liman on 15/11/17.
//  Copyright © 2015年 liman. All rights reserved.
//

#import "BaseSettingCell.h"
#import "UIViewExt.h"

@implementation BaseSettingCell

#pragma mark - init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // UISwitch控件
        [self initSwitchView];
    }
    
    return self;
}

#pragma mark - private
// UISwitch控件
- (void)initSwitchView
{
    _switchView = [UISwitch new];
    [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. self.textLabel强制居中
    if (_item.center)
    {
        self.textLabel.left = (self.width - self.textLabel.width) / 2;
    }
    
    // 2. UISwitch控件
    switch (_item.switchType)
    {
        case 0: /**< 不显示switch */
        {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.accessoryView = nil;
        }
            break;
            
        case 1: /**< 打开switch */
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryView = _switchView;
            _switchView.on = YES;
        }
            break;
            
        case 2: /**< 关闭switch */
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.accessoryView = _switchView;
            _switchView.on = NO;
        }
            break;
            
        default:
            break;
    }
    
    // 3. 其他
    self.textLabel.text = _item.title;
    self.detailTextLabel.text = _item.subTitle;
    self.imageView.image = _item.image;
    self.accessoryType = _item.accessoryType;
    
    
    self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
}

#pragma mark - target action
- (void)switchChanged:(UISwitch *)switchView
{
    if (switchView.on)
    {
        _item.switchType = SwitchTypeOn;
    }
    else
    {
        _item.switchType = SwitchTypeOff;
    }
    
    // 代理
    if ([_delegate respondsToSelector:@selector(baseSettingCell:switchChanged:)]) {
        [_delegate baseSettingCell:self switchChanged:switchView];
    }
}

@end
