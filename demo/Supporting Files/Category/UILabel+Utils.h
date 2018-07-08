//
//  UILabel+Utils.h
//  silu
//
//  Created by liman on 28/4/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

/**
 *  自动调整UILabel高度
 */
- (void)adjustHeight:(NSUInteger)maxLineCount;

/**
 *  自动调整UILabel宽度
 */
- (void)adjustWidth;

/**
 *  计算UILabel行数
 */
- (NSInteger)lineOfLabel;




/**********************************************************************************************/

- (void)alignTop;

- (void)alignBottom;

@end
