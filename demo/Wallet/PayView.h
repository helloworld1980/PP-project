//
//  WechatView.h
//  demo
//
//  Created by liman on 3/13/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayStyle_wechat = 0, /**< 微信 */
    PayStyle_alipay = 1, /**< 支付宝 */
} PayStyle;//支付类型

@class PayView;
@protocol PayViewDelegate <NSObject>

//点击了PayView
- (void)payViewDidSelected:(PayView *)payView;

@end

@interface PayView : UIView

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIImageView *selectImageView;

//支付类型
@property (assign, nonatomic) PayStyle payStyle;

//是否选择
@property (assign, nonatomic) BOOL selected;

//判断是否选择
- (void)judgeIfSelected;

//初始化
- (instancetype)initWithFrame:(CGRect)frame payStyle:(PayStyle)payStyle selected:(BOOL)selected;

@property (weak, nonatomic) id<PayViewDelegate> delegate;
@end
