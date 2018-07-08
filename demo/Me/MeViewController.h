//
//  MeViewController.h
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "MeHeaderView.h"
#import "ProfileViewController.h"
#import "WalletViewController.h"

@interface MeViewController : BaseSettingViewController <BaseSettingCellDelegate, MeHeaderViewDelegate, ProfileViewControllerDelegate, WalletViewControllerDelegate>

@end
