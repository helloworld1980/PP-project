//
//  FriendViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface InviteFriendViewController : BaseViewController

//背景imageView
@property (strong, nonatomic) UIImageView *backgroudImageView;

//描述label
@property (strong, nonatomic) UILabel *label;

//邀请imageview
@property (strong, nonatomic) UIImageView *inviteImageView;

//邀请码label
@property (strong, nonatomic) TCCopyableLabel *codeLabel;

//分享按钮
@property (strong, nonatomic) UIButton *shareBtn1;
@property (strong, nonatomic) UIButton *shareBtn2;
@property (strong, nonatomic) UIButton *shareBtn3;
@property (strong, nonatomic) UIButton *shareBtn4;

//分享label
@property (strong, nonatomic) UILabel *sharelabel1;
@property (strong, nonatomic) UILabel *sharelabel2;
@property (strong, nonatomic) UILabel *sharelabel3;
@property (strong, nonatomic) UILabel *sharelabel4;

@end
