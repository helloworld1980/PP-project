//
//  MessageDetailViewController.m
//  demo
//
//  Created by liman on 3/16/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "MessageDetailViewController.h"

@implementation MessageDetailViewController
{
    MessageObject *_messageObject;
}

#pragma mark - public
- (instancetype)initWithMessageObject:(MessageObject *)messageObject
{
    self = [super init];
    if (self) {
        _messageObject = messageObject;
    }
    return self;
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNaviDismissItem = YES;
    self.title = @"消息详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    //背景view
    [self _bgView];
    
    //时间label
    [self _timeLabel];
    
    //内容label
    [self _contentLabel];
    
    _bgView.height = _timeLabel.height + _contentLabel.height + 3*kGap;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_delegate respondsToSelector:@selector(messageDetailViewController:didReadMessage:)]) {
        [_delegate messageDetailViewController:self didReadMessage:_messageObject];
    }
}

#pragma mark - private
//背景view
- (void)_bgView
{
    _bgView = [UIView new];
    _bgView.width = SCREEN_WIDTH;
    _bgView.top = k_NaviH + kGap;
    _bgView.left = 0;
    [self.view addSubview:_bgView];
    
    _bgView.backgroundColor = [UIColor whiteColor];
}

//时间label
- (void)_timeLabel
{
    _timeLabel = [UILabel new];
    _timeLabel.width = _bgView.width - 2*kGap;
    _timeLabel.left = kGap;
    _timeLabel.top = kGap;
    [_bgView addSubview:_timeLabel];
    
    _timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.text = _messageObject.createDt;
    [_timeLabel adjustHeight:0];
}

//内容label
- (void)_contentLabel
{
    _contentLabel = [UILabel new];
    _contentLabel.frame = _timeLabel.frame;
    _contentLabel.top = _timeLabel.bottom + kGap;
    [_bgView addSubview:_contentLabel];
    
    _contentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.text = _messageObject.content;
    [_contentLabel adjustHeight:0];
}

@end
