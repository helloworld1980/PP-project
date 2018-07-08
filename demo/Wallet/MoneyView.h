//
//  PayView.h
//  demo
//
//  Created by liman on 3/12/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoneyView;
@protocol MoneyViewDelegate <NSObject>

//点击了MoneyView
- (void)moneyViewDidSelected:(MoneyView *)moneyView;

@end

@interface MoneyView : UIView

//充值金额
@property (strong, nonatomic) NSString *money;
//是否选择
@property (assign, nonatomic) BOOL selected;

//充值金额label
@property (strong, nonatomic) UILabel *moneyLabel;

//判断是否选择
- (void)judgeIfSelected;

//初始化
- (instancetype)initWithFrame:(CGRect)frame money:(NSString *)money selected:(BOOL)selected;

@property (weak, nonatomic) id<MoneyViewDelegate> delegate;
@end