//
//  CreditHeaderView.h
//  demo
//
//  Created by liman on 3/11/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditHeaderView : UIView

//背景imageview
@property (strong, nonatomic) UIImageView *bgImageView;

//信用分label
@property (strong, nonatomic) UILabel *scoreLabel;

- (instancetype)initWithHeight:(CGFloat)height score:(NSString *)score;

@end
