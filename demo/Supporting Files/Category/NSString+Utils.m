//
//  NSString+Password.m
//  03.数据加密
//
//  Created by 刘凡 on 13-12-10.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

/**
 *  32位MD5加密
 */
- (NSString *)MD5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/**
 *  SHA1加密
 */
- (NSString *)SHA1
{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

/**
 *  base64加密
 */
- (NSString *)base64Encoding
{
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [plainData base64EncodedStringWithOptions:0];
}

/**
 *  base64解密
 */
- (NSString *)base64Decoding
{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
}







/***************************************************************************************************************************/

//判断是否为nil或者空格(一个或者多个空格)
- (BOOL)isEmpty
{
    if (!self) {
        return YES;
    }
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
    
    if ([trimedString length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  返回非nil字符串
 */
- (NSString *)returnNotNil
{
    if (self)
    {
        return self;
    }
    
    return @"";
}

/**
 *  json字符串 ---> json字典
 */
- (NSDictionary *)transferToJsonDict
{
    if (self == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
}


/**
 *  计算NSString高度
 */
- (CGFloat)heightWithFont:(UIFont *)font constraintToWidth:(CGFloat)width
{
    CGRect rect;
    
    float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosVersion >= 7.0)
    {
        rect = [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    }
    else
    {
        CGSize size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        rect = CGRectMake(0, 0, size.width, size.height);
    }
    
    NSLog(@"%@: W: %.f, H: %.f", self, rect.size.width, rect.size.height);
    return rect.size.height;
}

/**
 *  计算UILabel行数
 */
- (NSInteger)lineOfLabelFont:(UIFont *)font labelWidth:(NSInteger)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    
    return ceil(rect.size.height / font.lineHeight);
}







// 年月日string---->NSDate     "2015-12-11 12:53:35"  (24小时制格式化)
- (NSDate *)dateFromString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}



/**
 *  是否是纯数字
 */
- (BOOL)isPureNumandCharacters
{
    NSString *string = [self copy];
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
