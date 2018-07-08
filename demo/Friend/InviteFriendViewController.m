//
//  FriendViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "MyFriendViewController.h"

@implementation InviteFriendViewController
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams;
}

#pragma mark - tool
//1、创建分享参数（必要）
- (void)shareParams
{
    //http://wiki.mob.com/%E8%87%AA%E5%AE%9A%E4%B9%89%E5%88%86%E4%BA%AB%E5%86%85%E5%AE%B9/
    
    /**
     *  功能介绍：多个社交平台分享内容的不同设置
     
     添加如下代码，分享之后的效果需要去对应的分享平台上观看，首先要构造分享参数，然后再根据每个平台的方法定制自己想要分享的不同的分享内容
     */
    
    //1、创建分享参数（必要）
    shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:[UIImage imageNamed:@"传入的图片名"]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"邀请好友";
    self.view.clipsToBounds = YES;//这个属性必须打开否则返回的时候会出现黑边
    
    //1、创建分享参数（必要）
    [self shareParams];
    
    //自定义导航栏item
    [self customNaviItem];
    
    //背景imageView
    [self init_backgroudImageView];
    
    //描述label
    [self init_label];
    
    //邀请imageview
    [self init_inviteImageView];
    
    //邀请码label
    [self init_codeLabel];
    
    //分享按钮
    [self init_shareBtn];
    
    //分享label
    [self init_shareLabel];
    
    _codeLabel.text = [UserObject sharedInstance].myInviteCode;
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:nil titleFont:nil normalTitleColor:nil highlightTitleColor:nil normalImage:[UIImage imageNamed:@"friendlist"] highlightImage:[UIImage imageNamed:@"friendlist_ant"] action:@selector(friendlistClick) frame:CGRectMake(SCREEN_WIDTH - 25 - 9, 30, 25, 25) tag:nil];
}

//背景imageView
- (void)init_backgroudImageView
{
    //图片
    _backgroudImageView = [UIImageView new];
    _backgroudImageView.width = 750/2;
    _backgroudImageView.height = 409/2;
    _backgroudImageView.centerX = self.view.centerX;
    _backgroudImageView.top = k_NaviH;
    _backgroudImageView.image = [UIImage imageNamed:@"pic1"];
    [self.view addSubview:_backgroudImageView];
}

//描述label
- (void)init_label
{
    _label = [UILabel new];
    _label.left = 20;
    _label.width = SCREEN_WIDTH - 40;
    _label.top = _backgroudImageView.bottom + 20;
    [self.view addSubview:_label];
    
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor colorWithHexString:@"#666666"];
    _label.text = @"每邀请一位好友注册认证并充值押金成功，双方可获得3元奖励";
    [_label adjustHeight:0];
}

//邀请imageview
- (void)init_inviteImageView
{
    _inviteImageView = [UIImageView new];
    _inviteImageView.width = 224/2;
    _inviteImageView.height = 44/2;
    _inviteImageView.centerX = self.view.centerX;
    _inviteImageView.top = _label.bottom + 40;
    [self.view addSubview:_inviteImageView];
    
    _inviteImageView.image = [UIImage imageNamed:@"invite"];
}

//邀请码label
- (void)init_codeLabel
{
    _codeLabel = [TCCopyableLabel new];
    _codeLabel.height = 40;
    _codeLabel.width = SCREEN_WIDTH / 2;
    _codeLabel.centerX = self.view.centerX;
    _codeLabel.top = _inviteImageView.bottom + 14;
    [self.view addSubview:_codeLabel];
    
    [_codeLabel jk_cornerRadius:_codeLabel.height/2 strokeSize:1 color:k_MainColor];
    _codeLabel.textColor = k_MainColor;
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.font = [UIFont systemFontOfSize:15];
}

//分享按钮
- (void)init_shareBtn
{
    _shareBtn1 = [UIButton buttonWithType:0];
    _shareBtn1.width = SCREEN_WIDTH/4;
    _shareBtn1.height = _shareBtn1.width;
    _shareBtn1.left = 0;
    _shareBtn1.bottom = self.view.bottom - 24;
    [_shareBtn1 setImage:[UIImage imageNamed:@"weixin"] forState:0];
    [_shareBtn1 addTarget:self action:@selector(_shareBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn1];
    
    _shareBtn2 = [UIButton buttonWithType:0];
    _shareBtn2.frame = _shareBtn1.frame;
    _shareBtn2.left = _shareBtn1.right;
    [_shareBtn2 setImage:[UIImage imageNamed:@"pengyouquan"] forState:0];
    [_shareBtn2 addTarget:self action:@selector(_shareBtn2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn2];
    
    _shareBtn3 = [UIButton buttonWithType:0];
    _shareBtn3.frame = _shareBtn1.frame;
    _shareBtn3.left = _shareBtn2.right;
    [_shareBtn3 setImage:[UIImage imageNamed:@"qq"] forState:0];
    [_shareBtn3 addTarget:self action:@selector(_shareBtn3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn3];
    
    _shareBtn4 = [UIButton buttonWithType:0];
    _shareBtn4.frame = _shareBtn1.frame;
    _shareBtn4.left = _shareBtn3.right;
    [_shareBtn4 setImage:[UIImage imageNamed:@"qqkone"] forState:0];
    [_shareBtn4 addTarget:self action:@selector(_shareBtn4Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn4];
}

//分享label
- (void)init_shareLabel
{
    _sharelabel1 = [UILabel new];
    _sharelabel1.height = 20;
    _sharelabel1.top = _shareBtn1.bottom - 16;
    _sharelabel1.width = _shareBtn1.width;
    _sharelabel1.centerX = _shareBtn1.centerX;
    _sharelabel1.text = @"微信";
    _sharelabel1.textAlignment = NSTextAlignmentCenter;
    _sharelabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    _sharelabel1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_sharelabel1];
    
    _sharelabel2 = [UILabel new];
    _sharelabel2.frame = _sharelabel1.frame;
    _sharelabel2.left = _sharelabel1.right;
    _sharelabel2.text = @"朋友圈";
    _sharelabel2.textAlignment = NSTextAlignmentCenter;
    _sharelabel2.textColor = [UIColor colorWithHexString:@"#666666"];
    _sharelabel2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_sharelabel2];
    
    _sharelabel3 = [UILabel new];
    _sharelabel3.frame = _sharelabel1.frame;
    _sharelabel3.left = _sharelabel2.right;
    _sharelabel3.text = @"QQ好友";
    _sharelabel3.textAlignment = NSTextAlignmentCenter;
    _sharelabel3.textColor = [UIColor colorWithHexString:@"#666666"];
    _sharelabel3.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_sharelabel3];
    
    _sharelabel4 = [UILabel new];
    _sharelabel4.frame = _sharelabel1.frame;
    _sharelabel4.left = _sharelabel3.right;
    _sharelabel4.text = @"QQ空间";
    _sharelabel4.textAlignment = NSTextAlignmentCenter;
    _sharelabel4.textColor = [UIColor colorWithHexString:@"#666666"];
    _sharelabel4.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_sharelabel4];
}

#pragma mark - target action
//好友列表
- (void)friendlistClick
{
    [self.navigationController pushViewController:[MyFriendViewController new] animated:YES];
}

//微信好友分享
- (void)_shareBtn1Click
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [UIAlertView showWithMessage:@"没有安装微信"];
        return;
    }
    
    
    
    
    [shareParams SSDKSetupWeChatParamsByText:@"我最近在使用PP充电,推荐给你试试,点击下载吧"
                                       title:@"下载PP充电"
                                         url:[NSURL URLWithString:@"https://m.ctrip.com/html5/mkt/centerpage/download/"]
                                  thumbImage:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                       image:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        DLog(toNSString(state));
        DLog(userData);
        DLog(contentEntity);
        DLog(error);
        
        if (state == SSDKResponseStateSuccess) {
            [UIAlertView showWithMessage:@"分享成功"];
        }
    }];
}

//朋友圈分享
- (void)_shareBtn2Click
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [UIAlertView showWithMessage:@"没有安装微信"];
        return;
    }
    
    
    
    [shareParams SSDKSetupWeChatParamsByText:@"我最近在使用PP充电,推荐给你试试,点击下载吧"
                                       title:@"下载PP充电"
                                         url:[NSURL URLWithString:@"https://m.ctrip.com/html5/mkt/centerpage/download/"]
                                  thumbImage:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                       image:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:SSDKContentTypeWebPage
                          forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        DLog(toNSString(state));
        DLog(userData);
        DLog(contentEntity);
        DLog(error);
        
        if (state == SSDKResponseStateSuccess) {
            [UIAlertView showWithMessage:@"分享成功"];
        }
    }];
}

//QQ好友分享
- (void)_shareBtn3Click
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UIAlertView showWithMessage:@"没有安装QQ"];
        return;
    }
    
    
    
    [shareParams SSDKSetupQQParamsByText:@"我最近在使用PP充电,推荐给你试试,点击下载吧"
                                   title:@"下载PP充电"
                                     url:[NSURL URLWithString:@"https://m.ctrip.com/html5/mkt/centerpage/download/"]
                              thumbImage:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                   image:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    [ShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        DLog(toNSString(state));
        DLog(userData);
        DLog(contentEntity);
        DLog(error);
        
        if (state == SSDKResponseStateSuccess) {
            [UIAlertView showWithMessage:@"分享成功"];
        }
    }];
}

//QQ空间分享
- (void)_shareBtn4Click
{
    if (![k_UIApplication canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UIAlertView showWithMessage:@"没有安装QQ"];
        return;
    }
    
    
    
    [shareParams SSDKSetupQQParamsByText:@"我最近在使用PP充电,推荐给你试试,点击下载吧"
                                   title:@"下载PP充电"
                                     url:[NSURL URLWithString:@"https://m.ctrip.com/html5/mkt/centerpage/download/"]
                              thumbImage:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                   image:[[UIImage imageNamed:@"icon1"] imageWithRoundedCornersSize:20]
                                    type:SSDKContentTypeWebPage
                      forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    [ShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        DLog(toNSString(state));
        DLog(userData);
        DLog(contentEntity);
        DLog(error);
        
        if (state == SSDKResponseStateSuccess) {
            [UIAlertView showWithMessage:@"分享成功"];
        }
    }];
}

@end
