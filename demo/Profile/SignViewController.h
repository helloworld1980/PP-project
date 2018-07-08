//
//  SignViewController.h
//  demo
//
//  Created by liman on 3/10/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface SignViewController : BaseViewController <UITextViewDelegate>

//描述view
@property (strong, nonatomic) UIView *contentView;
//描述textView
@property (strong, nonatomic) UITextView *textView;

@end
