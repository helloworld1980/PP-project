//
//  MeHeaderView.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MeHeaderView.h"

@implementation MeHeaderView

#pragma mark - tool
//赋值
- (void)setValues
{
    //头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UserObject sharedInstance].photoUrl] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    
    //昵称
    _nicknameLabel.text = [UserObject sharedInstance].loginName;
    if (!_nicknameLabel.text || [_nicknameLabel.text isEmpty]) {
        _nicknameLabel.text = [UserObject sharedInstance].realName;
    }
    if (!_nicknameLabel.text || [_nicknameLabel.text isEmpty]) {
        _nicknameLabel.text = [UserObject sharedInstance].phone;
    }
    
    //余额
    _balanceLabel.text = [NSString stringWithFormat:@"余额%@元", [NSString stringWithFormat:@"%.1f", [BalanceObject sharedInstance].balance.floatValue]];
    
    //信用
    _creditLabel.text = [NSString stringWithFormat:@"信用%@分", [BalanceObject sharedInstance].credit];
}

#pragma mark - public
- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.height = height;
        self.width = SCREEN_WIDTH;
        
        self.backgroundColor = k_MainColor;
        
        //背景imageview
        [self init_bgImageView];
        
        //底部view
        [self init_bottomView];
        //头像imageView
        [self init_avatarImageView];
        //昵称label
        [self init_nicknameLabel];
        //line imageview
        [self init_lineImageView];
        //余额label
        [self init_balanceLabel];
        //信用label
        [self init_creditLabel];
        
        //赋值
        [self setValues];
        
    }
    return self;
}


#pragma mark - private
//背景imageview
- (void)init_bgImageView
{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bgImageView];
    
    _bgImageView.backgroundColor = k_MainColor;
}

//底部view
- (void)init_bottomView
{
    _bottomView = [UIView new];
    _bottomView.width = self.width;
    _bottomView.height = 12;
    _bottomView.top = self.height - _bottomView.height;
    _bottomView.left = 0;
    [self addSubview:_bottomView];
    
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
}

//头像imageView
- (void)init_avatarImageView
{
    //适配
    CGFloat xxx = 0;
    if (IS_IPHONE_6) {
        xxx = 12;
    }
    if (IS_IPHONE_6P) {
        xxx = 22;
    }
    
    
    _avatarImageView = [UIImageView new];
    _avatarImageView.width = self.width / 3 - xxx;
    _avatarImageView.height = _avatarImageView.width;
    _avatarImageView.centerX = self.centerX;
    _avatarImageView.top = ((self.height + k_NaviH - _bottomView.height) - _avatarImageView.height)/2 - k_NaviH;
    [self addSubview:_avatarImageView];
    
    _avatarImageView.userInteractionEnabled = YES;
    _avatarImageView.backgroundColor = [UIColor whiteColor];
    [_avatarImageView jk_cornerRadius:_avatarImageView.height/2 strokeSize:3 color:[UIColor colorWithHexString:@"#8ddfb0"]];
    [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_avatarImageViewClick)]];
}

//昵称label
- (void)init_nicknameLabel
{
    _nicknameLabel = [UILabel new];
    _nicknameLabel.top = _avatarImageView.bottom + 12;
    _nicknameLabel.width = self.width;
    _nicknameLabel.height = 20;
    _nicknameLabel.centerX = self.centerX;
    [self addSubview:_nicknameLabel];
    
    _nicknameLabel.userInteractionEnabled = YES;
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    _nicknameLabel.textColor = [UIColor whiteColor];
    _nicknameLabel.font = [UIFont systemFontOfSize:17];
    [_nicknameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_nicknameLabelClick)]];
}

//line imageview
- (void)init_lineImageView
{
    _lineImageView = [UIImageView new];
    _lineImageView.height = 52/2;
    _lineImageView.width = 16/2;
    _lineImageView.centerX = self.centerX;
    _lineImageView.top = _nicknameLabel.bottom + 6;
    [self addSubview:_lineImageView];
    
    _lineImageView.image = [UIImage imageNamed:@"line"];
}

//余额label
- (void)init_balanceLabel
{
    _balanceLabel = [UILabel new];
    _balanceLabel.width = self.width / 2;
    _balanceLabel.height = _lineImageView.height;
    _balanceLabel.right = _lineImageView.left - 10;
    _balanceLabel.top = _lineImageView.top;
    [self addSubview:_balanceLabel];
    
    _balanceLabel.userInteractionEnabled = YES;
    _balanceLabel.textColor = [UIColor whiteColor];
    _balanceLabel.font = [UIFont systemFontOfSize:14];
    _balanceLabel.textAlignment = NSTextAlignmentRight;
    [_balanceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_balanceLabelClick)]];
}

//信用label
- (void)init_creditLabel
{
    _creditLabel = [UILabel new];
    _creditLabel.frame = _balanceLabel.frame;
    _creditLabel.left = _lineImageView.right + 10;
    [self addSubview:_creditLabel];
    
    _creditLabel.userInteractionEnabled = YES;
    _creditLabel.textColor = [UIColor whiteColor];
    _creditLabel.font = [UIFont systemFontOfSize:14];
    [_creditLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_creditLabelClick)]];
}

#pragma mark - target action
//头像
- (void)_avatarImageViewClick
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedAvatarImageView:)]) {
        [_delegate headerView:self didSelectedAvatarImageView:_avatarImageView];
    }
}

//昵称
- (void)_nicknameLabelClick
{
//    if ([_delegate respondsToSelector:@selector(headerView:didSelectedAvatarImageView:)]) {
//        [_delegate headerView:self didSelectedAvatarImageView:_avatarImageView];
//    }
}

//余额
- (void)_balanceLabelClick
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedBalanceLabel:)]) {
        [_delegate headerView:self didSelectedBalanceLabel:_balanceLabel];
    }
}

//信用
- (void)_creditLabelClick
{
    if ([_delegate respondsToSelector:@selector(headerView:didSelectedCreditLabel:)]) {
        [_delegate headerView:self didSelectedCreditLabel:_creditLabel];
    }
}

@end
