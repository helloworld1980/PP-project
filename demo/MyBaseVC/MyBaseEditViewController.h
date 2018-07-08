//
//  BaseEditViewController.h
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@class MyBaseEditViewController;
@protocol MyBaseEditViewControllerDelegate <NSObject>

//修改后的值
- (void)myBaseEditViewController:(MyBaseEditViewController *)myBaseEditViewController title:(NSString *)title newValue:(NSString *)newValue;

@end

@interface MyBaseEditViewController : BaseViewController

//描述view
@property (strong, nonatomic) UIView *contentView;

//textField
@property (strong, nonatomic) UITextField *textField;

- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;

@property (weak, nonatomic) id<MyBaseEditViewControllerDelegate> delegate;
@end
