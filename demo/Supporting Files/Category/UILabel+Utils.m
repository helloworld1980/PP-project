//
//  UILabel+Utils.m
//  silu
//
//  Created by liman on 28/4/15.
//  Copyright (c) 2015年 upintech. All rights reserved.
//

#import "UILabel+Utils.h"
#import "NSString+Utils.h"

@implementation UILabel (Utils)

/**
 *  自动调整UILabel高度
 */
- (void)adjustHeight:(NSUInteger)maxLineCount
{
    CGFloat height = 0.0f;
    if (maxLineCount == 0)
    {
        height = [self.text heightWithFont:self.font constraintToWidth:self.frame.size.width];
    }
    else
    {
        NSMutableString *testString = [NSMutableString stringWithString:@"X"];
        for (NSInteger i = 0; i < maxLineCount - 1; i++) {
            [testString appendString:@"\nX"];
        }
        
        CGFloat maxHeight = [testString heightWithFont:self.font constraintToWidth:self.frame.size.width];
        CGFloat textHeight = [self.text heightWithFont:self.font constraintToWidth:self.frame.size.width];
        
        if (maxHeight < textHeight)
        {
            height = maxHeight;
        }
        else
        {
            height = textHeight;
        }
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    self.numberOfLines = maxLineCount;
}

/**
 *  自动调整UILabel宽度
 */
- (void)adjustWidth
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, self.frame.size.height)];
}

/**
 *  计算UILabel行数
 */
- (NSInteger)lineOfLabel
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName : self.font}
                                          context:nil];
    
    return ceil(rect.size.height / self.font.lineHeight);
}




/**********************************************************************************************/

- (void)alignTop
{
    CGSize boundingRectSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName : self.font};
    CGRect labelSize = [self.text boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil];
    int numberOfLines= ceil(labelSize.size.height / self.font.lineHeight);
    
    CGRect newFrame = self.frame;
    newFrame.size.height = numberOfLines * self.font.lineHeight;
    self.frame = newFrame;
}

- (void)alignBottom
{
    CGSize boundingRectSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName : self.font};
    CGRect labelSize = [self.text boundingRectWithSize:boundingRectSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil];
    int numberOfLines= ceil(labelSize.size.height / self.font.lineHeight);
    
    int numberOfNewLined = (self.frame.size.height/self.font.lineHeight) - numberOfLines;
    
    NSMutableString *newLines = [NSMutableString string];
    for(int i=0; i< numberOfNewLined; i++){
        [newLines appendString:@"\n"];
    }
    [newLines appendString:self.text];
    self.text = [newLines mutableCopy];
}

@end
