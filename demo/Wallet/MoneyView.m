//
//  PayView.m
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MoneyView.h"

@implementation MoneyView

#pragma mark - public
//初始化
- (instancetype)initWithFrame:(CGRect)frame money:(NSString *)money selected:(BOOL)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _money = money;
        _selected = selected;
        
        //充值金额label
        [self _moneyLabel];
        
        //判断是否选择
        [self judgeIfSelected];
    }
    return self;
}

//判断是否选择
- (void)judgeIfSelected
{
    if (_selected)
    {
        //选择
        self.backgroundColor = k_MainColor;
        _moneyLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        //未选择
        self.backgroundColor = [UIColor whiteColor];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}

#pragma mark - private
//充值金额label
- (void)_moneyLabel
{
    _moneyLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_moneyLabel];
    
    _moneyLabel.font = [UIFont systemFontOfSize:16];
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.text = [NSString stringWithFormat:@"%@ 元", _money];
    _moneyLabel.userInteractionEnabled = YES;
    [_moneyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_moneyLabelTap:)]];
}

#pragma mark - target action
- (void)_moneyLabelTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(moneyViewDidSelected:)]) {
        [_delegate moneyViewDidSelected:self];
    }
    
    
    _selected = YES;
    
    //判断是否选择
    [self judgeIfSelected];
}

@end
