//
//  FeedbackViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "FeedbackViewController.h"

@implementation FeedbackViewController

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.showNaviDismissItem = YES;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    
    //描述view
    [self init_contentView];
    //描述textView
    [self init_textView];
    
    //提交按钮
    [self init_submitBtn];
}

#pragma mark - private
//描述view
- (void)init_contentView
{
    _contentView = [UIView new];
    _contentView.left = kGap;
    _contentView.width = SCREEN_WIDTH - 2*kGap;
    _contentView.height = 128;
    _contentView.top = k_NaviH + 12;
    [self.view addSubview:_contentView];
    
    [_contentView jk_cornerRadius:0 strokeSize:1 color:[UIColor colorWithHexString:@"#e5e5e5"]];
}

//描述textView
- (void)init_textView
{
    _textView = [UITextView new];
    _textView.width = _contentView.width - 2 * 6;
    _textView.height = _contentView.height;
    _textView.left = 6;
    _textView.top = 0;
    [_contentView addSubview:_textView];
    
    _textView.textColor = [UIColor colorWithHexString:@"#333333"];
    _textView.font = [UIFont systemFontOfSize:14];
    [_textView jk_addPlaceHolder:@"请输入您的宝贵意见, 我们会努力改进"];
    _textView.delegate = self;
}

//提交按钮
- (void)init_submitBtn
{
    _submitBtn = [UIButton buttonWithType:0];
    _submitBtn.width = SCREEN_WIDTH - 4*kGap;
    _submitBtn.height = 44;
    _submitBtn.top = 300;
    _submitBtn.left = 2*kGap;
    [self.view addSubview:_submitBtn];
    
    [_submitBtn jk_cornerRadius:_submitBtn.height/2 strokeSize:0 color:nil];
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:k_MainColor] forState:0];
    [_submitBtn setTitle:@"提交" forState:0];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_submitBtn addTarget:self action:@selector(_submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self keyboardHidden];
        return NO;
    }
    
    return YES;
}

#pragma mark - target action
//提交
- (void)_submitBtnClick
{
    if ([_textView.text isEmpty] || !_textView.text) {
        [UIAlertView showWithMessage:@"至少写点什么吧"];
        return;
    }
    
    
    
    
    //隐藏键盘
    [self keyboardHidden];
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //29.用户反馈
    [[APIService sharedInstance] feedBack:_textView.text success:^(NSString *message) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:@"提交成功, 谢谢!" tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            GCD_DELAY_AFTER(0.35, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

//隐藏键盘
- (void)keyboardHidden
{
    [_textView resignFirstResponder];
}

@end
