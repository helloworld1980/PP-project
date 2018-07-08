//
//  TroubleView.m
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "TroubleView.h"

@implementation TroubleView
{
    NSString *_title;
}

#pragma mark - public
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        self.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)]];
        
        [self init_titleLabel];
        [self init_selectImageView];
    }
    return self;
}

//判断是否选择
- (void)judgeIfSelected
{
    if (!_selected)
    {
        _selectImageView.image = [UIImage imageNamed:@"noselect"];
    }
    else
    {
        _selectImageView.image = [UIImage imageNamed:@"selected"];
    }
}

#pragma mark - private
- (void)init_titleLabel
{
    _titleLabel = [UILabel new];
    _titleLabel.height = self.height - 2*kGap;
    _titleLabel.left = kGap;
    _titleLabel.top = kGap;
    [self addSubview:_titleLabel];
    
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.text = _title;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_titleLabel adjustWidth];
}

- (void)init_selectImageView
{
    _selectImageView = [UIImageView new];
    _selectImageView.height = _titleLabel.height;
    _selectImageView.width = _selectImageView.height;
    _selectImageView.top = _titleLabel.top;
    _selectImageView.right = self.width - kGap;
    [self addSubview:_selectImageView];
    
    _selectImageView.image = [UIImage imageNamed:@"noselect"];
}

#pragma mark - target action
- (void)tapSelf
{
//    _selected = !_selected;
//    
//    if (!_selected)
//    {
//        _selectImageView.image = [UIImage imageNamed:@"noselect"];
//    }
//    else
//    {
//        _selectImageView.image = [UIImage imageNamed:@"selected"];
//    }
    
    //代理
    if ([_delegate respondsToSelector:@selector(troubleView:typeTitle:selected:)]) {
        [_delegate troubleView:self typeTitle:_title selected:_selected];
    }
}

@end
