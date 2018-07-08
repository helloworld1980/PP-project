//
//  UIScrollView+Utils.m
//  silu
//
//  Created by liman on 8/7/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import "UIScrollView+Utils.h"

@implementation UIScrollView (Utils)

/**
 *  跳转到指定index
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated
{
    CGRect frame = self.frame;
    frame.origin.x = (self.frame.size.width * index);
    
    [self scrollRectToVisible:frame animated:animated];
}

/**
 *  获取当前滑动到的index (配合scrollViewDidEndDecelerating:)
 *
 */
- (NSInteger)currentScrolledIndex
{
    CGFloat pageWidth = self.frame.size.width;
    float fractionalPage = self.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    return page;
}

@end
