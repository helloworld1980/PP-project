
//
//  YNInputView.m
//  PPCharge
//
//  Created by liman on 17/1/31.
//  Copyright © 2017年 深圳市宇能共享科技有限公司. All rights reserved.
//

#import "InputTextField.h"

@interface InputTextField()<UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray * labels;

@end

@implementation InputTextField

#pragma mark - getter
-(NSMutableArray*)labels
{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    
    return _labels;
}

#pragma mark - life
-(instancetype)init
{
    if (self = [super init]) {
        
        self.delegate = self;
        
        //显示键盘
        self.keyboardType = UIKeyboardTypeNumberPad;
        //self.inputView.backgroundColor = [UIColor whiteColor];
        
        //设置其tintColor便可显示光标
        self.tintColor = [UIColor clearColor];
        
        self.textColor = [UIColor clearColor];
        
        for (NSInteger i = 0; i < kCount; i++) {
            
            [self.labels addObject:[self returnLabel]];
        }
        
           [k_NSNotificationCenter addObserver:self selector:@selector(change) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [k_NSNotificationCenter removeObserver:self];
}

#pragma mark - private
-(UILabel*)returnLabel
{
    UILabel * label = [[UILabel alloc] init];
    
    label.backgroundColor = [UIColor colorWithHexString:@"#706f75"];
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:20];
    
    label.layer.cornerRadius = 3;
    
    label.layer.masksToBounds = YES;
    
    [self addSubview:label];
    
    return label;
}

#pragma mark - layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.inputAccessoryView.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.frame.size;
    CGFloat distance = 15;
    CGFloat subDistance = 6;
    NSInteger count = self.labels.count;
    
    CGFloat width = (size.width-2*distance-subDistance*(count-1))/count;
    
    for (NSInteger i = 0; i<count; i++) {
        
        UILabel * label = self.labels[i];
        label.frame = CGRectMake(distance+(width+subDistance)*i, 0, width, size.height);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark - notification
-(void)change
{
    if (self.text.length>0 ) {
        
        NSInteger count = self.labels.count;
        
        NSInteger length = self.text.length;
        
        for (NSUInteger i = 0; i<count; i++) {
            
            NSString * temp = @"";
            
            UILabel * label = self.labels[i];
            
            if (i<length) {
                
                temp = [self.text substringWithRange:NSMakeRange(i, 1)];
            }
            
            label.text = temp;
        }
        
    } else {
        
        NSInteger count = self.labels.count;
        
        for (NSUInteger i = 0; i<count; i++) {
            
            NSString * temp = @"";
            UILabel * label = self.labels[i];
            label.text = temp;
        }
    }
    
    
    
    if (self.text.length > kCount) {
        
        NSString * temp = [self.text substringWithRange:NSMakeRange(0, kCount)];
        self.text = temp;
        
    }
}

@end
