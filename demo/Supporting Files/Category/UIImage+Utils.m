//
//  UIImage+Utils.m
//  demo
//
//  Created by liman on 3/20/17.
//  Copyright © 2017 apple. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

-(CGSize)sizeFromImage:(UIImage *)image{
    
    CGSize size = image.size;
    
    CGFloat wh =MIN(size.width, size.height);
    
    return CGSizeMake(wh, wh);
}

/**
 *  加圆角
 */
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius
{
    //http://stackoverflow.com/questions/10563986/uiimage-with-rounded-corners
    
    
    
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [self drawInRect:frame];
    
    // Get the image, here setting the UIImageView image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

@end
