//
//  CreditHeaderView.m
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "CreditHeaderView.h"

@implementation CreditHeaderView
{
    NSString *_score;
}

#pragma mark - public
- (instancetype)initWithHeight:(CGFloat)height score:(NSString *)score
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        _score = score;
        self.height = height;
        self.width = SCREEN_WIDTH;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#2f93df"];
        
        //背景imageview
        [self init_bgImageView];
        
        //仪表图片
        [self initImageView];
        
        //当前信用分label
        [self initLabel];
        
        //信用分label
        [self init_scoreLabel];
    }
    return self;
}

#pragma mark - private
//背景imageview
- (void)init_bgImageView
{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bgImageView];
    
    _bgImageView.backgroundColor = [UIColor colorWithHexString:@"#2f93df"];
}

//仪表图片
- (void)initImageView
{
    UIImageView *imageView = [UIImageView new];
    imageView.width = 542/2.5;
    imageView.height = 370/2.5;
    imageView.top = 14;
    imageView.centerX = self.centerX;
    [self addSubview:imageView];
    
    imageView.image = [UIImage imageNamed:@"xinyong"];
    
    //适配
    if (IS_IPHONE_6) {
        imageView.width = 542/2.2;
        imageView.height = 370/2.2;
        imageView.top = -2;
        imageView.centerX = self.centerX;
    }
    if (IS_IPHONE_6P) {
        imageView.width = 542/2.2;
        imageView.height = 370/2.2;
        imageView.top = 0;
        imageView.centerX = self.centerX;
    }
}

//当前信用分label
- (void)initLabel
{
    UILabel *label = [UILabel new];
    label.width = SCREEN_WIDTH;
    label.height = 20;
    label.centerX = self.centerX;
    label.bottom = self.bottom - 30;
    [self addSubview:label];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"当前信用分";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.tag = 1001;
}

//信用分label
- (void)init_scoreLabel
{
    UILabel *label = [self viewWithTag:1001];
    
    _scoreLabel = [UILabel new];
    _scoreLabel.frame = label.frame;
    _scoreLabel.height = 30;
    _scoreLabel.bottom = label.top - 10;
    [self addSubview:_scoreLabel];
    
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.text = _score;
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont boldSystemFontOfSize:30];
}

@end
