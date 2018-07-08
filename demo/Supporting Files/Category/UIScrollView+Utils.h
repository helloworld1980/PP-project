//
//  UIScrollView+Utils.h
//  silu
//
//  Created by liman on 8/7/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Utils)

/**
 *  跳转到指定index
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  获取当前滑动到的index (配合scrollViewDidEndDecelerating:)
 *
 */
- (NSInteger)currentScrolledIndex;

@end
