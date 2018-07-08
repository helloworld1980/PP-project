//
//  FeedbackViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController <UITextViewDelegate>

//描述view
@property (strong, nonatomic) UIView *contentView;
//描述textView
@property (strong, nonatomic) UITextView *textView;

//提交按钮
@property (strong, nonatomic) UIButton *submitBtn;


@end
