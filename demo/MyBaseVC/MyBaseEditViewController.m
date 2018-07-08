//
//  BaseEditViewController.m
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//
#define kGap 12

#import "MyBaseEditViewController.h"
#import "UITextField+PicerView.h"

@implementation MyBaseEditViewController
{
    NSString *_title;
    NSString *_value;
}

#pragma mark - tool
// 计算UpdateUserType
- (UpdateUserType)calculateUpdateUserType
{
    if ([_title isEqualToString:@"昵称"]) {
        return UpdateUserType_name;
    }
    if ([_title isEqualToString:@"性别"]) {
        return UpdateUserType_sex;
    }
    if ([_title isEqualToString:@"年龄"]) {
        return UpdateUserType_age;
    }
    
    return UpdateUserType_sign;//默认
}

#pragma mark - public
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value
{
    self = [super init];
    if (self) {
        
        _title = title;
        _value = value;
        
        if ([title isEqualToString:@"昵称"]) {
            _value = [UserObject sharedInstance].loginName;
        }
    }
    return self;
}

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _title;
    self.showNaviDismissItem = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHidden)]];
    
    
    //自定义导航栏item
    [self customNaviItem];
    
    //描述view
    [self init_contentView];
    
    //textField
    [self init_textField];
    
    
    
    if (![_title isEqualToString:@"性别"]) {
        return;
    }
    
    _textField.clearButtonMode = UITextFieldViewModeNever;
    
    //添加pickerView
    [self addPickerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField becomeFirstResponder];
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
    _contentView.height = 44;
    _contentView.top = k_NaviH + kGap;
    [self.view addSubview:_contentView];
    
    _contentView.backgroundColor = [UIColor whiteColor];
}

//textField
- (void)init_textField
{
    _textField = [UITextField new];
    _textField.frame = _contentView.bounds;
    _textField.left = kGap;
    _textField.width = SCREEN_WIDTH - kGap - 4;
    [_contentView addSubview:_textField];
    
    _textField.text = _value;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.font = [UIFont systemFontOfSize:16];
    [_textField addTarget:self action:@selector(keyboardHidden) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    
    if ([_title isEqualToString:@"年龄"]) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.jk_maxLength = 2;
    }
}

//添加pickerView
-(void)addPickerView
{
    //创建模型
    Core1PickerModel *pickerModel=[Core1PickerModel pickerModel:@[@"男",@"女"]];
    
    //创建pickerView
    Core1PickerView *sexPicerView=[Core1PickerView pickerView:pickerModel];
    
    [_textField add1PickerView:sexPicerView];
}

#pragma mark - target action
//完成
- (void)doneClick
{
    if ([_textField.text isEmpty] || !_textField.text || [_textField.text isEqualToString:_value]) {
        [UIAlertView showWithMessage:@"请修改后再提交"];
        return;
    }
    
    if ([_title isEqualToString:@"年龄"]) {
        if ([_textField.text integerValue] < 1 || [_textField.text integerValue] > 99) {
            [UIAlertView showWithMessage:@"请输入有效的年龄"];
            return;
        }
    }
    
    if ([_title isEqualToString:@"昵称"]) {
        if ([_textField.text length] > 20) {
            [UIAlertView showWithMessage:@"昵称限制20个字内"];
            return;
        }
    }
    
    if ([_title isEqualToString:@"性别"]) {
        if ([_textField.text isEqualToString:@"男"] || [_textField.text isEqualToString:@"女"]) { 
        }else{
            [UIAlertView showWithMessage:@"性别输入不合法"];
            return;
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //隐藏键盘
    [self keyboardHidden];
    
    
    
    
    
    
    [[HUDHelper sharedInstance] loading];
    //20.编辑用户信息
    [[APIService sharedInstance] updateUser:[self calculateUpdateUserType] value:_textField.text success:^(NSString *message){
        
        [[HUDHelper sharedInstance] tipMessage:message];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        //修改后的值
        if ([_delegate respondsToSelector:@selector(myBaseEditViewController:title:newValue:)]) {
            [_delegate myBaseEditViewController:self title:_title newValue:_textField.text];
        }
        
        
    } failure:^(NSString *errorStatus, NSString *errorMsg) {
        
        [[HUDHelper sharedInstance] stopLoading];
        [UIAlertView showWithMessage:errorMsg];
    }];
}

//隐藏键盘
- (void)keyboardHidden
{
    [_textField resignFirstResponder];
}

@end
