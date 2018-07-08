//
//  SignViewController.m
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "SignViewController.h"

@implementation SignViewController

#pragma mark - tool
//赋值
- (void)setValues
{
    NSString *str = [UserObject sharedInstance].Description;
    
    if (str && ![str isEmpty]) {
        [_textView jk_addPlaceHolder:@""];
        _textView.text = str;
    }
}

#pragma mark - life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个性签名";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.showNaviDismissItem = YES;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    
    //自定义导航栏item
    [self customNaviItem];
    
    //描述view
    [self init_contentView];
    //描述textView
    [self init_textView];
    
    //赋值
    [self setValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textView becomeFirstResponder];
}

#pragma mark - private
//自定义导航栏item
- (void)customNaviItem
{
    [self customNaviItemWithTitle:@"完成" titleFont:[UIFont systemFontOfSize:16] normalTitleColor:[UIColor whiteColor] highlightTitleColor:nil normalImage:nil highlightImage:nil action:@selector(doneClick) frame:CGRectMake(SCREEN_WIDTH - 46, 33, 40, 20) tag:nil];
}

//描述view
- (void)init_contentView
{
    _contentView = [UIView new];
    _contentView.left = 0;
    _contentView.width = SCREEN_WIDTH;
    _contentView.height = 128;
    _contentView.top = k_NaviH + kGap;
    [self.view addSubview:_contentView];
    
    _contentView.backgroundColor = [UIColor whiteColor];
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
    [_textView jk_addPlaceHolder:@"什么都不写你很特别"];
    _textView.delegate = self;
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
//完成
- (void)doneClick
{
    if ([_textView.text isEmpty] || !_textView.text) {
        [UIAlertView showWithMessage:@"至少写点什么吧"];
        return;
    }
    
    if ([_textView.text length] > 200) {
        [UIAlertView showWithMessage:@"签名限制200个字内"];
        return;
    }
    
    if ([_textView.text isEqualToString:[UserObject sharedInstance].Description]) {
        [UIAlertView showWithMessage:@"请修改后再提交"];
        return;
    }
    
    
    
    
    
    //隐藏键盘
    [self keyboardHidden];
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //20.编辑用户信息
    [[APIService sharedInstance] updateUser:UpdateUserType_sign value:_textView.text success:^(NSString *message){
        
        [[HUDHelper sharedInstance] tipMessage:message];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
