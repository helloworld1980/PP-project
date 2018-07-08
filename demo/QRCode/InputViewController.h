//
//  InputViewController.h
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "InputTextField.h"

typedef enum : NSUInteger {
    ScanType_borrow = 0, /**< 扫码借 */
    ScanType_return = 1, /**< 扫码还 */
} ScanType;//扫描类型

@interface InputViewController : BaseViewController

//电池image
@property (strong, nonatomic) UIImageView *batteryImageView;

//输入textField
@property (strong, nonatomic) InputTextField *inputTextField;

//文字label
@property (strong, nonatomic) UILabel *label;

//扫描类型
@property (assign, nonatomic) ScanType scanType;

- (instancetype)initWithBatteryFrame:(CGRect)batteryFrame scanType:(ScanType)scanType;

@end
