//
//  WechatView.m
//  demo
//
//  Created by liman on 3/13/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "PayView.h"

@implementation PayView

#pragma mark - public
//初始化
- (instancetype)initWithFrame:(CGRect)frame payStyle:(PayStyle)payStyle selected:(BOOL)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)]];
        
        _payStyle = payStyle;
        _selected = selected;
        
        [self _logoImageView];
        [self _selectImageView];
        
        //判断是否选择
        [self judgeIfSelected];
        
        
        //适配
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
            _logoImageView.width = 126;
            _logoImageView.height = 40;
            
            _selectImageView.height = 20;
            _selectImageView.width = _selectImageView.height;
            _selectImageView.left = _logoImageView.right + 16;
            _selectImageView.centerY = _logoImageView.centerY + 1;
        }
    }
    return self;
}

//判断是否选择
- (void)judgeIfSelected
{
    if (_selected)
    {
        //选择
        _selectImageView.image = [UIImage imageNamed:@"pay_selected"];
    }
    else
    {
        //未选择
        _selectImageView.image = [UIImage imageNamed:@"pay_noselect"];
    }
}

#pragma mark - private
- (void)_logoImageView
{
    _logoImageView = [UIImageView new];
    _logoImageView.left = 0;
    _logoImageView.top = 0;
    _logoImageView.height = self.height;
    _logoImageView.width = 308/2;
    [self addSubview:_logoImageView];
    
    if (_payStyle == PayStyle_wechat) {//微信
        _logoImageView.image = [UIImage imageNamed:@"wechat111"];
    }
    if (_payStyle == PayStyle_alipay) {//支付宝
        _logoImageView.image = [UIImage imageNamed:@"alipay111"];
    }
}

- (void)_selectImageView
{
    _selectImageView = [UIImageView new];
    _selectImageView.height = 46/2;
    _selectImageView.width = _selectImageView.height;
    _selectImageView.left = _logoImageView.right + 20;
    _selectImageView.centerY = _logoImageView.centerY + 1;
    [self addSubview:_selectImageView];
}

#pragma mark - target action
- (void)tapSelf
{
    if ([_delegate respondsToSelector:@selector(payViewDidSelected:)]) {
        [_delegate payViewDidSelected:self];
    }
    
    
    _selected = YES;
    
    //判断是否选择
    [self judgeIfSelected];
}

@end
