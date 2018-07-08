//
//  UIImageView+Utils.m
//  silu
//
//  Created by liman on 2/6/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

/**
 *  关于UIImageView的显示问题——居中显示或者截取图片的中间部分显示
 */
- (void)scaleImage
{
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.contentMode =  UIViewContentModeScaleAspectFill;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds  = YES;
}

/**
 *  旋转
 */
+ (void)rotate360DegreeWithImageView:(UIImageView *)imageView seconds:(CGFloat)seconds;
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
    
    
    
    GCD_DELAY_AFTER(seconds, ^{
        [imageView.layer removeAllAnimations];
    });
}

@end
