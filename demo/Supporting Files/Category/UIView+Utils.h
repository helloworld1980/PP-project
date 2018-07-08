//
//  UIView+Utils.h
//  demo
//
//  Created by liman on 3/3/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth;

@end
