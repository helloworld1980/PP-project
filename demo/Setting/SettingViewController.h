//
//  SettingViewController.h
//  demo
//
//  Created by liman on 3/4/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : BaseSettingViewController <BaseSettingCellDelegate>

//退出登录按钮
@property (strong, nonatomic) UIButton *logoutBtn;

//版本label
@property (strong, nonatomic) UILabel *versionLabel;

@end
