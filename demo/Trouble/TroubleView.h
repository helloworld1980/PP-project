//
//  TroubleView.h
//  demo
//
//  Created by liman on 3/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TroubleView;
@protocol TroubleViewDelegate <NSObject>

- (void)troubleView:(TroubleView *)troubleView typeTitle:(NSString *)typeTitle selected:(BOOL)selected;

@end

@interface TroubleView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *selectImageView;

//是否选择
@property (assign, nonatomic) BOOL selected;

//判断是否选择
- (void)judgeIfSelected;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property (weak, nonatomic) id<TroubleViewDelegate> delegate;

@end
