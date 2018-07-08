//
//  MeHeaderView.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeHeaderView;
@protocol MeHeaderViewDelegate <NSObject>

//点击了头像
- (void)headerView:(MeHeaderView *)headerView didSelectedAvatarImageView:(UIImageView *)avatarImageView;
//点击了余额
- (void)headerView:(MeHeaderView *)headerView didSelectedBalanceLabel:(UILabel *)balanceLabel;
//点击了信用
- (void)headerView:(MeHeaderView *)headerView didSelectedCreditLabel:(UILabel *)creditLabel;

@end

@interface MeHeaderView : UIView

//背景imageview
@property (strong, nonatomic) UIImageView *bgImageView;

//底部view
@property (strong, nonatomic) UIView *bottomView;

//头像imageView
@property (strong, nonatomic) UIImageView *avatarImageView;
//昵称label
@property (strong, nonatomic) UILabel *nicknameLabel;
//line imageview
@property (strong, nonatomic) UIImageView *lineImageView;
//余额label
@property (strong, nonatomic) UILabel *balanceLabel;
//信用label
@property (strong, nonatomic) UILabel *creditLabel;

- (instancetype)initWithHeight:(CGFloat)height;

@property (weak, nonatomic) id<MeHeaderViewDelegate> delegate;
@end
