//
//  NSString+Password.h
//  03.数据加密
//
//  Created by 刘凡 on 13-12-10.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  32位MD5加密
 */
- (NSString *)MD5;

/**
 *  SHA1加密
 */
- (NSString *)SHA1;

/**
 *  base64加密
 */
- (NSString *)base64Encoding;

/**
 *  base64解密
 */
- (NSString *)base64Decoding;






/***************************************************************************************************************************/

/**
 *  判断是否为nil或者空格(一个或者多个空格)
 */
- (BOOL)isEmpty;

/**
 *  返回非nil字符串
 */
- (NSString *)returnNotNil;

/**
 *  json字符串 ---> json字典
 */
- (NSDictionary *)transferToJsonDict;


/**
 *  计算NSString高度
 */
- (CGFloat)heightWithFont:(UIFont *)font constraintToWidth:(CGFloat)width;

/**
 *  计算UILabel行数
 */
- (NSInteger)lineOfLabelFont:(UIFont *)font labelWidth:(NSInteger)width;




/**
 *  年月日string---->NSDate     "2015-12-11 12:53:35"  (24小时制格式化)
 */
- (NSDate *)dateFromString;

/**
 *  是否是纯数字
 */
- (BOOL)isPureNumandCharacters;

@end
